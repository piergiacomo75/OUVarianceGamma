classdef OU
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
       
    properties (Abstract, SetAccess = private, GetAccess = public)
        x_0
        kappa
    end
    
    methods 
        
        function trajectory = SimulateTrajectory(obj, timeGrid, numberOfSimulations, simulationMethodStr)
                        
            deltaGrid = diff(timeGrid);
            numberOfTimeSteps = numel(deltaGrid);
            
            simulationMethod = ResolveIncrementMethod(simulationMethodStr);
            trajectory = zeros(numberOfTimeSteps, numberOfSimulations);
            trajectory(1, :) = obj.x_0;
            for t = 1:numberOfTimeSteps
                increment = simulationMethod.GenerateIncrement(obj, deltaGrid(t), numberOfSimulations);                
                trajectory(t+1, :) = trajectory(t, :) * exp(-obj.kappa * deltaGrid(t)) + increment'; 
            end
            
        end
    end
end

