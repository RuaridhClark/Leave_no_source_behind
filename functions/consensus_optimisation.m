function [c,candidates] = consensus_optimisation(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,tlimit,def_cnstrnt,fi_max)
    % Maximise the mean state of all source nodes, where consensus state is 1, to make selection.
    % In 'fn' constraint, perform brute force search on last selection, by assessing steps to consensus.
    
    [options] = define_options(def_cnstrnt,[n_select,length(selected)]);                 % define fmincon options
    [A,b,Aeq,beq,lb,ub,nonlcon] = define_constraints(selected,candidates,n_select,def_cnstrnt,fi_max); % define fmincon constraints

    if strcmp(def_cnstrnt,'fn')                                     % OPT START: If making a fixed number of sink node selections
        if (n_select - length(selected))>1                        % If there is more than one node to be selected
            f=@(c)mean_consensus_state(c,Adj,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max);
            [c0,~] = fmincon(f,c0,A,b,Aeq,beq,lb,ub,nonlcon,options);% Optimise resource c0 with fmincon
            if max(c0)<1                                            % If no sink node resource <1 then try to power optimise then numerically optimise
                [c0,~,~] = power_optimise(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,def_cnstrnt,fi_max);% Scale resources according to power optimisation
                sign_c0=find(c0>0.01);
                candidates=candidates(sign_c0); % remove cand. with less than ~0 resources assigned from optimisation
                c0=c0(sign_c0);
                [A,b,Aeq,beq,lb,ub,nonlcon] = define_constraints(selected,candidates,n_select,def_cnstrnt,fi_max); % define fmincon constraints
                f=@(c)mean_consensus_state(c,Adj,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max);
                [c0,~] = fmincon(f,c0,A,b,Aeq,beq,lb,ub,nonlcon,options);
                if max(c0)<1                                        % If no sink node resource <1 then try to power optimise
                    [c0,~,~] = power_optimise(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,def_cnstrnt,fi_max);% Scale resources according to power optimisation
                    if max(c0)<1                                    % If no sink node resource <1 then use zeros for input vector
                        c0=zeros(length(c0),1);                     % Zeros produce better selection using gradient when there are no outstanding candidates
                        [c0,~] = fmincon(f,c0,A,b,Aeq,beq,lb,ub,nonlcon,options);
                    end
                end
            end
            c=c0;
        else                                                        % if only one sink required, then check every sink for the best final selection
            [c] = final_selection(Adj,c0,candidates,selected,sinks,sources,n_select,tstep,tlimit);
        end
    elseif strcmp(def_cnstrnt,'fi')                                 % OPT START: If making a variable resource allocation                                                           
        m=1; save_m=2;                                              % initial while loop variables
        while m<save_m
            f=@(c)mean_consensus_state(c,Adj,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max);
            save_c0=c0;
            save_m=m;
            [c0,~] = fmincon(f,c0,A,b,Aeq,beq,lb,ub,nonlcon,options);% Optimise resource c0 with fmincon
            [c0,m,~] = power_optimise(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,def_cnstrnt,fi_max);% Scale resources according to power optimisation
            while m<=save_m
                save_c0=c0;
                c0(c0==min(c0(c0>0)))=0;
                save_m=m;
                [c0,m,~] = power_optimise(c0,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,def_cnstrnt,fi_max);% Scale resources according to power optimisation
            end
            c0=save_c0;
            [tfinal] = update_tfinal(c0,candidates,selected,n_select,Adj,sinks,sources,tlimit,tstep);% Update tfinal based on resource allocation
        end
        if m>save_m
            c=save_c0;
        else
            c=c0;
        end
    end
    
end