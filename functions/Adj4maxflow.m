function [Adj] = Adj4maxflow(Adj,sinks,sources)
    % Add dummy sink, connected to all other sink nodes, and
    % add dummy source node, connected to all other source nodes, for max flow evaluation
    Adj=[Adj,zeros(length(Adj),2);zeros(2,length(Adj)+2)];
    Adj(end-1,sources) = sum(Adj(sources,:),2)';
    Adj(sinks,end) = sum(Adj(:,sinks),1)';
        
end