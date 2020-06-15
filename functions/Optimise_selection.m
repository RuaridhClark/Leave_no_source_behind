function [selected,resources] = Optimise_selection(method,Adj,n_select,sources,sinks,intermeds,def_cnstrnt,fi_max)  
% Optimise selection either using method 'm' maximum flow or 'c' consensus leadership. 
% n_select      - defines the number of nodes to be given
% resources sources       - list all source nodes sinks         - lists all
% sink nodes intermeds     - lists all intermediate nodes between source
% and sink def_cnstrnt   - sets the resource allocation constraint fi_max
% - defines the maximum resource allocated to an individual node.
   
    selected=[]; candidates=1:length(sinks); 
    if strcmp(method,'m')                                   
        [Adj] = Adj4maxflow(Adj,sinks,sources);             % Add dummy sink and source nodes for max flow evaluation
        [selected,resources] = maxflow_selection(Adj,candidates,n_select,sinks,intermeds);
    elseif strcmp(method,'c')                               % consensus-based method
        tlimit = 5000;                                      % define convergence step limit
     	tstep = 0.999*1/max(sum(Adj,2));                    % define feasible time step that ensures convergence
        c = ones(length(sinks),1)./length(sinks); % define uniform resource vector
        [~,~,tfinal] = steps2consensus(c,Adj,sinks,sources,n_select,tlimit,tstep);% tfinal => 0.9*(number of steps to convergence)
        
        run = 1;                                            % while loop exit variable
        while run == 1                                      % Optimisation loop
            if length(selected)<(n_select-1) || n_select == 1
                c0 = ones(length(candidates),1)./length(candidates);    % define uniform resource vector
            else
                c0=c;
            end
            [c,candidates] = consensus_optimisation(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,tlimit,def_cnstrnt,fi_max);

            [selected,candidates,c] = update_resources(c,selected,candidates,n_select,Adj,sinks,def_cnstrnt);
                                                                          
            [run,resources] = prepare_output(c,def_cnstrnt,selected,n_select,sinks);% Prepare output if end of optimisation

            if run == 1                                     
                [tfinal] = update_tfinal(c,candidates,selected,n_select,Adj,sinks,sources,tlimit,tstep); % update tstep & tfinal for 'fn' constraint
            end
        end
    end
end



