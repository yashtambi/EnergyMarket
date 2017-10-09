ton_CO2perFuelUnit=0.00187
MJperFuelUnit=35.069

tonCO2perMJ= (ton_CO2perFuelUnit*3600)/(MJperFuelUnit);%tonco2 / MJ

capacity_coal_1=800; %MW
capacity_coal_2= 600;
capacity_coal_3=600;
capacity_gas_1=500;
capacity_gas_2=50;
capacity_gas_3=50;

coal_1=capacity_coal_1*525600*0.4281; %MJ
coal_2=capacity_coal_2*525600*0.4114;
coal_3=capacity_coal_3*525600*0.4614;
gas_1=capacity_gas_1*525600*0.5079;
gas_2=capacity_gas_2*525600*0.3548;
gas_3=capacity_gas_3*525600*0.3485;

tonCo2_coal_1=tonCO2perMJ*coal_1
tonCo2_coal_2=tonCO2perMJ*coal_2
tonCo2_coal_3=tonCO2perMJ*coal_3
tonCo2_gas_1=tonCO2perMJ*gas_1
tonCo2_gas_2=tonCO2perMJ*gas_2
tonCo2_gas_3=tonCO2perMJ*gas_3

total=tonCo2_coal_1+tonCo2_coal_2+tonCo2_coal_3+tonCo2_gas_1+tonCo2_gas_2+tonCo2_gas_3
if total<50*10^6
    fprintf ('suuuuuuuuper\n')
else
    fprintf ('oh no\n')
end

exceed=total-50*10^6