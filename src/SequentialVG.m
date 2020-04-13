
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% alpha: gamma shape parameter
% beta: gamma rate parameter
% theta: BM drift
% sigma: BM diffusion
% timeToMaturity
% numberOfTimeSteps 
% numberOfSimulations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   OUTPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sequentialVarianceGamma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   EXAMPLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sequentialVarianceGamma = SequentialVG(2.5, 0.5, 0, 0,15, 1, 10, 5);
% trajectory = sequentialVarianceGamma(1,:);
% figure(1)
% plot(trajectory)

%%
function sequentialVarianceGamma = SequentialVG(alpha, beta, theta, sigma, timeToMaturity, numberOfTimeSteps, numberOfSimulations)


sequentialVarianceGamma = zeros(numberOfSimulations, numberOfTimeSteps);
deltaT = timeToMaturity / numberOfTimeSteps;

%% MATLAB uses the scale parameter notation
gammaRV =  gamrnd(alpha * deltaT, 1/beta, [numberOfSimulations, 1]);
gaussianRV = randn(numberOfSimulations, 1);

sequentialVarianceGamma(:, 1) =  theta * gammaRV(:,1) + sigma * sqrt(gammaRV(:,1)) .* gaussianRV(:, 1);    
for t = 2:numberOfTimeSteps
    gammaRV =  gamrnd(alpha * deltaT, 1/beta, [numberOfSimulations, 1]);
    gaussianRV = randn(numberOfSimulations, 1);

    increment = theta * gammaRV(:, 1) + sigma * sqrt(gammaRV(:, 1)) .* gaussianRV(:, 1); 
    sequentialVarianceGamma(:, t) =  sequentialVarianceGamma(:, t-1) + increment;
end














