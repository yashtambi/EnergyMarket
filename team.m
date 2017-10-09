classdef team < handle
    properties(Constant, Access=private)
       plant_types = ["powderCoal", "naturalgasCCGT", "naturalgasOCGT", "nuclear", "wind"]; 
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
            
            %Validate PowerPlant type
            isValid = any(strcmp(type, obj.plant_types)==1);
            if isValid == false
                error('Illegal plant type');
            end
            
            %Check valid efficiency input
            if efficiency>100
                error('Plant efficiency cannot be > 100');
            end
            
            %Check for input type
            if ~isa(availability, 'logical')
                error('Plant Availability: please enter true or false');
            end
            
            %To initialize the 'plants' variable as type 'plant'
            if(isempty(obj.plants))
                obj.plants = plant;        
            end
            
            %Check if plant already exists
            index = 0;
            for i = 1:length(obj.plants)
                if isstring(obj.plants(i).plant_name) &&  obj.plants(i).plant_name==name
                    index = i;
                    break;
                end
            end
            
            % Contents in this if are updated only the first time
            if(index == 0) 
                obj.num_plants = obj.num_plants + 1;
                index = obj.num_plants;
                obj.total_capacity = obj.total_capacity + capacity;
                obj.plants(index).efficiency = efficiency/100;
                obj.plants(index).plant_name = name;
                obj.plants(index).plant_type = type;
                obj.plants(index).capacity = capacity;
            end

            % Contents here are updated everytime
            obj.plants(index).loan = loan*10e6;
            obj.plants(index).onm = onm*10e6;  
            obj.plants(index).availability = availability;  
            
            fprintf('\tPowerplant \"%s\" added to team or updated\n',obj.plants(obj.num_plants).plant_name);
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
            
            % Add two more feilds: co2 emissions and units of fuel consumed
            flag = true;
            if ~exist('toprint','var')
                flag = true;
            else
                flag = toprint;
            end
            if flag == true
                fprintf("Plant Name\tPlant Type\tCapacity\tFuel Units\tCO2 Units\tMargCost/MWh\n");
            end
            obj.total_fixed_costs = 0;
            for i = 1:length(obj.plants)
                obj.total_fixed_costs = obj.total_fixed_costs + obj.plants(i).onm + obj.plants(i).loan;
                if obj.plants(i).availability == 0
                    if flag == true
                        fprintf('%10s\t%10s\t%8s\t%10s\t%10s\t%12s\t\n',obj.plants(i).plant_name,obj.plants(i).plant_type,"NA","NA");
                    end
                    continue;
                end
                switch (obj.plants(i).plant_type)
                    case "powderCoal"
                        obj.plants(i).fuel_units = (fuel.coal_cal_value/obj.plants(i).efficiency); % Fuel units consumed per kWh
                        obj.plants(i).co2_units = obj.plants(i).fuel_units * fuel.coal_co2_value; 
                        obj.plants(i).marginal_cost = (fuel.coal_price/fuel.coal_cal_value)/obj.plants(i).efficiency;
                        obj.plants(i).av_capacity = obj.plants(i).capacity;
                    case {"naturalgasCCGT", "naturalgasOCGT"}
                        obj.plants(i).marginal_cost = (fuel.gas_price/fuel.gas_cal_value)/obj.plants(i).efficiency;
                        obj.plants(i).av_capacity = obj.plants(i).capacity;
                    case "nuclear"
                        obj.plants(i).marginal_cost = (fuel.uranium_price/fuel.uranium_cal_value)/obj.plants(i).efficiency;
                        obj.plants(i).av_capacity = obj.plants(i).capacity;
                    case "wind"
                        obj.plants(i).marginal_cost = 0;
                        obj.plants(i).av_capacity = obj.plants(i).capacity*fuel.wind_availability;
                end
                if flag == true
                    fprintf('%10s\t%10s\t%8d\t%12.3d\t\n',obj.plants(i).plant_name, obj.plants(i).plant_type, obj.plants(i).av_capacity, obj.plants(i).marginal_cost);
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
                       case "efficiency"
                           obj.plants(i).efficiency = value/100;
                           return;
                       otherwise
                           error('Illegal Input');
                   end
               end
           end
           error('Plant not found!');    
        end
        
        function reset_team(obj)
            obj.plants = [];
            obj.num_plants = [];
            obj.total_capacity = [];
            obj.total_fixed_costs = [];
        end
    end
end