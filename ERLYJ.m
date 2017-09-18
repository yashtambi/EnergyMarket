%{
    SET3055 
    
    function a = erlyj(x,y,z)
    end
%}

clear;
clc;

capacity = 1;               % MW
energy_value = 2;           % MWh/unit fuel
fuel_price = 3;             % Euro/unit fuel 
efficiency = 4;             % in %
reliability = 5;            % in %
loan_payment = 6;           % 10^6 Euro/year
remaining_payments = 7;     % Years
onm_costs = 8;              % Fixed Operation and Management costs, 10^6 Euro/year
co2 = 9;                    % ton CO2/unit fuel

% Conversion Factors
mw_to_mwh = 3600;   % for 1 hour
mwh_to_mj = 3600;   % 
mj_to_mwh = 1/mwh_to_mj;   % 

% Hours
hours_offpeak = 5000;
hours_peak = 160;
hours_shoulder = 3600;

hours_total = hours_offpeak + hours_peak + hours_shoulder;

nuclear = [800, 3888000, 1221.16, 0.2958, 0.934, 177.3, 19, 33.2, 0];
coal1 = [800, 3888000, 1221.16, 0.2958, 100, 0, 0, 0, 0];
coal2 = [800, 3888000, 1221.16, 0.2958, 100, 0, 0, 0, 0];
naturalgas1 = [800,3888000,1221.16,0.2958,100,0,0,0,0];
naturalgas2 = [800,3888000,1221.16,0.2958,100,0,0,0,0];
naturalgas3 = [800,3888000,1221.16,0.2958,100,0,0,0,0];

nuclear_capacity = 800; % MW
nuclear_energy_value = 3888000 * mj_to_mwh; % MWh/kg
nuclear_fuel_price = 1221.16; % eu/kg
nuclear_efficiency = 0.2958; % in %

naturalgas1_capacity = 500; % MW
naturalgas2_capacity = 50; % MW
naturalgas3_capacity = 50; % MW
naturalgas_energy_value = 35.069 * mj_to_mwh; % MWh/m3
naturalgas_fuel_price = 0.11; % eu/m3
naturalgas1_efficiency = 0.5079;
naturalgas2_efficiency = 0.3485;
naturalgas3_efficiency = 0.3548;

coal1_capacity = 600; % MW
coal2_capacity = 600; % MW
coal_energy_value = 25000.0 * mj_to_mwh; % MWh/m3
coal_fuel_price = 30.06; % eu/ton
coal1_efficiency = 0.4281;
coal2_efficiency = 0.4114;

wind_capacity = 100; % MW
wind_energy_value = 0; % ?
wind_availability = 36; % %eu/kg

total_capacity = nuclear_capacity + coal1_capacity + coal2_capacity + naturalgas1_capacity + naturalgas2_capacity + naturalgas3_capacity;

demand_increase = 0.028; % in %

nuclear_price_eu_per_mj = (nuclear_fuel_price/nuclear_energy_value)/nuclear_efficiency;
coal1_price_eu_per_mj = (coal_fuel_price/coal_energy_value)/coal1_efficiency;
coal2_price_eu_per_mj = (coal_fuel_price/coal_energy_value)/coal2_efficiency;
naturalgas1_price_eu_per_mj = (naturalgas_fuel_price/naturalgas_energy_value)/naturalgas1_efficiency;
naturalgas2_price_eu_per_mj = (naturalgas_fuel_price/naturalgas_energy_value)/naturalgas2_efficiency;
naturalgas3_price_eu_per_mj = (naturalgas_fuel_price/naturalgas_energy_value)/naturalgas3_efficiency;

nuclear_energy_available = nuclear_capacity * hours_total; % MWh
coal1_energy_available = coal1_capacity * hours_total; % MWh
coal2_energy_available = coal2_capacity * hours_total; % MWh
naturalgas1_energy_available = naturalgas1_capacity * hours_total; % MWh
naturalgas2_energy_available = naturalgas2_capacity * hours_total; % MWh
naturalgas3_energy_available = naturalgas3_capacity * hours_total; % MWh

nuclear_total_cost = nuclear_energy_available * mwh_to_mj * nuclear_price_eu_per_mj
coal1_total_cost = coal1_energy_available * mwh_to_mj * coal1_price_eu_per_mj
coal2_total_cost = coal1_energy_available * mwh_to_mj * coal2_price_eu_per_mj
naturalgas1_total_cost = naturalgas1_energy_available * mwh_to_mj * naturalgas1_price_eu_per_mj
naturalgas2_total_cost = naturalgas2_energy_available * mwh_to_mj * naturalgas2_price_eu_per_mj
naturalgas3_total_cost = naturalgas3_energy_available * mwh_to_mj * naturalgas3_price_eu_per_mj

total_fuel_cost = nuclear_total_cost + coal1_total_cost + coal2_total_cost + naturalgas1_total_cost + naturalgas2_total_cost + naturalgas3_total_cost;

bid = total_fuel_cost / total_capacity ;

