function [selected,resources] = Optimise_selection(Adj,n_select,sources,sinks,intermeds,def_cnstrnt,fi_max,method)  

	selected=[]; candidates=1:length(sinks); 
    c0 = ones(length(candidates),1)./length(candidates);    % define uniform resource vector

    if strcmp(method,'m')                                   
        [Adj] = Adj4maxflow(Adj,sinks,sources);             % Add dummy sink and source nodes for max flow evaluation
        [selected,resources] = maxflow_selection(Adj,candidates,n_select,sinks,intermeds);
    elseif strcmp(method,'c')                               % consensus-based method
        Adj=Adj^2;                                          % create 2-hop Adjacency matrix
        tlimit = 5000;                                      % define convergence step limit
        tstep = 0.999*1/max(sum(Adj,2));                    % define feasible time step
        [~,~,tfinal] = steps2consensus(c0,Adj,sinks,sources,n_select,tlimit,tstep);% tfinal => 0.9*(number of steps to convergence)

        run = 1;                                            % while loop exit variable
        while run == 1                                      % Optimisation loop
            c0 = ones(length(candidates),1)./length(candidates);% define uniform resource vector
            [c] = consensus_optimisation(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,tlimit,def_cnstrnt,fi_max);

            [selected,candidates,c] = update_resources(c,selected,candidates,n_select,Adj,def_cnstrnt);

            [run,resources] = prepare_output(c,def_cnstrnt,candidates,selected,n_select);% Prepare output if end of optimisation

            if run == 1                                     % update tstep & tfinal for 'fn' constraint
                [tfinal] = update_tfinal(c,candidates,selected,n_select,Adj,sinks,sources,tlimit,tstep);
            end
        end
    end
end



