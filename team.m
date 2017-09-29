classdef team < handle
    properties(Constant, Access=private)
       plant_types = ["coal", "ccgt", "ocgt", "nuclear", "wind"]; 
    end
    
    properties
        name;
        plants;
        num_plants = 0;
        total_capacity = 0;
        total_fixed_costs = 0;
    end
    
    methods
        function set_name (obj, name)
           obj.name = name;
        end
        
        function add_plant(obj, name, type, capacity, efficiency, loan, onm, availability)
            %Todo: validate if exact same plant already exists
            
            %Validate PowerPlant type
            flag = false;
            for i = 1:length(obj.plant_types)
               if((strcmp(type, obj.plant_types(i)) == 1))
                   flag = true;
                   break
               end
            end
            
            if flag == false
                error('Illegal plant type');
            end
            
            if efficiency>100
                error('Plant efficiency cannot be > 100');
            end
            
            if ~isa(availability, 'logical')
                error('Plant Availability: please enter true or false');
            end
            
            if(isempty(obj.plants))
                obj.plants = plant;        
            end
            
            obj.num_plants = obj.num_plants + 1;
                   
            obj.plants(obj.num_plants).plant_name = name;
            obj.plants(obj.num_plants).plant_type = type;
            obj.plants(obj.num_plants).capacity = capacity;
            obj.plants(obj.num_plants).efficiency = efficiency/100;
            obj.plants(obj.num_plants).loan = loan*10e6;
            obj.plants(obj.num_plants).onm = onm*10e6;  
            obj.plants(obj.num_plants).availability = availability;  
            obj.total_capacity = obj.total_capacity + capacity;
            
            fprintf('\tNew powerplant \"%s\" added to team\n',obj.plants(obj.num_plants).plant_name);
        end
        
        function dismantle_plant(obj, name)
            for i = 1:length(obj.plants)
               if(strcmp(name, obj.plants(i).plant_name)==1)
                   obj.total_capacity = obj.total_capacity - obj.plants(i).capacity;
                   obj.plants(i) = obj.plants(length(obj.plants));
                   obj.plants(length(obj.plants)) = [];
                   obj.num_plants = obj.num_plants - 1; 
                   fprintf('\tPlant \"%s\" dismantled\n', name);
                   return;
               end
            end
            error('Team has no such plant');
        end
        
        function get_costs(obj,fuel,toprint)
            obj.total_fixed_costs = 0;
            flag = true;
            if ~exist('toprint','var')
                flag = true;
            else
                flag = toprint;
            end
            
            for i = 1:length(obj.plants)
                obj.total_fixed_costs = obj.total_fixed_costs + obj.plants(i).onm + obj.plants(i).loan;
                if obj.plants(i).availability == 0
                    fprintf('%s plant not available this round\n',obj.plants(i).plant_name);
                    continue;
                end
                switch (obj.plants(i).plant_type)
                    case "coal"
                        obj.plants(i).marginal_cost = (fuel.coal_price/fuel.coal_cal_value)/obj.plants(i).efficiency;
                    case {"ccgt", "ocgt"}
                        obj.plants(i).marginal_cost = (fuel.gas_price/fuel.gas_cal_value)/obj.plants(i).efficiency;
                    case "nuclear"
                        obj.plants(i).marginal_cost = (fuel.uranium_price/fuel.uranium_cal_value)/obj.plants(i).efficiency;
                    case "wind"
                        obj.plants(i).marginal_cost = 0;
                end
                if flag == true
                    fprintf('%s plant (type %s) marginal cost: %2.4f per MWh\n',obj.plants(i).plant_name, obj.plants(i).plant_type, obj.plants(i).marginal_cost);
                end
            end
        end
        
        function [tot,av] = get_capacity(obj, fuels)
            av = 0;
            tot = 0;
            for i = 1:length(obj.plants)
               if(obj.plants(i).plant_type == "wind")
                   tot = tot + (obj.plants(i).availability*obj.plants(i).capacity);
                   av = av + (obj.plants(i).availability*obj.plants(i).capacity*fuels.wind_availability);
               else
                   tot = tot + (obj.plants(i).availability*obj.plants(i).capacity);
                   av = av + (obj.plants(i).availability*obj.plants(i).capacity);
               end
            end
            obj.total_capacity = tot;
            obj.available_capacity = av;
        end
        
        function update_plant(obj, name, feild, value)
           for i = 1:length(obj.plants)
               if obj.plants(i).plant_name == name
                   switch feild
                       case "availability"
                           if ~isa(value, 'logical')
                               error('Illegal Input, value should be either true or false');
                           end
                           
                           obj.plants(i).availability = value;
                           return;
                       case "capacity"
                           obj.plants(i).capacity = value;
                           return;
                       case "loan"
                           obj.plants(i).loan = loan;
                           return;
                       case "onm"
                           obj.plants(i).onm = value;
                           return;
                       otherwise
                           error('Illegal Input');
                   end
               end
           end
           error('Plant not found!');    
        end
    end
end