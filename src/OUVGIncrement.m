classdef OUVGIncrement < OUGammaIncrement 
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            theta = dynamics.theta; 
            nu = dynamics.nu; 
            sigma = dynamics.sigma;
            kappa  = dynamics.kappa;
            
            alpha = 1/nu;
            commonTerm = 0.5 * sqrt(theta^2 + 2 * sigma^2 / nu);
            mu_p = commonTerm + 0.5 * theta;
            mu_n = commonTerm - 0.5 * theta;
            nu_p = mu_p^2 * nu;
            nu_n = mu_n^2 * nu;
            beta_p = mu_p / nu_p;
            beta_n = mu_n / nu_n;
            
            ouGamma_p = OUGamma(alpha, beta_p, kappa);
            ouGamma_n = OUGamma(alpha, beta_n, kappa);
            
            increment_p = GenerateIncrement@OUGammaIncrement(obj, ouGamma_p, timeStep, numberOfSimulations);
            increment_n = GenerateIncrement@OUGammaIncrement(obj, ouGamma_n, timeStep, numberOfSimulations);
            increment = increment_p - increment_n;
            
        end
    end
end

