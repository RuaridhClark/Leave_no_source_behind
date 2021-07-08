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
%%% %%% %%% %%% %%% %%% %%%

%%% Parallelise %%%
if any(all_methods==2)
    if max(size(gcp)) == 0	% parallel pool needed
        parpool             % create the parallel pool
    end
end
%%% %%% %%% %%% %%%

%%% Inputs %%%
Adj2 = [];                      % Empty 2-hop adjacency
n_src = 40;                     % number of source nodes included
n_int = 10;                   	% number of intermediary nodes

if strcmp(def_cnstrnt,'fn')
    fi_max = 1;
end       
%%% %%% %%% %%%

for i = 1:100
    for j = 1 : length(all_methods)
        if j == 1
            %% Randomise sources
            sources = ones(1,n_src);
            while length(unique(sources)) ~= n_src % Ensures sources are a list of unique integers
                sources = randi([1 300],1,n_src);
                save_sources = sources;
            end

            %% Randomise satellites
            inter_range = 301:400;
            if n_int < 100
                intermeds = ones(1,n_int);
                while length(unique(intermeds)) ~= n_int % Ensures sources are a list of unique integers
                    intermeds = randi([inter_range(1) inter_range(end)],1,n_int);
                    save_intermeds = intermeds;
                end
            else
                intermeds = inter_range;
                save_intermeds = intermeds;
            end
        end
            
        if all_methods(j) == 1
            method = 'm'; 
        elseif all_methods(j) == 2
            method = 'c'; 
        elseif all_methods(j) == 3
            method = 'g'; 
        end
        
        load('data/Adj_100day_random.mat', 'Adj') % 300 sources, 100 sats, 77 GS	% Adjacency matrix from 100 day of contacts where time connected to ground station (sink) is divided by the number of nodes in contact with sink at a given time step

        sinks = 401:477;               	% sink nodes included

        %%% Optimisation %%%
        tic
        if isempty(Adj2) && strcmp(method,'c')
            Adj = Adj^2;
        elseif ~isempty(Adj2) && strcmp(method,'c')
            Adj=Adj2;
        end

        %%% Reduce Adj %%%
        Adj=Adj([sources,intermeds,sinks],[sources,intermeds,sinks]);
        input_sources=(1:length(sources));
        sm_si = length(input_sources)+length(intermeds);
        input_intermeds=(length(input_sources)+1:sm_si);
        sinks = (sm_si+1:sm_si+length(sinks));
        %%%

        [selected,resources] = Optimise_selection(method,Adj,n_select,input_sources,sinks,input_intermeds,def_cnstrnt,fi_max); % Optimise resource allocation
        time=toc;

        run_data.time = time;
        if method == 'm'
            run_data.selectedMF = selected;
        elseif method == 'c'
            run_data.selected = selected;
        elseif method == 'g'
            run_data.selectedG = selected;
        end
        run_data.intermeds = sort(save_intermeds);
        run_data.sources = sort(save_sources);

        all_data(i) = {run_data};
    end
end
%%% %%% %%% %%% %%%