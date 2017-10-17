clear;
clc;

% load matlab.mat

% Initialize price prediction model
pm1 = price_predict;

% Initialize and update fuel prices
r8 = fuel;
r8.fuel_update(68.6, 0.21, 1060.12, 37, 12, 18);

% Initialize teams
ERLYJ = team;
AcDcTraders = team;
QuasarEnergy = team;
GreenHorizon = team;
dutchprom = team;

% Initialize region
east = region;
east.create_database('east_plants.csv',pm1);