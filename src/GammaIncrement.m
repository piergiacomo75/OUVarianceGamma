classdef GammaIncrement < IncrementMethod
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)
            
            alpha = dynamics.alpha;
            beta = dynamics.beta;
            
            increment = gamrnd(alpha * timeStep, 1/beta, [numberOfSimulations, 1]);
        end
    end
end

