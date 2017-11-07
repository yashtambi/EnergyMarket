classdef price_predict
    % This class stores the properties of the curve fit models used to
    % predict the loan amount, Operational and Maintenance (OnM) costs and
    % efficiency of the plant.
    % Reliability needs to be added to models.
    % The name of the class is sort of a misnomer since it calculates more.
    %
    % This class is not a handle
    
    properties
        
    end
    
    properties (Constant, GetAccess = private)
        loan_period = [20 20 15 15 10]; %coal nuclear ccgt wind ocgt
        const_time = [3 6 3 3 1];       %coal nuclear ccgt wind ocgt
        coal_eff = [8.243e-07 0.0005876 0.2214 44.33]; %p1 p2 p3 p4
        nuclear_eff = [-0.0007071 0.03707 30.02];
        ccgt_eff = [0.3847 55.41];
        ocgt_eff = [-0.002593 0.2611 37.14];
    end
    
    methods
        function [eff,loan,onm] = var_predict(obj, plant_type, year_active, current_year)
            % This function gives the plant efficiency, loan and Onm costs of the
            % plant with respect to the current year.
            % [efficiency, loan, onm] = var_predict(plant_type, year_active)
            % [efficiency, loan, onm] = var_predict(plant_type, year_active, current_year)
            %   if current year is not provided, it is taken as 12
            %   (default)
            % 
            % plant_type: should be either of (in ""): powderCoal, nuclear,
            % wind, naturalgasCCGT, naturalgasOCGT
            
            if (nargin<=3)
                current_year = 12;
            end
            
            x = year_active;
            switch plant_type
                case "powderCoal"
                    eff = obj.coal_eff(1)*x^3 + obj.coal_eff(2)*x^2 + obj.coal_eff(3)*x + obj.coal_eff(4);
                    if (current_year - year_active) > obj.loan_period(1)
                        loan = 0;
                    else
                        loan = 1;
                    end
                    onm = 1;
                case "wind"
                    eff = 100;
                    if (current_year - year_active) > obj.loan_period(4)
                        loan = 0;
                    else
                        loan = 1;
                    end
                    onm = 1;
                case "nuclear"
                    eff = obj.nuclear_eff(1)*x^2 + obj.nuclear_eff(2)*x + obj.nuclear_eff(3);
                    
                    if (current_year - year_active) > obj.loan_period(2)
                        loan = 0;
                    else
                        loan = 1;
                    end
                    onm = 1;
                case "naturalgasCCGT"
                    eff = obj.ccgt_eff(1)*x + obj.ccgt_eff(2);
                    if (current_year - year_active) > obj.loan_period(2)
                        loan = 0;
                    else
                        loan = 1;
                    end
                    onm = 1;
                case "naturalgasOCGT"
                    eff = obj.ocgt_eff(1)*x^2 + obj.ocgt_eff(2)*x + obj.ocgt_eff(3);
                    if (current_year - year_active) > obj.loan_period(5)
                        loan = 0;
                    else
                        loan = 1;
                    end
                    onm = 1;
                otherwise
                    error('Unknown plant type');
            end
        end
    end
end