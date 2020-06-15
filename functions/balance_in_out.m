function [Adj] = balance_in_out(Adj,sinks,intermeds)

for i = 1 : length(intermeds)
    si=intermeds(i);
    sum_in=sum(Adj(:,si));
    sum_out=sum(Adj(si,sinks));
%     if sum_out>sum_in
        Adj(:,si)=Adj(:,si)./(sum_in/sum_out);
%     elseif sum_in>sum_out
%         Adj(si,sinks)=Adj(si,sinks)./(sum_out/sum_in);
    end
end