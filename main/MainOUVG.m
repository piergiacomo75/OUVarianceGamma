% SCRIPT THAT REPRODUCES FIGURE 1 AND TABLE 2
clear
close all
clc

addpath(genpath('../src'))

sigma = 0.30;
kappaOU = 0.20;
theta = 0.25;
nu = 0.1;
commonTerm = 0.5 * sqrt(theta^2 + 2 * sigma^2 / nu);
mu_p = commonTerm + 0.5 * theta;
mu_n = commonTerm - 0.5 * theta;
nu_p = mu_p^2 * nu;
nu_n = mu_n^2 * nu;
x_0 = 0;
timeStep = 1/5;
maturity = 1;
timeGrid = 0:timeStep:maturity;
a = exp(-kappaOU * timeGrid(2:end));

ouVarianceGamma = OUVG(theta, nu, sigma, kappaOU, x_0);
     
% numberOfSimulations = 100000; [1000, 10000, 50000, 100000, 500000, 1000000]';
numberOfSimulations = 100000;[2500, 10000, 40000, 160000, 640000, 2560000]';
mean_= x_0 * a + (1 - a) * theta / kappaOU;
variance_ = (sigma^2 + theta^2 * nu)/ (2 * kappaOU) * (1-a.^2);
skewness_ = 2 * sqrt(2 * kappaOU) / 3 * (1 - a.^3) ./ (1 - a.^2).^(1.5) * (2 * theta^3 * nu^2 + 3 * sigma^2 * theta * nu) / (sigma^2 + theta^2 * nu)^(3/2);
kurtosis_ = kappaOU * (1+a.^2) ./ (1-a.^2) * (3 * sigma^4 * nu + 12 * sigma^2 * theta^2 * nu^2 + 6 * theta^4 * nu^3) / (sigma^2 + theta^2 * nu)^2 + 3;

cumulant_at_one = ouVarianceGamma.CalculateCumulant(1, timeGrid(2:end));
exponentialMean = exp(cumulant_at_one); 

timeAlgorithm = zeros(numel(numberOfSimulations), 1);
meanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);

for n = 1:numel(numberOfSimulations)
    
    % Algorithm
    tic
    algorithm = ouVarianceGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ouvariancegammaincrement");
    algorithm(1, :) = [];
    timeAlgorithm(n) = toc;
    
    meanAlgorithm(n, :) = mean(algorithm, 2);
    varianceAlgorithm(n, :) = var(algorithm, 0, 2);
    exponentialMeanAlgorithm(n, :) = mean(exp(algorithm), 2);    
    skewnessAlgorithm(n, :) = skewness(algorithm, 0, 2);
    kurtosisAlgorithm(n, :) = kurtosis(algorithm, 0, 2);
    clear algorithm
    

end
percErrMean = 1 - mean_ ./ meanAlgorithm;
percErrVariance = 1 - variance_ ./ varianceAlgorithm;
percErrSkewness = 1 - skewness_ ./ skewnessAlgorithm;
percErrKurtosis = 1 - kurtosis_ ./ kurtosisAlgorithm;
percErrExpMean = 1 - exponentialMean ./ exponentialMeanAlgorithm;

rmpath(genpath('../src'))
