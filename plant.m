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
        co2_units       % Units of CO2 per MWh
        co2_cost        % Cost of CO2 per MWh
        tot_marg_cost   % Total marginal cost (Fuel + CO2)
        fuel_units      % Units of fuel consumed per MWh
        fixed_cost
        total_cost
        plant_name
        plant_type
        availability
    end
end
        