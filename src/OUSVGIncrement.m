classdef OUSVGIncrement  < IncrementMethod 
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            nu = dynamics.nu;
            sigma = dynamics.sigma;
            kappa = dynamics.kappa;
            
            alpha = timeStep / nu;
            beta = sqrt(2/nu) / sigma;
            compoundPoisson = zeros(numberOfSimulations, 1);
            % Generate a N(t)
            poissonRV = poissrnd(kappa * timeStep^2 / nu,  [numberOfSimulations, 1]);
            gammaUp = gamrnd(alpha, exp(-kappa * timeStep)/beta, [numberOfSimulations, 1]);      
            gammaDown = gamrnd(alpha, exp(-kappa * timeStep)/beta, [numberOfSimulations, 1]);      
            for n = 1:numberOfSimulations
                % Given N(t)=n generate n uniforms for the random scale
                uniformRV = rand(poissonRV(n, 1), 1); 
                randomScale =  exp(-kappa * timeStep * sqrt(uniformRV)) / beta;               
                % Generate the laplace jump sizes and sum
                jumps = laplacernd(randomScale, [poissonRV(n, 1), 1]);
                
                compoundPoisson(n, 1) = sum(jumps);
            end
            increment = gammaUp - gammaDown + compoundPoisson;
        end
    end
end

