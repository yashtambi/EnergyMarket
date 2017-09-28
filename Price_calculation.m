clc
clear

Nuclear_price = 1025.04;
Coal_price = 62.56;
Gas_price = 0.2;
Wind_availability = 6;

%% Data
Peak_hours=160; %h
Shoulder_hours=3600; %h
Off_peak_hours=5000; %h
Total_hours=Peak_hours+Shoulder_hours+Off_peak_hours;

%% Nuclear
Capacity=800; % MW
Energy_value=3888000/3600; % MWh/kg
Fuel_price=Nuclear_price; % �/kg
Efficiency=0.2958;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(177.3+33.7)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_nuclear=(Total_costs/Capacity)/Total_hours

%% Wind
Capacity=100; % MW
Actual_Capacity = Capacity*Wind_availability/100;
Fixed_costs=(10.6)*1e6;
Price_wind=((Fixed_costs/Actual_Capacity)/Total_hours)

%% Coal 1
Capacity=600; % MW
Energy_value=25000/3600; % MWh/ton
Fuel_price=Coal_price; % �/ton
Efficiency=0.4281;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(48.8+8.6)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_coal1=(Total_costs/Capacity)/Total_hours

%% Coal 2
Capacity=600; % MW
Energy_value=25000/3600; % MWh/ton
Fuel_price=Coal_price; % �/ton
Efficiency=0.4114;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(9.2)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_coal2=(Total_costs/Capacity)/Total_hours

%% Gas 1
Capacity=500; % MW
Energy_value=35.069/3600; % MWh/m^3
Fuel_price=Gas_price; % �/m^3
Efficiency=0.5079;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(3.9)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_gas1=(Total_costs/Capacity)/Total_hours

%% Gas 2
Capacity=50; % MW
Energy_value=35.069/3600; % MWh/m^3
Fuel_price=Gas_price; % �/m^3
Efficiency=0.3485;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(0.4)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_gas2=(Total_costs/Capacity)/Total_hours

%% Gas 3
Capacity=50; % MW
Energy_value=35.069/3600; % MWh/m^3
Fuel_price=Gas_price; % �/m^3
Efficiency=0.3548;
Eu_per_MWh=(Fuel_price/Energy_value)/Efficiency
Fixed_costs=(0.4)*1e6;
Variable_costs=Eu_per_MWh*Capacity*Total_hours;
Total_costs=Fixed_costs+Variable_costs;
Price_gas3=(Total_costs/Capacity)/Total_hours
