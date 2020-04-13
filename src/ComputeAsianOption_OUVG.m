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


function [asianPrice, rmse, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation)

tic
strike = asianOption.strike;
maturity = asianOption.maturity;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Market Parameters 
currentPrice = market.currentPrice;
% VG
theta = market.theta;
nu = market.nu;
sigma = market.sigma;

% OUVG
kappaOU = market.kappaOU;
thetaOU = market.thetaOU;
nuOU = market.nuOU;
sigmaOU = market.sigmaOU;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shapeData = market.shapeData;
% Valuation Parameters
nMonths = valuation.nMonths;
nStepsPerMonth = valuation.nStepsPerMonth;
numberOfSimulations = valuation.numberOfSimulations;
dYear = valuation.dYear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Auxiliary variables
nDaysPerYear = nStepsPerMonth * nMonths;
deltaT = dYear / nDaysPerYear;
timeSteps = (deltaT:deltaT:maturity)';
numberOfTimeSteps = fix(nMonths * nStepsPerMonth * maturity);
a = exp(-kappaOU * deltaT);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generate Trajectory

ouVG = OUVG(thetaOU, nuOU, sigmaOU, kappaOU);
ouVGIncrement = OUVGIncrement(); 
ouVGTrajectory = 0;
vgTrajectory = SequentialVG(1/nu, 1/nu, theta, sigma, maturity, numberOfTimeSteps, numberOfSimulations);

cumulantCorrectionOUVG = ouVG.CalculateCumulant(1, timeSteps);
cumulantCorrectionVG = - timeSteps * log(1 - 1/2 * sigma^2 * nu - theta * nu) / nu;

% priceTrajectories = zeros(numberOfSimulations, numberOfTimeSteps);
cumulativeSum = 0;
for t = 1:numberOfTimeSteps
    ouVGInnovation = ouVGIncrement.GenerateIncrement(ouVG, deltaT, numberOfSimulations);
    ouVGTrajectory = ouVGTrajectory * a + ouVGInnovation;
    % Price Trajectory , Introduce shape
    priceTrajectories = exp(- cumulantCorrectionOUVG(t) - cumulantCorrectionVG(t) + ouVGTrajectory + vgTrajectory(:, t)) * currentPrice * shapeData(t);
    cumulativeSum = cumulativeSum + priceTrajectories;
end
averagePrice = cumulativeSum / numberOfTimeSteps;
asianPayoff = max(averagePrice - strike, 0);

asianPrice = mean(asianPayoff);
rmse = std(asianPayoff);
elapsedTime = toc;
end