function [selected,candidates,c0] = update_resources(c,select_in,candidate_in,n_select,A,def_cnstrnt)
    % Add to the list of 'selected' sink nodes and update the resource
    % vector 'c0' accordingly.

    if strcmp(def_cnstrnt,'fn')
        c0(select_in)=ones(length(select_in),1);
        c0(candidate_in)=(n_select-length(select_in))*abs(c)./sum(abs(c));
        
        if length(select_in)==length(find((c0)>=1))     % if no candidates have c0>=1
            if isempty(candidate_in)                    % if no candidates exist
                mx=1;
            else
                [mx,~] = max(c0(candidate_in));
            end
            candidates=find((c0)>0 & c0<mx);
            chosen=find((c0)>=mx);
        else
            candidates=find((c0)>=0 & c0<1);
            chosen=find((c0)>=1);
        end    
        if length(chosen)>n_select                      % if more viable sinks than required
            opts=chosen(~ismember(chosen,select_in));
            [~,I]=sort(sum(A(:,opts)),'descend');       % choose best connected sinks from viable options
            selected = [select_in;opts(I(1:(n_select-length(select_in))))];
            warning('final selections based on sink node outdegree')
        else
            selected=chosen;
        end
    else
        selected=select_in;
        candidates=candidate_in;
    end
    
    c0(select_in)=ones(length(select_in),1);
    c0(candidate_in)=(n_select-length(select_in))*abs(c)./sum(abs(c)); 
    
end