% SCRIPT THAT REPRODUCES FIGURE 1 AND TABLE 2
clear
close all
clc

addpath(genpath('../src'))

nu = 0.256;
sigma = 0.201;
kappaOU = 0.2162;
x_0 = 0;
timeStep = 1.5;
maturity = 1.5;
timeGrid = 0:timeStep:maturity;
a = exp(-kappaOU * timeGrid(2:end));

ouSymmetricVarianceGamma = OUSVG(nu, sigma, kappaOU, x_0);
     
% numberOfSimulations = 100000; [1000, 10000, 50000, 100000, 500000, 1000000]';
numberOfSimulations = 100;[2500, 10000, 40000, 160000, 640000, 2560000]';
mean_= x_0 * a;
variance_ = sigma^2 / (2 * kappaOU) * (1-a.^2);
thirdMoment = 0;
forthMoment = (3 * sigma^4 / (4 * kappaOU^2)) .* (1 - a.^2).^2 + (3 * sigma^4 * nu / (4 * kappaOU)) .* (1 - a.^4);
skewness_ = 0;
kurtosis_ = 3 * (kappaOU * nu * (1+a.^2) ./ (1-a.^2) + 1);


ell_1 = sigma^2 * nu / 2;
ell_0 = ell_1 * a.^2;
kumulant_at_one = x_0 * a + (dilog(ell_1) - dilog(ell_0)) / (2 * nu * kappaOU);
exponentialMean = exp(kumulant_at_one); 

timeAlgorithmSabino = zeros(numel(numberOfSimulations), 1);
meanAlgorithmSabino = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithmSabino = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithmSabino = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithmSabino = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithmSabino = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);

for n = 1:numel(numberOfSimulations)
    
%     Algorithm Sabino
    tic
    algorithmSabino = ouSymmetricVarianceGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ousymmetricvariancegammaincrement");
    algorithmSabino(1, :) = [];
    timeAlgorithmSabino(n) = toc;    
    
    meanAlgorithmSabino(n, :) = mean(algorithmSabino, 2);
    varianceAlgorithmSabino(n, :) = var(algorithmSabino, 0, 2);
    exponentialMeanAlgorithmSabino(n, :) = mean(exp(algorithmSabino), 2);    
    skewnessAlgorithmSabino(n, :) = skewness(algorithmSabino, 0, 2);
    kurtosisAlgorithmSabino(n, :) = kurtosis(algorithmSabino, 0, 2);
    clear algorithmSabino
      
end

percErrMeanSabino = 1 - meanAlgorithmSabino ./ mean_ ;
percErrVarianceSabino = 1 - varianceAlgorithmSabino ./ variance_ ;
percErrSkewnessSabino = 1 - skewnessAlgorithmSabino ./ skewness_ ;
percErrKurtosisSabino = 1 - kurtosisAlgorithmSabino ./ kurtosis_ ;
percErrExpMeanSabino = 1 - exponentialMeanAlgorithmSabino ./ exponentialMean ;

theta = 0;
ouVarianceGamma = OUVG(theta, nu, sigma, kappaOU, x_0);

timeAlgorithmApprox1 = zeros(numel(numberOfSimulations), 1);
meanAlgorithmApprox1 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithmApprox1 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithmApprox1 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithmApprox1 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithmApprox1 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);

for n = 1:numel(numberOfSimulations)
    
%     Algorithm Benth, Approx1
    tic
    algorithmApprox1 = ouVarianceGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ouvariancegammaincrementapprox1");
    algorithmApprox1(1, :) = [];
    timeAlgorithmApprox1(n) = toc;    
    
    meanAlgorithmApprox1(n, :) = mean(algorithmApprox1, 2);
    varianceAlgorithmApprox1(n, :) = var(algorithmApprox1, 0, 2);
    exponentialMeanAlgorithmApprox1(n, :) = mean(exp(algorithmApprox1), 2);    
    skewnessAlgorithmApprox1(n, :) = skewness(algorithmApprox1, 0, 2);
    kurtosisAlgorithmApprox1(n, :) = kurtosis(algorithmApprox1, 0, 2);
    clear algorithmApprox1
      
end

percErrMeanApprox1 = 1 - meanAlgorithmApprox1 ./ mean_ ;
percErrVarianceApprox1 = 1 - varianceAlgorithmApprox1 ./ variance_ ;
percErrSkewnessApprox1 = 1 - skewnessAlgorithmApprox1 ./ skewness_ ;
percErrKurtosisApprox1 = 1 - kurtosisAlgorithmApprox1 ./ kurtosis_ ;
percErrExpMeanApprox1 = 1 - exponentialMeanAlgorithmApprox1 ./ exponentialMean ;

timeAlgorithmApprox2 = zeros(numel(numberOfSimulations), 1);
meanAlgorithmApprox2 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithmApprox2 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithmApprox2 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithmApprox2 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithmApprox2 = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);

for n = 1:numel(numberOfSimulations)
    
%     Algorithm Cufaro, Approx2
    tic
    algorithmApprox2 = ouVarianceGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ouvariancegammaincrementapprox2");
    algorithmApprox2(1, :) = [];
    timeAlgorithmApprox2(n) = toc;    
    
    meanAlgorithmApprox2(n, :) = mean(algorithmApprox2, 2);
    varianceAlgorithmApprox2(n, :) = var(algorithmApprox2, 0, 2);
    exponentialMeanAlgorithmApprox2(n, :) = mean(exp(algorithmApprox2), 2);    
    skewnessAlgorithmApprox2(n, :) = skewness(algorithmApprox2, 0, 2);
    kurtosisAlgorithmApprox2(n, :) = kurtosis(algorithmApprox2, 0, 2);
    clear algorithmApprox2
      
end

percErrMeanApprox2 = 1 - meanAlgorithmApprox2 ./ mean_ ;
percErrVarianceApprox2 = 1 - varianceAlgorithmApprox2 ./ variance_ ;
percErrSkewnessApprox2 = 1 - skewnessAlgorithmApprox2 ./ skewness_ ;
percErrKurtosisApprox2 = 1 - kurtosisAlgorithmApprox2 ./ kurtosis_ ;
percErrExpMeanApprox2 = 1 - exponentialMeanAlgorithmApprox2 ./ exponentialMean ;

rmpath(genpath('../src'))
