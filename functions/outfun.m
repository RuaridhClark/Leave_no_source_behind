function stop = outfun(c, ~, ~, w) 
% Output function that checks if resources greater than 1 have been allocated.
    stop = false;
    
    c=(w(1)-w(2))*abs(c)./sum(abs(c));
    
    if max(c)>=1
        stop=true;
    end
end