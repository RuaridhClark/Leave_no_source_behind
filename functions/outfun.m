%% Check for resources >= 1
function stop = outfun(c, ~, ~, w) 
    stop = false;
    
    c=(w(1)-w(2))*abs(c)./sum(abs(c));
    
    if max(c)>=1
        stop=true;
    end
end