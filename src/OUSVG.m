classdef OUSVG < OU
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        nu
        sigma
        kappa
        x_0
    end
    
    methods
        function obj = OUSVG(nu, sigma, kappa, x_0)

            if nargin < 4
                x_0 = 0;
            end
            obj.nu = nu;
            obj.sigma = sigma;
            obj.kappa = kappa;
            obj.x_0 = x_0;
            
        end
        
        function cumulant = CalculateCumulant(obj, u, timeSteps)
            
            ell_1 = obj.sigma ^2 * obj.nu / 2;
            ell_0 = ell_1 * exp(- 2 * obj.kappa * timeSteps);
            cumulant = (dilog(u * ell_1) - dilog(u * ell_0)) / (2 * obj.nu * obj.kappa);
            
        end
        
    end
end

