function [c0,m,p] = power_optimise(c,candidates,selected,n_select,sinks,sources,Adj,tstep,tfinal,def_cnstrnt,fi_max)
    % Simple power optimisation of resource vector 'c', where each vector
    % entry is raised to the same power before scaling the whole vector to
    % not exceed its maximum size. Optimisation ends when increasing the
    % power no longer returns an improvement in mean consensus state of all
    % source nodes. (binary search could be implemented to improve
    % efficiency)

    n=0; out=-1;                            % Initial values
    p=0.5;                                  % power variable
    cp=c;
    if sum(cp)>0    
        while n>out
            p=p+0.5;                        % p starts at 1 then increase by 0.5 each iteration
            cp=abs(c).^p;                   % Scale each entry by power p  
            n_res=n_select-length(selected);
            cp=n_res*cp./sum(cp);           % Scale whole vector to not exceed n_res
            if strcmp(def_cnstrnt,'fn') || strcmp(def_cnstrnt,'fi')
                list = 1:length(cp);
                while max(cp(list))>fi_max  % Ensure all resources below fi_max
                    cp(cp>fi_max)=fi_max;
                    list=find(cp<fi_max);
                    cp(list)=(n_res-(length(cp)-length(list))*fi_max)*cp(list)./sum(cp(list));
                end
            end
            out=n;
            [m,~] = mean_consensus_state(cp,Adj,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max);
            n=1-m;
        end
        
        p=p-0.5;                            % Return to optimal power variable
        c0=abs(c).^p;                       % Return to optimal resource allocation
        c0=n_res*c0./sum(c0);
        if strcmp(def_cnstrnt,'fn') || strcmp(def_cnstrnt,'fi')
            list = 1:length(c0);
            while max(c0(list))>fi_max      % Ensure all resources below fi_max
                c0(c0>fi_max)=fi_max;
                list=find(c0<fi_max);
                c0(list)=(n_res-(length(c0)-length(list))*fi_max)*c0(list)./sum(c0(list));
            end
        end
        m=1-out;
    else 
        m=1;
    end
end
    