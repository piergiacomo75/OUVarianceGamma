classdef OUVGIncrementApprox2 < IncrementMethod 
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            theta = dynamics.theta; 
            nu = dynamics.nu; 
            sigma = dynamics.sigma;
            % kappa  = dynamics.kappa; not required
            
            alpha = 1/nu;
            commonTerm = 0.5 * sqrt(theta^2 + 2 * sigma^2 / nu);
            mu_p = commonTerm + 0.5 * theta;
            mu_n = commonTerm - 0.5 * theta;
            nu_p = mu_p^2 * nu;
            nu_n = mu_n^2 * nu;
            beta_p = mu_p / nu_p;
            beta_n = mu_n / nu_n;
            
            gammaIncrement = GammaIncrement();
            gamma_p = Gamma(alpha, beta_p);
            gamma_n = Gamma(alpha, beta_n);
            
            % Approx2. Cufaro VG only
            increment_p = gammaIncrement.GenerateIncrement(gamma_p, timeStep, numberOfSimulations);
            increment_n = gammaIncrement.GenerateIncrement(gamma_n, timeStep, numberOfSimulations);
                       
            increment = increment_p - increment_n;
            
        end
    end
end

