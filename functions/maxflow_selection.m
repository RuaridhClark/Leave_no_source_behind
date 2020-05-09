function [selected,c] = maxflow_selection(Adj,candidates,n_select,sinks,intermeds)
    % Check max flow for each sink node individually before picking selection
    m=zeros(length(candidates),1);
    for i = 1 : length(candidates)      % check the maximum flow for each sink node individually
        select_in = candidates(i);
        candid_in=candidates(~ismember(candidates,select_in));
        [~,out] = max_flow(zeros(length(candid_in),1),Adj,sinks,intermeds,candid_in,select_in);
        m(i) = out;
    end    

    [~,I] = sort(m,'descend');          % Pick n_select sink nodes that deliver the largest maximum flow

    selected = I(1:n_select)';
    c = zeros(length(candidates),1);
    c(selected) = ones(length(selected),1);

end
