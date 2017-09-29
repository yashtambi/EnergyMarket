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

       function import(obj,var)
           
       end
       
       function add_team (obj, new_team, team_name)
           if(isempty(obj.teams))
               obj.teams = team;
           else
               for i = 1:length(obj.teams)
                   if strcmp(obj.teams(i).name,team_name)==1
                       error('Team already exists in region')
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
           obj.teams.get_costs(fuels,false);
           bids = 0;
           for i = 1:length(obj.teams)
               for j = 1:length(obj.teams(i).plants)
                   bids(i+j-1,1) = obj.teams(i).plants(j).marginal_cost;
                   bids(i+j-1,2) = obj.teams(i).plants(j).capacity;
               end
           end
           bids = sortrows(bids);       % this will sort the bids in acsending order
           
           for i = 2:length(bids)
               bids(i,2) = bids(i,2)+bids(i-1,2);
           end
           
           % Plot all the bids (considering marginal costs)
           plot(bids(:,2),bids(:,1),'-b*');
           xlabel('Capacity (MW)');
           ylabel('Price (Eu/MW)');
           grid MINOR;
           legend;
           hold on;
           
       end

       function predict_demand (obj,fuels,prev_demand, growth)
%           sym y;
           new_demand = prev_demand*((100+growth)/100);
           x = linspace(new_demand*0.7,new_demand);
           y = (x - new_demand)/obj.demand_elasticity;
           obj.bid_plot(fuels);
           plot(x,y,'-.r');
           legend 'Supply Function' 'Demand Function';
           hold on;
       end
       
   end
end