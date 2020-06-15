function [A,b,Aeq,beq,lb,ub,nonlcon] = define_constraints(selected,candidates,n_select,def_cnstrnt,fi_max)
    % Define fmincon constraints for different def_cnstrnt

    if strcmp(def_cnstrnt,'fn') || strcmp(def_cnstrnt,'fi')
        % Define fmincon constraints
        A = ones(1,length(candidates));
        b = n_select-length(selected);
        Aeq = [];
        beq = [];
        lb = -0.001*ones(length(candidates),1);         % allow resource below 0 for optimiser to filter
        ub = (fi_max+0.01)*ones(length(candidates),1);  % allow resource above 1 for optimiser to filter
        nonlcon=[];
    elseif strcmp(def_cnstrnt,'ft')
        % Define fmincon constraints
        A = ones(1,length(candidates));
        b = n_select;
        Aeq = [];
        beq = [];
        lb = -0.001*ones(length(candidates),1);
        if n_select>10
            ub = 10*ones(length(candidates),1);
        else
            ub = n_select*ones(length(candidates),1);
        end
        nonlcon=[];
    end
end