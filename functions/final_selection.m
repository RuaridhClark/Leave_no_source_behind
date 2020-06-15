function [c] = final_selection(Adj,c0,candidates,selected,sinks,sources,n_select,tstep,tlimit)
    % Brute force search for final selection of sink node, using the number
    % of steps to consensus as the objective. If two nodes produce the
    % same number of steps to consensus, tstep is reduced until a difference 
    % is found or until operation exceeds iteration limit. 
    
    choose=find(c0>0.01);
    chosen=choose(~ismember(choose,selected)); % select resourced sink nodes that are un-selected
    for i = 1:length(chosen)    % Try each ground station to check performance 
        select_opt = [selected;chosen(i)];
        c=zeros(length(sinks),1);
        c(select_opt)=ones(length(select_opt),1);
        [t,~,~] = steps2consensus(c,Adj,sinks,sources,n_select,tlimit,tstep);
        Tt(i)=t;
    end
    
    if length(find(Tt==min(Tt)))>1  % If two or more selections produce the same time to consensus then increase tstep
        Is = find(Tt==min(Tt));
        d=1;
        while max(Tt)<tlimit && length(find(Tt==min(Tt)))>1 && d<20 && max(Tt)<tlimit
            Tt=[];
            d = d+2;
            for j = 1 : length(Is)
                select_opt = [selected;chosen(Is(j))];
                c=zeros(length(c),1);
                c(select_opt)=ones(length(select_opt),1);
                [t,~,~] = steps2consensus(c,Adj,sinks,sources,n_select,tlimit,tstep/d); %note tstep/d
                Tt(j)=t;
                if t == tlimit  % if t is too long break from loop
                    Tt = [Tt,Tt];
                    warning('Exiting final sink node selection loop')
                    break
                end
            end
            Is = Is(find(Tt==min(Tt)));
        end
        
        if length(Is)==1
            I=Is;
        else
            [~,I]=max(c0(chosen));       % choose best resourced sink node from optimiser
            warning('Final selection based on previous iterations resource assignment')
        end
    else
        [~,I] = min(Tt);
    end

    % Define final selection
    c=zeros(length(candidates),1);
    c(find(candidates==chosen(I)))=1;
%     select_opt = [selected,chosen(I)];
%     c=zeros(length(sinks)-length(select,1);
%     c(select_opt)=ones(length(select_opt),1);
end