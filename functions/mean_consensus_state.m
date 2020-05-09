function [m,x] = mean_consensus_state(c,Adj,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max)
    % Assess the mean state of all source nodes at step 'tfinal'

    if strcmp(def_cnstrnt,'fi')
        c(c>fi_max)=fi_max;
    end
    
    v(candidates) = abs(c);
    v(selected) = fi_max*ones(1,length(selected));

    B = ones(1,length(Adj)); 
    B(sinks) = v;                   % define all sink node resource allocations

    Adj=Adj.*B;                     % apply resource allocation
    D=sum(Adj,2);                   % diagonal matrix
    L=diag(D)-Adj;                  % Laplacian matrix
 
    % define initial states
    x=zeros(length(Adj),1); x(sinks)=ones(length(sinks),1);
    x=[x,zeros(size(x,1),tfinal)];	% create empty matrix after initial step

    for t = 1 : tfinal-1
        xdot = -L*x(:,t);
        x(:,t+1)=x(:,t)+xdot*tstep;
    end
    
    if max(x(:))>2
         warning(['Node divergence from consensus state'])
    end
   
    m=1-mean(x(sources,t+1));       % objective function
end