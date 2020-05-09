function [m,out] = max_flow(c,Adj,sinks,intermeds,candidates,selected)

    v=zeros(length(candidates)+length(selected),1);
    v(candidates)=c;
    v(selected,1)=ones(length(selected),1);
    v=abs(v);
    
    Adj(intermeds,sinks) = Adj(intermeds,sinks).*v';
    
    G=digraph(Adj);
    L=length(Adj);

    out = maxflow(G,L-1,L,'augmentpath');
    m = -out;      % objective to be minimised
    
end