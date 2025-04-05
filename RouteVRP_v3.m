function [route_sequence,depot_vrp,instance_without_depot] = RouteVRP_v3(instance,node_shuffle,truck_capacity)

instance(:,1) = instance(:,1) - 1;
depot_vrp = instance(1,:);
instance_without_depot = instance;
instance_without_depot(1,:) = [];

depot_idx = 0;
node_shuffle = node_shuffle-1;
node_shuffle = node_shuffle(~ismember(node_shuffle,depot_idx));

p = [depot_vrp(1,1) node_shuffle];

route = {};
route_sequence = {};
updated_machine_load = 0;
depot = p(1);
for i = 1:length(p)
    if p(i) == depot
        route(end+1) = {p(i)};
        updated_machine_load;
    elseif p(i) ~= 0
        updated_machine_load = updated_machine_load + instance_without_depot(p(i),4);
        if updated_machine_load < truck_capacity
            route(end+1) = {p(i)};
            if i == length(p) && updated_machine_load < truck_capacity
                route(end+1) = {depot};
                route_sequence(end+1) = {route};
            end
        elseif updated_machine_load >= truck_capacity
            route(end+1) = {depot};
            route_sequence(end+1) = {route};
            updated_machine_load = instance_without_depot(p(i),4);
            route = {};
            route(end+1) = {depot};
            route(end+1) = {p(i)};
            if i == length(p) && updated_machine_load >= truck_capacity
                route(end+1) = {depot};
                route_sequence(end+1) = {route};
            elseif i == length(p) && updated_machine_load < truck_capacity
                route(end+1) = {depot};
                route_sequence(end+1) = {route};
            end
        end
    end
end
end