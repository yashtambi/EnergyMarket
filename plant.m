classdef plant < handle
    properties (GetAccess=public)
        capacity
        efficiency      
        loan     
        onm
        age
    end
    
    properties
        marginal_cost
        fixed_cost
        total_cost
        plant_name
        plant_type
        availability
    end
end
        