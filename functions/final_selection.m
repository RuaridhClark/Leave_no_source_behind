function [c] = final_selection(Adj,c0,candidates,selected,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max)
    % Brute force search for final selection of sink node, using the mean
    % consensus state as the objective. If two nodes produce the same mean
    % consensus, the final selection is based on the optimised resource 
    % allocation. 
    
    choose=find(c0>0.01);                   % ignore sinks with small resource allocation
    if isempty(choose)                      % avoid empty choose if resources split across many sinks
        choose=find(c0>0);                       
    end
    chosen=choose(~ismember(choose,selected));  % select resourced sink nodes that are un-selected
    c=[];
    for i = 1:length(chosen)                    % Try each ground station to check performance 
        select_opt = [selected;chosen(i)];
        [m,~] = mean_consensus_state(c,Adj,[],select_opt,sinks,sources,tstep,tfinal,def_cnstrnt,fi_max);
        Mm(i)=m;
    end
    
    [sm,I]=sort(Mm,'asc');
    if length(find(Mm==min(Mm)))==1 % if the minimum value is unique
        [~,I]=min(Mm);              % make final selection
    else
        [~,I]=max(c0(chosen));  	% choose best resourced sink node from optimiser
        warning('Final selection based on previous iterations resource assignment')
    end

    % Define final selection
    c=zeros(length(candidates),1);
    c(find(candidates==chosen(I)))=1;
end