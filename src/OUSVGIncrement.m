classdef OUSVGIncrement  < IncrementMethod 
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            nu = dynamics.nu;
            sigma = dynamics.sigma;
            kappa = dynamics.kappa;
            
            alpha = timeStep / nu;
            beta = sqrt(2/nu) / sigma;

            % Generate a N(t)
            poissonRV = poissrnd(kappa * timeStep^2 / nu,  [numberOfSimulations, 1]);
            gammaUp = gamrnd(alpha, exp(-kappa * timeStep)/beta, [numberOfSimulations, 1]);      
            gammaDown = gamrnd(alpha, exp(-kappa * timeStep)/beta, [numberOfSimulations, 1]);   
            maxPoissonRV = max(poissonRV);
            temp1 = repmat(1:maxPoissonRV, numberOfSimulations, 1);
            indicesLowerMaxPoissonRV = bsxfun(@gt, temp1, poissonRV);
            
            % Given N(t)=n generate n uniforms for the random scale
            uniformRV = rand(numberOfSimulations, maxPoissonRV);        
            randomScale =  exp(-kappa * timeStep * sqrt(uniformRV)) / beta;  
            jumps = laplacernd(randomScale);
            jumps(indicesLowerMaxPoissonRV) = 0;
            compoundPoisson = sum(jumps, 2);          

            increment = gammaUp - gammaDown + compoundPoisson;
        end
    end
end

