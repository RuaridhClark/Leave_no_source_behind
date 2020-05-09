function [t,x,tfinal] = steps2consensus(c,Adj2,sinks,sources,n_select,tlimit,tstep)
    % Assess the number of steps to consensus, for a given tstep, then define tfinal
    
    c = abs(c);
    if sum(c)>0
        c = n_select*c./sum(c); % ensure sum of resources equals n_select
    end
    
    B = ones(1,length(Adj2)); 
    B(sinks) = c;               % define all sink node resource

    Adj2 = Adj2.*B;             % apply resource allocation
    D = sum(Adj2,2);            % diagonal matrix
    L = diag(D)-Adj2;           % Laplacian matrix
    
    x = zeros(length(Adj2),1); x(sinks)=ones(length(sinks),1);  % define initial states
    x = [x,zeros(size(x,1),tlimit)];                            % create empty matrix after initial state

    % Propagate dynamics until consensus or time limit is reached
    t = 1;
    while mean(x(sources,t))<0.99 && t<tlimit
        xdot = -L*x(:,t);
        x(:,t+1) = x(:,t)+xdot*tstep;
        t = t+1;
    end
    
    if t == tlimit
        warning(['Did not converge within ',num2str(tlimit),' steps'])
        tfinal=t;
    else
        tfinal = round(t*0.9);      % assess mean source state at this step
    end

end