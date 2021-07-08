% Run sink resource optimiser for "leave no source behind" consensus-based optimisation

%%% Outputs %%%
% selected - the sinks selected for resource allocation of 1 ('ft' case)
% resources - the resource allocation across sink nodes (all cases)
%%% %%% %%% %%%

% Compare consensus selection with that of Max Flow

clear all
fncts_folder = [cd,'\functions']; 
results_folder = [cd,'\results']; 
addpath(fncts_folder,results_folder)

%%% Optimisation Setup %%%
def_cnstrnt = 'fn';         % set resource constraint: fixed number == 'fn', fixed individual & total resource = 'fi'                
all_methods = [1,2,3];      % method choice: consensus-based == 'c', maximum flow == 'm'
n_select = 10;              % number of ground stations
fi_max = 5;                 % max individual resource for 'fi' constraint
arch = 1;                   % select 100 cases from 3 predefined architectures 
%%% %%% %%% %%% %%% %%% %%%

if arch == 1
    load('data/rand_40src_10sat_10GS.mat')
elseif arch == 2
    load('data/rand_20src_40sat_10GS.mat')
elseif arch == 3
    load('data/rand_5src_20sat_10GS.mat')
end

cons_data = all_data;

%%% Parallelise %%%
if any(all_methods==2)
    if max(size(gcp)) == 0      % parallel pool needed
        parpool                 % create the parallel pool
    end
end
%%% %%% %%% %%% %%%

%%% Inputs %%%
Adj2 = [];                      % Empty 2-hop adjacency

if strcmp(def_cnstrnt,'fn')
    fi_max = 1;
end       
%%% %%% %%% %%%

for i = 1:100
    run_data = all_data{i};
    for j = 1 : length(all_methods)
        if all_methods(j) == 1
            method = 'm'; 
        elseif all_methods(j) == 2
            method = 'c'; 
        elseif all_methods(j) == 3
            method = 'g';
        end
        load('data/Adj_100day_random.mat', 'Adj')   % 300 sources, 100 sats, 77 GS	% Adjacency matrix from 100 day of contacts 

        sinks = 401:477;                            % sink nodes included

        sources = cons_data{i}.sources;
        save_sources = sources;

        intermeds = cons_data{i}.intermeds;
        save_intermeds = intermeds;

        %%% Optimisation %%%
        tic
        if isempty(Adj2) && strcmp(method,'c')
            Adj = Adj^2;
        elseif ~isempty(Adj2) && strcmp(method,'c')
            Adj=Adj2;
        end

        %%% Reduce Adj %%%
        Adj=Adj([sources,intermeds,sinks],[sources,intermeds,sinks]);
        sources=(1:length(sources));
        sm_si = length(sources)+length(intermeds);
        intermeds=(length(sources)+1:sm_si);
        sinks = (sm_si+1:sm_si+length(sinks));
        %%%

        [selected,resources] = Optimise_selection(method,Adj,n_select,sources,sinks,intermeds,def_cnstrnt,fi_max); % Optimise resource allocation
        time=toc;

        run_data.time = time;
        if method == 'c'
            run_data.selected = selected;
        elseif method == 'm'
            run_data.selectedMF = selected;
        elseif method == 'g'
            run_data.selectedG = selected;
        end
        run_data.intermeds = sort(save_intermeds);
        run_data.sources = sort(save_sources);

        all_data(i) = {run_data};
    end
end
%%% %%% %%% %%% %%%