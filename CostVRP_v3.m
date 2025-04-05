function c = CostVRP_v3(route_sequence,depot_vrp,instance_without_depot)
c = 0;
for g = 1:length(route_sequence)
    aaa = cell2mat(route_sequence{1,g});
    for i = 1:length(aaa)
        if i+1 >length(aaa)
            break
        end
        if aaa(i) == 0
            x1 = depot_vrp(1,2);
            y1 = depot_vrp(1,3);
            x2 = instance_without_depot(aaa(i+1),2);
            y2 = instance_without_depot(aaa(i+1),3);
        elseif aaa(i) ~= 0
            x1 = instance_without_depot(aaa(i),2);
            y1 = instance_without_depot(aaa(i),3);
            if aaa(i+1) ~= 0
                x2 = instance_without_depot(aaa(i+1),2);
                y2 = instance_without_depot(aaa(i+1),3);
            elseif aaa(i+1) == 0
                x2 = depot_vrp(1,2);
                y2 = depot_vrp(1,3);
            end
        end
        % Euclidean Distance
        c = c + round(sqrt((x2-x1)^2 + (y2-y1)^2));
    end
end
end