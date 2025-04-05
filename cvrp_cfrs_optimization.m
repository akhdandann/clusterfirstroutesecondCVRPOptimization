clc
clear
%%
instance = xlsread('A-n32-k5')
%%
X = instance(:,2:3)
%%
depot = instance(1,:)
%%
X(1,:) = []
%%
figure;
plot(X(:,1),X(:,2),'.');
hold on
plot(depot(:,2),depot(:,3),'kx','MarkerSize',15,'LineWidth',3) 
title 'A-n33-k6 Dataset Scatter Plot';
% Cluster
% There appears to be two clusters in the data.
%% 
% Partition the data into two clusters, and choose the best arrangement out 
% of five initializations. Display the final output.

[idx, C, SUMD, D, MIDX, INFO] = kmedoids(X,5,'distance','seuclidean','replicates',3);
%% 
% By default, the software initializes the replicates separately using _k_-means++.
%% 
% Plot the clusters and the cluster centroids.

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
hold on
plot(X(idx==3,1),X(idx==3,2),'y.','MarkerSize',12)
hold on
plot(X(idx==4,1),X(idx==4,2),'m.','MarkerSize',12)
hold on
plot(X(idx==5,1),X(idx==5,2),'g.','MarkerSize',12)

plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',5,'LineWidth',1) 
title 'Cluster Assignments and Centroids'
hold off
%%
red_cluster = [X(idx==1,1) X(idx==1,2)]
blue_cluster =[X(idx==2,1) X(idx==2,2)]
yellow_cluster = [X(idx==3,1) X(idx==3,2)]
magenta_cluster = [X(idx==4,1) X(idx==4,2)]
green_cluster = [X(idx==5,1) X(idx==5,2)]
%%
after_cluster = [red_cluster; blue_cluster; yellow_cluster; magenta_cluster; green_cluster]
%%
after_cluster_node = {};
for i = 1:length(after_cluster)
    RowIdx = find(ismember(X, after_cluster(i,:),'rows'));
    after_cluster_node{end+1} = RowIdx+1;
end
%%
after_cluster_node = cell2mat(after_cluster_node)
%%
after_cluster_node = [1 after_cluster_node]
%%
truck_capacity = 100;
[fitness_cluster,route_sequence] = Obj_function_VRP_v3(instance,after_cluster_node,truck_capacity)
%%
for g = 1:length(route_sequence)
    disp(['Vehicle Route ' num2str(g) ': ' num2str(cell2mat(route_sequence{1,g}))]);
end
%%
number_pop = 500;
for n = 1:number_pop
    Pop(n,:) = randperm(length(instance));
end
Pop
%%
for i = 1:number_pop
    cost(i,:) = Obj_function_VRP_v3(instance,(Pop(i,:)),truck_capacity);
end
cost
%%
for n = 1:10/100*number_pop
    Pop(n,:) = after_cluster_node;
    cost(n,:) = fitness_cluster;
end
Pop
cost
%%
pbest = Pop;
f_pbest = cost;

[f_gbest,ind_f] = min(f_pbest);
gbest = pbest(ind_f,:);
BestFitIter(1) = f_gbest;
% Genetic Algorithm

%% Parameters
N = number_pop; % Population Size
G = length(instance); % Genome Size
PerMut = 1; % Probability of Mutation
S = 2; % Tournament Size
F = cost;
%%
LocalIter = 1200;
MaxIter = 100;
%%
for Gen = 1:MaxIter % Number of Generations
    %% Fitness
    for i = 1:number_pop
        cost(i,:) = Obj_function_VRP_v3(instance,(Pop(i,:)),truck_capacity);
    end
    %% Print Stats
    %fprintf('Gen: %d Mean Fitness: %d Best Fitness: %d\n', Gen, round(mean(F)), round(max(F)))

    %% Selection (Tournament)
    T = round(rand(2*N,S)*(N-1)+1); % Tournaments
    %[~,idx] = max(F(T),[],2); % Index to Determine Winners
    [~,idx] = min(F(T),[],2);
    W = T(sub2ind(size(T),(1:2*N)',idx)); % Winners

    %% Crossover (Single!Point Preservation)
    Pop2 = Pop(W(1:2:end),:); % Assemble Pop2 Winners 1
    P2A = Pop(W(2:2:end),:); % Assemble Pop2 Winners 2
    Lidx = sub2ind(size(Pop),[1:N]',round(rand(N,1)*(G-1)+1)); % ...
    %Select Point
    vLidx = P2A(Lidx)*ones(1,G); % Value of Point in Winners 2
    [r,c] = find(Pop2 == vLidx); % Location of Values in ... Winners 1
    [~,Ord] = sort(r); % Sort Linear Indices
    r = r(Ord); c = c(Ord); % Re!order Linear Indices
    Lidx2 = sub2ind(size(Pop),r,c); % Convert to Single Index
    Pop2(Lidx2) = Pop2(Lidx); % Crossover Part 1
    Pop2(Lidx) = P2A(Lidx); % Validate Genomes

    for i = 1:number_pop
        child_cost(i,:) = Obj_function_VRP_v3(instance,(Pop(i,:)),truck_capacity);
    end
    [sorted_child_cost, child_cost_idx] = sort(child_cost);
    Pop2 = Pop2(child_cost_idx,:);
    Pop2 = Pop2(1:number_pop,:);

    %% Mutation (Permutation)
    idx = rand(N,1)<PerMut; % Individuals to Mutate
    Loc1 = sub2ind(size(Pop2),1:N,round(rand(1,N)*(G-1)+1)); % Index ... Swap 1
    Loc2 = sub2ind(size(Pop2),1:N,round(rand(1,N)*(G-1)+1)); % Index ... Swap 2
    Loc2(idx == 0) = Loc1(idx==0); % Probabalistically Remove ... Swaps
    [Pop2(Loc1),Pop2(Loc2)] = deal(Pop2(Loc2), Pop2(Loc1)); % Perform ... Exchange

    [f_pbest,ind_f] = min(cost);
    pbest(Gen,:) = Pop(ind_f,:);
    pbest_now = Pop(ind_f,:);

    if f_pbest < f_gbest
        f_gbest = f_pbest;
        gbest = pbest_now;
    end

    for j = 1:LocalIter
        new_route = mutation_6(gbest,G);
        [new_route_cost, ~] = Obj_function_VRP_v3(instance,new_route,truck_capacity);
        if new_route_cost <= f_gbest
            f_gbest = new_route_cost;
            gbest = new_route;
        end
    end
    new_route_cost = f_gbest;
    BestFitIter(Gen) = f_gbest;

    disp(['Iteration ' num2str(Gen) ': Best fitness =' num2str(BestFitIter(Gen)) ' Best Route =' num2str(gbest)]); %BestFitIter(Gen)

    %% Reset Population
    Pop = Pop2;
    
end
%%
[~,gbest_route_sequence] = Obj_function_VRP_v3(instance,gbest,truck_capacity)
for g = 1:length(gbest_route_sequence)
    disp(['Vehicle Route ' num2str(g) ': ' num2str(cell2mat(gbest_route_sequence{1,g}))]);
end
%% Plot

plot(1:MaxIter,BestFitIter);
xlabel('Iteration');
ylabel('Best fitness');