classdef plant < handle
    properties (GetAccess=private)
        capacity
        calorific_value
        fuel_price
        efficiency      
        availability     
        loan_amount     
        remaining_payments 
        onm_costs
        co2
        initialized = 0
    end
    
    properties (Constant)
        mw_to_mwh = 3600;
        mj_to_mwh = 1/3600;
    end
    
    properties
        marginal_cost
        fixed_cost
        total_cost
        plant_name
    end
    
    methods
        function obj = initialize(obj, plant_name, capacity, calorific_value, fuel_price, efficiency, loan_amount, onm_costs,remaining_payments, availability, co2)
            %{
                ******** Arguments ********
                plant_name        : Unique name for the plant
                capacity          : Generation capacity (in MWh)
                calorific_value   : (in MJ per unit fuel)
                fuel_price        : (in Euro / unit fuel)
                efficiency        : Plant efficiency (in %)
                loan_amount       : Fixed loan amount (in MEuro / yr)
                onm_costs         : Operation and Management Costs (in MEuro / yr)
                remaining_payments: Remaining years (in number of years)
                availability      : Plant availability this round
                (true/false)
                CO2 generation    : in kg / unit fuel
            %}
            obj.plant_name = plant_name;
            obj.capacity = capacity;
            obj.calorific_value = calorific_value * obj.mj_to_mwh;
            obj.fuel_price = fuel_price;
            obj.efficiency = efficiency / 100;
            obj.availability = sign(availability);
            obj.loan_amount = loan_amount * 1e6;
            obj.remaining_payments = remaining_payments;
            obj.onm_costs = onm_costs * 1e6;
            obj.co2 = co2;
            
            obj.initialized = 1;
            fprintf('Plant initialized successfully!\n');
        end
        
        function [marginal_cost, fixed_cost, total_cost] = get_costs(obj, hours)
            %{
                ******** Arguments ********
                hours: total operating hours
                
                ******** Returns ********
                marginal_cost : Fuel cost per unit MWh 
                fixed_cost    : Loan and OnM costs
                total_cost    : Average cost for running the plant for
                'hours' hours. Includes fixed and marginal costs
            
                All costs in Euro / MWh
            %}
            marginal_cost = (obj.fuel_price/obj.calorific_value)/obj.efficiency;
            if obj.initialized == 0
                error('Plant uninitialzed! Please initialize new plant first using Initialize method');
            end
            fixed_cost = obj.onm_costs;
            if obj.remaining_payments > 0i
                fixed_cost = fixed_cost + obj.loan_amount;
            end
            total_cost = marginal_cost + ((fixed_cost/obj.capacity)/hours);
            
            obj.marginal_cost = marginal_cost;
            obj.fixed_cost = fixed_cost;
            obj.total_cost = total_cost;
        end
        
        function [name, capacity, fuel_price]  = get_plant_stats(obj)
            name = obj.plant_name;
            capacity = obj.capacity;
            fuel_price = obj.fuel_price;
        end
        
        function plant_update(obj, fuel_price, remaining_payments, efficiency)
            obj.fuel_price = fuel_price;
            obj.remaining_payments = remaining_payments;
            obj.efficiency = efficiency;
            fprintf('Plant data updated successfully!\n');
        end
    end
end
        