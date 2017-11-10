# EnergyMarket
This repo contains script to aid in playing the SET3055 Energy Market Simulation game at TU Delft. This script has been designed for Matlab; certain functions may not work on Octave. 

Game link: (http://emg.tudelft.nl)

# About
## About the Game
The Electricity Market Game (EMG) simulates an energy market. As the website says, "In the game, several players work together in a power company. Five such companies compete with each other to make the most money by generating and selling electricity. Each round (which represents a year), the companies produce electricity, sell it to a power exchange and decide whether to build new power plants and/or to dismantle old ones. The players need to contend with uncertainties regarding the growth rate of demand, fuel prices, the availability of wind and energy policy changes. Given these real-life circumstances, they experience the difficulties of timing investment decisions and choosing between different types of generation technology in a dynamic environment." 

## About the Script
To aid in calculations and decision making, this script tries to predict the results of next round based on known data. Once the database has been created, curve fitting techniques are used to predict the power plants' efficiency, operation-and-maintenance (onm) costs, and loan amount (reliability can also be predicted, but hasn't been incorporated). Using these predictions, a profile of all power plants in the region is created and the plants are assigned to the respective teams. Functions are available to calculate variable costs of all the plants of a team, and also to plot a merit-order sorted supply function of the region (considering only marginal costs) vs. anticipated demand. 

# Setting up
### Create Region Database
- Populate a CSV file in the format as given as a sample in the file 'east_plants.csv'. 
- Plants whose efficiency is known can be entered, the remaining can be left blank. If blank, the script will *predict* the plant efficiency. 

### Setting up the *Region* in Matlab
Before forecasts can be made, the *region* needs to be setup. The examples presented below can be found in the file 'demo.m'. This involves the following steps:
1. Create a region handle "east": `east = region;`
2. Create all team handles present in the region: `ERLYJ = team;` `AcDcTraders = team;`, where ERLYJ and AcDcTraders are teams. __Note__ that the names should be exactly same as those in the CSV file, else database creation will fail. 
3. Create the prediction model: `pm1 = price_predict;` *price_predict* is a misnomer though since it also predicts efficiency. 
4. Create fuel variable: `r8 = fuel`. This is the variable which stores all fuel prices. 
5. Add the fuel prices: `r8.fuel_update(85.73, 0.27, 1047.18, 21, 0, 21);` Please refer to the function for more details. 
6. Create the database in Matlab and update plants with their predicted loan, onm, and efficiency: `east.create_database('east_plants.csv',pm1);`

# Viewing Costs and Supply Function
### Individual Team's Costs
Marginal costs for each team can be viewed using `team.get_costs(r8);`, for team *ERLYJ*: `ERLYJ.get_costs(r8)` will print the fuel, carbon, and total marginal costs. It will print 'NA' if the plant is unavailable for the round. 

### Entire Region
The script is capable of generating a supply function of an entire region with the following **assumptions**:
1. Every team submits only one bid per plant
2. Bid for each plant is at its marginal cost. This is a fair assumption since in a competitive market, this is the best bidding strategy. 
3. All plants in the region are available for production. This is the default, but if user knows about unavailability of certain plants, they can be made unavailable. 

#### Supply function vs Demand curve
`east.predict_demand(r8, 15242, 0.2);` will generate the supply function (merit-order sorted) vs demand function. **Note** that the numbers are only indicative, refer to function description for more details (can be found in the *region.m* file). 
##### Uses:
1. Can be used to simulate future demand scenarios. This is useful for making investment decisions. 
2. Can be used to decide bidding strategy for the round. 

# Future work:
1. Complete financial models of teams can be made to predict future financial conditions. 
2. Reliability predictions; multiple scenarios based on these predictions; better forecasts. 
3. Graphs can be improved to show more data: details about plants etc. 
