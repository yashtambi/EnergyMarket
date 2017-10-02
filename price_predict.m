classdef price_predict
    properties
        
    end
    
    properties (Constant, GetAccess = private)
        loan_period = [20 20 15 15 10]; % coal nuclear ccgt wind ocgt
    end
    
    methods
        function amount = loan_predict(obj, plant_type, year_active)
            amount = 1;
        end
        
        function amount = onm_predict(obj, plant_type, year_active)
            amount = 1;
        end
        
        function eff = efficiency_predict(obj,plant_type,year_active)
            eff = 50; % in percent
        end
        
        function [eff,loan,onm] = var_predict(obj,plant_type,year_active)
            eff = 40;
            loan = 1;
            onm = 1;
        end
    end
end