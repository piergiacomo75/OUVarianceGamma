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
delta = 1/360;
maturity = 1.5;
forwardStart = 0.5;
valuation.timeSteps = (forwardStart:delta:maturity)';
numTimeSteps = numel(valuation.timeSteps);


%% Set Market Parameters
market.currentPrice = 15;
market.riskFree = 0;
market.dividend = 0;
%%%% OUVG %%%

market.thetaOU = 0.05;
market.kappaOU = 0.2162;
market.nuOU = 0.2560;
market.sigmaOU = 0.2021;

market.shapeData = ones(numTimeSteps,1);
market.bidAsk = 0;
market.fxRate = 1;

numberOfSimulations = [1000, 10000, 20000, 50000, 100000];

priceAlgorithmSabino = zeros(length(numberOfSimulations), 1);
errPriceAlgorithmSabino = zeros(length(numberOfSimulations), 1);
timesAlgorithmSabino = zeros(length(numberOfSimulations), 1);

incrementMethodString = 'ouvariancegammaincrement';

for s = 1:length(numberOfSimulations)
    valuation.numberOfSimulations = numberOfSimulations(s);
    
    [assetPrice, errPrice, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation, incrementMethodString);
    
    priceAlgorithmSabino(s) = assetPrice;
    errPriceAlgorithmSabino(s) = errPrice;
    timesAlgorithmSabino(s) = elapsedTime; 
    
end

incrementMethodString = 'ouvariancegammaincrementapprox1';

priceAlgorithmApprox1 = zeros(length(numberOfSimulations), 1);
errPriceAlgorithmApprox1 = zeros(length(numberOfSimulations), 1);
timesAlgorithmApprox1 = zeros(length(numberOfSimulations), 1);

for s = 1:length(numberOfSimulations)
    valuation.numberOfSimulations = numberOfSimulations(s);
    
    [assetPrice, errPrice, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation, incrementMethodString);
    
    priceAlgorithmApprox1(s) = assetPrice;
    errPriceAlgorithmApprox1(s) = errPrice;
    timesAlgorithmApprox1(s) = elapsedTime; 
    
end

incrementMethodString = 'ouvariancegammaincrementapprox2';

priceAlgorithmApprox2 = zeros(length(numberOfSimulations), 1);
errPriceAlgorithmApprox2 = zeros(length(numberOfSimulations), 1);
timesAlgorithmApprox2 = zeros(length(numberOfSimulations), 1);

for s = 1:length(numberOfSimulations)
    valuation.numberOfSimulations = numberOfSimulations(s);
    
    [assetPrice, errPrice, elapsedTime] = ComputeAsianOption_OUVG(asianOption, market, valuation, incrementMethodString);
    
    priceAlgorithmApprox2(s) = assetPrice;
    errPriceAlgorithmApprox2(s) = errPrice;
    timesAlgorithmApprox2(s) = elapsedTime; 
    
end