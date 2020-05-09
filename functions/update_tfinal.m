function [tfinal] = update_tfinal(c,candidates,selected,n_select,Adj,sinks,sources,tlimit,tstep)
    % Update tfinal 0.9*(time to consensus) for the latest resource allocation 'c'
    
    ct = zeros(77,1);
    if sum(c(candidates))>0
        ct(candidates) = (n_select-length(selected)).*(abs(c(candidates))./(sum(abs(c(candidates)))));
    end
    ct(selected) = ones(length(selected),1);
    ct(ct>1)=1;
    [~,~,tfinal] = steps2consensus(ct,Adj,sinks,sources,n_select,tlimit,tstep);
    
end