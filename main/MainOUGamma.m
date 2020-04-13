% SCRIPT THAT REPRODUCES FIGURE 1 AND TABLE 2
clear
close all
clc

addpath(genpath('../src'))

alpha = 2;
beta = 2;
kappaOU = 0.5;
x_0 = 10;
timeStep = 1;
maturity = 1;
timeGrid = 0:timeStep:maturity;
a = exp(-kappaOU * timeGrid(2:end));

ouGamma = OUGamma(alpha, beta, kappaOU, x_0);
     
numberOfSimulations = 100000; [10000, 40000, 160000, 640000, 2560000]';
mean_= (1-a) * alpha / (beta * kappaOU) + x_0 * a;
variance_ = (1-a.^2) * alpha / (2 * kappaOU * beta^2);
skewness_ = (1-a.^3) ./ (1-a.^2).^(1.5) * (4/3) * sqrt(2 * kappaOU / alpha);
kurtosis_ = (1+a.^2) ./ (1-a.^2) * 6 * kappaOU / alpha + 3;
cumulant_at_one = ouGamma.CalculateCumulant(1, timeGrid(2:end));
exponentialMean = exp(cumulant_at_one); 

timeAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
meanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);

for n = 1:numel(numberOfSimulations)
    
    % Algorithm
    tic
    algorithm = ouGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ougammaincrement");
    algorithm(1, :) = [];
    timeAlgorithm(n) = toc;
    
    meanAlgorithm(n, :) = mean(algorithm, 2);
    varianceAlgorithm(n, :) = var(algorithm, 0, 2);
    skewnessAlgorithm(n, :) = skewness(algorithm, 0, 2);
    kurtosisAlgorithm(n, :) = kurtosis(algorithm, 0, 2);
    exponentialMeanAlgorithm(n, :) = mean(exp(algorithm), 2);
    
    clear algorithm
    

end

rmpath(genpath('../src'))

