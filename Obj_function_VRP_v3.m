function [c, route_sequence] = Obj_function_VRP_v3(instance,node_shuffle,truck_capacity)
[route_sequence,depot_vrp,instance_without_depot] = RouteVRP_v3(instance,node_shuffle,truck_capacity);
c = CostVRP_v3(route_sequence,depot_vrp,instance_without_depot);
end