% This script is a demonstrative script
% 
% It first clears the workspace
% Then, price model is initialized and current fuel prices are fed to it
% Next, it creates the actual teams in the relevant region
%   Note: this step is necessary as the script evaluates the variables
%   present in the workspace against the team names in the excel file
% It then creates a region and adds all the teams to the region


clear;
clc;

% load matlab.mat

% Initialize price prediction model
pm1 = price_predict;

% Initialize and update fuel prices
r8 = fuel;
r8.fuel_update(85.73, 0.27, 1047.18, 21, 0, 21);

% Initialize teams
ERLYJ = team;
AcDcTraders = team;
QuasarEnergy = team;
GreenHorizon = team;
dutchprom = team;

% Initialize region
east = region;
east.create_database('east_plants.csv',pm1);