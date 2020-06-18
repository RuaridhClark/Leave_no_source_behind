function [options] = define_options(def_cnstrnt,w)
% Define options for fmincon, where w includes number of nodes currently
% selected alongside total number to be selected.
    if strcmp(def_cnstrnt,'fn')
        options = optimoptions(@fmincon,'OutputFcn', @(c,optimValues,state)outfun(c,optimValues,state,w),'Algorithm','interior-point','UseParallel',true,'MaxIter',20,'MaxFunctionEvaluations',5000,'TolFun',1e-5);
    elseif strcmp(def_cnstrnt,'ft') || strcmp(def_cnstrnt,'fi')
        options = optimoptions(@fmincon,'Algorithm','sqp','UseParallel',true,'MaxIter',50,'MaxFunctionEvaluations',5000,'TolFun',1e-4);
    end
end