% Run sink resource optimiser for "leave no source behind" consensus-based optimisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Outputs %%%
% selected - the sinks selected for resource allocation of 1 ('ft' case)
% resources - the resource allocation across sink nodes (all cases)
%%% %%% %%% %%%

clear all
fncts_folder = [cd,'\functions']; addpath(fncts_folder)

%%% Optimisation Choices %%%
def_cnstrnt = 'fn';     % set resource constraint: fixed number == 'fn', fixed individual & total resource = 'fi', fixed total resource = 'ft'                 
method = 'm';           % method choice: consensus-based == 'c', maximum flow == 'm'
n_select = 30;          % number of ground stations
fi_max = 10;            % max individual resource for 'fi' constraint
%%% %%% %%% %%%% %%% %%% %%%

%%% Parallelise %%%
if strcmp(method,'c')
    if max(size(gcp)) == 0	% parallel pool needed
        parpool             % create the parallel pool
    end
end
%%% %%% %%% %%% %%%


%%% Inputs %%%
load('Adj_100day.mat', 'Adj')   % Adjacency matrix from 100 day of contacts where time connected to ground station (sink) is divided by the number of nodes in contact with sink at a given time step
sources = 1:250;               	% source nodes included
intermeds = 251:334;          	% intermediary nodes
sinks = 335:411;               	% sink nodes included
if strcmp(def_cnstrnt,'fn')
    fi_max = 1;
end       
%%% %%  %% %%%

%%% Optimisation %%%
[selected,resources] = Optimise_selection(Adj,n_select,sources,sinks,intermeds,def_cnstrnt,fi_max,method); % Optimise resource allocation
%%% %% %%  %% %% %%%