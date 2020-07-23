classdef OUGammaIncrement < IncrementMethod
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            alpha = dynamics.alpha;
            beta = dynamics.beta;
            kappa = dynamics.kappa;
            
%             compoundPoisson = zeros(numberOfSimulations, 1);
            % Generate a N(t)
            poissonRV = poissrnd(0.5 * alpha * kappa * timeStep^2,  [numberOfSimulations, 1]);
            gammaRV = gamrnd(alpha * timeStep, exp(-kappa * timeStep)/beta, [numberOfSimulations, 1]);      
            maxPoissonRV = max(poissonRV);
            temp1 = repmat(1:maxPoissonRV, numberOfSimulations, 1);
            indicesLowerMaxPoissonRV = bsxfun(@gt, temp1, poissonRV);
            uniform = rand(numberOfSimulations, maxPoissonRV);        
            randomMean =  exp(-kappa * timeStep * sqrt(uniform)) / beta;
            exponentialRV = exprnd(randomMean);
            exponentialRV(indicesLowerMaxPoissonRV) = 0;
            compoundPoisson = sum(exponentialRV, 2);
%             for n = 1:numberOfSimulations
%                 % Given N(t)=n generate n uniforms for the random mean
%                 uniform = rand(poissonRV(n, 1), 1); 
%                 randomMean =  exp(-kappa * timeStep * sqrt(uniform)) / beta;
%                 % Generate the exponential jump sizes and sum
%                 compoundPoisson(n, 1) = sum(exprnd(randomMean, [poissonRV(n, 1), 1]));
%             end
%             for n = 1:numberOfSimulations
%                 % Given N(t)=n generate n uniforms for the random mean
%                 uniform = rand(poissonRV(n, 1), 1);
%                 randomMean =  exp(-kappa * timeStep * sqrt(uniform)) / beta;
%                 % Generate the exponential jump sizes and sum
%                 compoundPoisson(n, 1) = sum(exprnd(randomMean, [poissonRV(n, 1), 1]));
%             end
            increment = gammaRV + compoundPoisson;
        end
    end
end

