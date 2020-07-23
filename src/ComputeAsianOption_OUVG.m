%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M file to compute the gas storage value by backward and forward
% induction.
% I also allow the computation of the optimamal dispatched strategy and the
% monthly cash flows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           INPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%# Asian
%# market
%# valuation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           OUTPUTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%# assetPriceBack
%# errPriceBack


function [asianPrice, rmse, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation, incrementMethodString)

tic
strike = asianOption.strike;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Market Parameters 
currentPrice = market.currentPrice;

% OUVG
kappaOU = market.kappaOU;
thetaOU = market.thetaOU;
nuOU = market.nuOU;
sigmaOU = market.sigmaOU;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shapeData = market.shapeData;
% Valuation Parameters
numberOfSimulations = valuation.numberOfSimulations;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Auxiliary variables
timeSteps = valuation.timeSteps;
deltaTimeSteps = diff([0; timeSteps]);
numberOfDeltaTimeSteps = numel(deltaTimeSteps);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate Trajectory

ouVG = OUVG(thetaOU, nuOU, sigmaOU, kappaOU);

incrementMethod = ResolveIncrementMethod(incrementMethodString);    
ouVGTrajectory = 0;

cumulantCorrectionOUVG = ouVG.CalculateCumulant(1, timeSteps);

% priceTrajectories = zeros(numberOfSimulations, numberOfDeltaTimeSteps);
cumulativeSum = 0;
for t = 1:numberOfDeltaTimeSteps
    deltaT = deltaTimeSteps(t);
    a = exp(-kappaOU * deltaT);
    ouVGInnovation = incrementMethod.GenerateIncrement(ouVG, deltaT, numberOfSimulations);
    ouVGTrajectory = ouVGTrajectory * a + ouVGInnovation;
    % Price Trajectory , Introduce shape
    priceTrajectories = exp(- cumulantCorrectionOUVG(t)  + ouVGTrajectory) * currentPrice * shapeData(t);

    cumulativeSum = cumulativeSum + priceTrajectories;
end
averagePrice = cumulativeSum / numberOfDeltaTimeSteps;
asianPayoff = max(averagePrice - strike, 0);

asianPrice = mean(asianPayoff);
rmse = std(asianPayoff);
elapsedTime = toc;
end