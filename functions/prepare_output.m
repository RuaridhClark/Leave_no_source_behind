function [run,resources] = prepare_output(c,def_cnstrnt,candidates,selected,n_select)
    % Set run to exit while loop and update resource allocation vector 'resources'
    
    if strcmp(def_cnstrnt,'fn') && length(selected)>=n_select   % if all sinks selected
        run = 0;                                                % end optimisation
        resources=zeros(length(candidates)+length(selected),1);
        resources(selected)=ones(length(selected),1);
    elseif strcmp(def_cnstrnt,'fi') || strcmp(def_cnstrnt,'ft') % if optimisation complete
        run = 0;                                                % end optimisation
        resources = n_select.*abs(c)./sum(abs(c));
    else
        run = 1;
        resources=[];
    end
end