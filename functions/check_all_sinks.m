function [c] = check_all_sinks(Adj,c0,candidates,selected,sinks,sources,n_select,tstep,tlimit)
    % Brute force search for final selection of sink node, using the number
    % of steps to consensus as the objective. If two nodes produce the
    % same number of steps to consensus, tstep is reduced until a difference 
    % is found or until operation exceeds iteration limit. 
    
    for i = 1:length(candidates)    % Try each ground station to check performance 
        select_opt = [selected,candidates(i)];
        c=zeros(length(sinks),1);
        c(select_opt)=ones(length(select_opt),1);
        [t,~,~] = steps2consensus(c,Adj,sinks,sources,n_select,tlimit,tstep);
        Tt(i)=t;
    end

    [~,I] = min(Tt);
    
    if length(find(Tt==min(Tt)))>1  % If two or more selections produce the same time to consensus then increase tstep
        Is = find(Tt==min(Tt));
        d=1;
        while max(Tt)<tlimit && length(find(Tt==min(Tt)))>1 && d<100 && max(Tt)<tlimit
            Tt=[];
            d = d*10;
            for j = 1 : length(Is)
                select_opt = [selected,candidates(Is(j))];
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
        end
        
        fT=find(Tt==min(Tt));
        if length(fT)==1
            [~,It] = min(Tt);
            I=Is(It(1));
        else
            [~,mI]=max(c0);       % choose best connected sinks from viable options
            I = Is(mI);
            warning('Final selection based on previous iterations resource assignment')
        end
    end

    % Define final selection
    c=zeros(length(c),1);
    select_opt = [selected,candidates(I)];
    c=zeros(length(c),1);
    c(select_opt)=ones(length(select_opt),1);
    c=c(candidates);
end