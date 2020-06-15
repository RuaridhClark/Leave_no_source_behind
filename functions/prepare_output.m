function [run,resources] = prepare_output(c,def_cnstrnt,selected,n_select,sinks)
    % Set run==0 to exit while loop and update resource allocation vector 'resources'
    
    if strcmp(def_cnstrnt,'fn') && length(selected)>=n_select   % if all sinks selected
        run = 0;                                                % end optimisation
        resources=zeros(length(sinks),1);
        resources(selected)=ones(length(selected),1);
    elseif strcmp(def_cnstrnt,'fi')                             % if optimisation complete
        run = 0;                                                % end optimisation
        resources = n_select.*abs(c)./sum(abs(c));
    else
        run = 1;
        resources=[];
    end
end