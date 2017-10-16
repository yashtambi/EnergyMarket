clear;
clc;

% load matlab.mat

% Initialize price prediction model
pm1 = price_predict;

% Initialize and update fuel prices
r8 = fuel;
r8.fuel_update(74.91,0.29,1041.66,9,10,17);

% Initialize teams
ERLYJ = team;
AcDcTraders = team;
QuasarEnergy = team;
GreenHorizon = team;
dutchprom = team;

% Initialize region
east = region;
east.create_database('east_plants.csv',pm1);