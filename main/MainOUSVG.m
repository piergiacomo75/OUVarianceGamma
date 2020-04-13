% SCRIPT THAT REPRODUCES FIGURE 1 AND TABLE 2
clear
close all
clc

addpath(genpath('../src'))

nu = 0.256;
sigma = 0.201;
kappaOU = 0.2162;
x_0 = 0;
timeStep = 1/5;
maturity = 1/5;
timeGrid = 0:timeStep:maturity;
a = exp(-kappaOU * timeGrid(2:end));

ouSymmetricVarianceGamma = OUSVG(nu, sigma, kappaOU, x_0);
     
% numberOfSimulations = 100000; [1000, 10000, 50000, 100000, 500000, 1000000]';
numberOfSimulations = 100000;[2500, 10000, 40000, 160000, 640000, 2560000]';
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

timeAlgorithm = zeros(numel(numberOfSimulations), 1);
meanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
varianceAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
thirdMomentAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
forthMomentAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
exponentialMeanAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
skewnessAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);
kurtosisAlgorithm = zeros(numel(numberOfSimulations), numel(timeGrid) - 1);


for n = 1:numel(numberOfSimulations)
    
    % Algorithm
    tic
    algorithm = ouSymmetricVarianceGamma.SimulateTrajectory(timeGrid, numberOfSimulations(n), "ousymmetricvariancegammaincrement");
    algorithm(1, :) = [];
    timeAlgorithm(n) = toc;
    
    meanAlgorithm(n, :) = mean(algorithm, 2);
    varianceAlgorithm(n, :) = var(algorithm, 0, 2);
    thirdMomentAlgorithm(n, :) = mean(algorithm.^3, 2);
    forthMomentAlgorithm(n, :) = mean(algorithm.^4, 2);
    exponentialMeanAlgorithm(n, :) = mean(exp(algorithm), 2);    
    skewnessAlgorithm(n, :) = skewness(algorithm, 0, 2);
    kurtosisAlgorithm(n, :) = kurtosis(algorithm, 0, 2);
%     clear algorithm
    

end
percErrExpMean = 1 - exponentialMean ./ exponentialMeanAlgorithm;
percErrVariance = 1 - variance_ ./ varianceAlgorithm;
percErrForthMoment = 1 - forthMoment ./ forthMomentAlgorithm;
percErrKurtosis = 1 - kurtosis_ ./ kurtosisAlgorithm;

rmpath(genpath('../src'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 2

figure(2)

% Right
trajectory = algorithm(:, 3);
plot(trajectory);

title('Trajectory of a OU-Symmetric-VG process', 'Color','black', 'FontSize', 12)
xlabel('Number of steps', 'Color','black') % x-axis label

ax = gca;
ax.XColor = 'black';
ax.YColor = 'black';
