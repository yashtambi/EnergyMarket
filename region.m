classdef region < handle
   properties
       teams;
       num_teams = 0;
       demand_offpeak;
       demand_shoulder;
       demand_peak;
       total_supply;
   end
   
   properties(GetAccess = private)
       demand_offpeak_prv;
       demand_shoulder_prv;
       demand_peak_prv;
   end
   
   properties (Access = private, Constant)
       demand_elasticity = -10;
   end
   
   methods

       function create_database(obj, filename, pm)
           % Function to create database from CSV file
           %
           % create_database(obj, filename, prediction_model)
           % filename: name of CSV file (should be in the same directory)
           %           which contains the region portfolio (check sample excel sheet)
           % prediction_model: the prediction model to be used
           
           csv = importfile(filename);
           for i = 1:height(csv)
               team_name = evalin('caller',string(csv.Team(i)));
               plant_name = string(csv.PlantName(i));
               plant_type = string(csv.PlantType(i));
               plant_capacity = double(csv.Capacity(i));
               year_active = double(csv.YearActive(i));
                   
               % Get plant efficiency, loan amount and onm from the prediction model 
               [eff,loan,onm] = pm.var_predict(plant_type, year_active);
               
               % If efficiency data is already present in database
               if ~isnan(double(csv.Efficiency(i)))
                   eff = double(csv.Efficiency(i));
               end
               
               % Add the plant to the respective team
               team_name.add_plant(plant_name, plant_type, plant_capacity, eff, loan, onm, true, year_active);
           end
           all_teams = unique(csv.Team);
           
           for i = 1:length(all_teams)
               obj.add_team(evalin('base',string(all_teams(i))),string(all_teams(i)));
           end
           
       end
       
       function add_team (obj, new_team, team_name)
           % Add a new team to the region
           % This function automatically checks for duplicacy and will
           % ignore if team already present.
           % 
           % add_team (obj, new_team, team_name)
           % new_team : handle to the team to be added
           % tame_name: name of the team (in double quotes) 
          
           if(isempty(obj.teams))
               obj.teams = team;
           else
               for i = 1:length(obj.teams)
                   if any(strcmp(obj.teams(i).name,team_name)==1)
                       fprintf('Team %s already exists in region\n',team_name);
                       return;
                   end
               end
           end
           
           obj.num_teams = obj.num_teams + 1;
           obj.teams(obj.num_teams) = new_team;
           obj.teams(obj.num_teams).set_name(team_name);
           obj.total_supply = obj.total_supply + new_team.total_capacity;
           
           fprintf('Team %s added to region\n', team_name);
       end

       function remove_team(obj, team_name)
           % Function to remove team from the region
           % remove_team(obj, team_name)
           % team_name: name of the team to be removed (in double quotes)
           for i = 1:length(obj.teams)
               if(strcmp(obj.teams(i).name,team_name) == true)
                   obj.total_supply = obj.total_supply - obj.total_capacity;
                   obj.teams(i) = obj.teams(length(obj.teams));
                   obj.teams(length(obj.teams))=[];
                   obj.num_teams = obj.num_teams-1;
               end
           end
       end
       
       function bids = bid_plot(obj, fuels)
           % This function plots the possible bids of all the plants in the
           % region, in their merit order. This function considers only one scenario per plant:
           % the teams submit 1 bid per plant, which is equal to their
           % marginal cost. 
           %
           % bids = bid_plot(obj, fuels)
           % fuels: fuel structure 
           % bids: returns the 2*n bid vs price matrix
           
           bids = 0;
           k = 1;
           for i = 1:length(obj.teams)
               obj.teams(i).get_costs(fuels,false);
               for j = 1:length(obj.teams(i).plants)
                   bids(k,1) = (obj.teams(i).plants(j).marginal_cost * obj.teams(i).plants(j).availability);
                   bids(k,2) = (obj.teams(i).plants(j).av_capacity * obj.teams(i).plants(j).availability);
                   k = k+1;
               end
           end
           bids = sortrows(bids);       % this will sort the bids in acsending order
           
           for i = 2:length(bids)
               bids(i,2) = bids(i,2)+bids(i-1,2);
           end
           
           % Plot all the bids (considering marginal costs)
           stairs(bids(:,2),bids(:,1),'-b*');
           xlabel('Capacity (MW)');
           ylabel('Price (Eu/MW)');
           grid MINOR;
           legend;
           hold on;
           
       end

       function predict_demand (obj, fuels, prev_demand, growth)
           % This function plots the demand curve with the bid curve
           %  
           % predict_demand (obj,fuels,prev_demand, growth)
           % fuels: fuel structure
           % prev_demand: x-intercept of demand in the previous round (in MW)
           % growth: expected growth rate (in %) 
           
           new_demand = prev_demand*((100+growth)/100);
           x = linspace(new_demand*0.90,new_demand);
           y = (x - new_demand)/obj.demand_elasticity;
           obj.bid_plot(fuels);
           plot(x,y,'-.r');
           legend 'Supply Function' 'Demand Function';
           hold on;
       end
       
   end
end