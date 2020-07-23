classdef OUVGIncrementApprox1 < OUVGIncrementApprox2
    
    methods
        function increment = GenerateIncrement(obj, dynamics, timeStep, numberOfSimulations)

            kappa  = dynamics.kappa;
            
            % Benth. Approx1 is a=exp(-kappa * timeStep) VG
            a = exp(-kappa * timeStep);
            increment = a * GenerateIncrement@OUVGIncrementApprox2(obj, dynamics, timeStep, numberOfSimulations);
            
        end
    end
end

