function [Adj2] = Adj2_maxflow_weight(Adj)
% Create 2-hop adjacency matrix where the weight of the connection from
% source to sink is defined by the maximum flow.

    Adjb=Adj;
    Adjb(Adjb>0) = 1;

    Adj2=Adjb^2;

    tic
    G=digraph(Adj);
    for i = 1 : length(Adj2)
        conns=find(Adj2(i,:)>0);
        for j = 1 : length(conns)
            sj=conns(j);
            out = maxflow(G,i,sj,'augmentpath');
            Adj2(i,sj)=out;
        end
    end

end