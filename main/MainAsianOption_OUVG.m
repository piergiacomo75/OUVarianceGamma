%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              MAIN STORAGE TRY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
close all
clc
addpath(genpath('../src'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read Asset Characteristics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliary variables
gas = 'TTF';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set Asset parameters
asianOption.strike = 15;
asianOption.maturity = 1;
%% Compute Asian Value
%% Valuation Parameters
valuation.nMonths = 12;
valuation.nStepsPerMonth = 30;
valuation.dYear = 1;
numTimeSteps = valuation.nMonths * valuation.nStepsPerMonth * asianOption.maturity;


%% Set Market Parameters
market.currentPrice = 15;
market.riskFree = 0;
market.dividend = 0;
%%%% OUVG %%%
market.kappaOU = 0.1859; 0.2162;
market.thetaOU = 0.05;
market.nuOU = 0.4513; 0.256 / 2;
market.sigmaOU = 0.203;
%%%% VG %%%%
market.theta = 0.1;
market.nu = 0.02;
market.sigma = 0.3;

market.shapeData = ones(numTimeSteps,1);
market.bidAsk = 0;
market.fxRate = 1;

numberOfSimulations = [1000, 10000, 20000, 50000, 100000];

priceAlgorithm = zeros(length(numberOfSimulations), 1);
errPriceAlgorithm = zeros(length(numberOfSimulations), 1);
timesAlgorithm = zeros(length(numberOfSimulations), 1);

for s = 1:length(numberOfSimulations)
    valuation.numberOfSimulations = numberOfSimulations(s);
    
    [assetPrice, errPrice, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation);
    
    priceAlgorithm(s) = assetPrice;
    errPriceAlgorithm(s) = errPrice;
    timesAlgorithm(s) = elapsedTime; 
    
end

