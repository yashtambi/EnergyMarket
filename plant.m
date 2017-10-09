classdef plant < handle
    properties (GetAccess=public)
        capacity
        av_capacity
        efficiency      
        loan     
        onm
        age
    end
    
    properties
        marginal_cost   % Cost per kWh
        co2_units       % Units of CO2 per kWh
        fuel_units      % Units of fuel consumed per kWh
        fixed_cost
        total_cost
        plant_name
        plant_type
        availability
    end
end
        