classdef OUGamma < OU
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        alpha
        beta
        kappa
        x_0
    end
    
    methods
        function obj = OUGamma (alpha, beta, kappa, x_0)

            if nargin < 4
                x_0 = 0;
            end
            obj.alpha = alpha;
            obj.beta = beta;
            obj.kappa = kappa;
            obj.x_0 = x_0;
            
        end
        
        function cumulant = CalculateCumulant(obj, u, timeSteps)
            a = exp(-obj.kappa * timeSteps);
            
            cumulant = obj.x_0 * a * u + obj.alpha * (dilog(u/obj.beta) - dilog(u * a / obj.beta)) / obj.kappa;
            
        end
        
    end
end

