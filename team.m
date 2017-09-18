
 %{
        ERLYJ
        nuclear = [800, 3888000, 1221.16, 0.2958, 0.934, 177.3, 19, 33.2, 0];
        coal1 = [800, 3888000, 1221.16, 0.2958, 100, 0, 0, 0, 0];
        coal2 = [800, 3888000, 1221.16, 0.2958, 100, 0, 0, 0, 0];
        naturalgas1 = [800,3888000,1221.16,0.2958,100,0,0,0,0];
        naturalgas2 = [800,3888000,1221.16,0.2958,100,0,0,0,0];
        naturalgas3 = [800,3888000,1221.16,0.2958,100,0,0,0,0];
%}

classdef team < handle
    properties
        pplants
        total_plants= 1
    end
    
    methods
        
        function add_plant(obj,new_plant)
%            name = new_plant.get_plant_stats;
            
%           for i= 1:length(obj.plants)
%                if(strcmp(obj.plants(i).name,new_plant.name) == 1)
%                    fprintf('\n\tPlant already present in the database!\n');
%                    return
%                end
%            end
            len = length(obj.pplants) + 1
            obj.pplants(len) = new_plant;
%            obj.total_plants = obj.total_plants + 1;
            
            fprintf('\n\tPlant \"%s\" added to team successfully!\n',new_plant.plant_name);
        end
    end
end