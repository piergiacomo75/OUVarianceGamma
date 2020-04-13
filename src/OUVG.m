classdef OUVG < OU
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        theta
        nu
        sigma
        kappa
        x_0
    end
    
    methods
        function obj = OUVG(theta, nu, sigma, kappa, x_0)

            if nargin < 5
                x_0 = 0;
            end
            obj.theta = theta;
            obj.nu = nu;
            obj.sigma = sigma;
            obj.kappa = kappa;
            obj.x_0 = x_0;
            
        end
        
        function cumulant = CalculateCumulant(obj, u, timeSteps)

            commonTerm = 0.5 * sqrt(obj.theta^2 + 2 * obj.sigma^2 / obj.nu);
            mu_p = commonTerm + 0.5 * obj.theta;
            mu_n = commonTerm - 0.5 * obj.theta;
            nu_p = mu_p^2 * obj.nu;
            nu_n = mu_n^2 * obj.nu;
            a = exp(-obj.kappa * timeSteps);
            cumulant = (dilog(u * nu_p/mu_p) - dilog(u * a * nu_p/mu_p) + dilog(-u * nu_n/mu_n) - dilog(-u * a * nu_n/mu_n)) / (obj.nu * obj.kappa);
        end
        
    end
end

