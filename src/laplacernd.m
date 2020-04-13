function l = laplacernd(mu,varargin)
%LAPLACERND Random arrays from exponential distribution.
%   R = LAPLACERND(MU) returns an array of random numbers chosen from the
%   LAPLACE distribution with parameter MU (scale parameter).  The size of R is
%   the size of MU.
%
%   L = LAPLACERND(MU,M,N,...) or L = LAPLACE(MU,[M,N,...]) returns an
%   M-by-N-by-... array.
%
%   LAPLACE uses the inversion method.

%   References:
%      [1]  Devroye, L. (1986) Non-Uniform Random Variate Generation, 
%           Springer-Verlag.


if nargin < 1
    error(message('stats:laplace:rnd:TooFewInputs'));
end

[err, sizeOut] = internal.stats.statsizechk(1,mu,varargin{:});
if err > 0
    error(message('stats:laplace:InputSizeMismatch'));
end

% Return NaN for elements corresponding to illegal parameter values.
mu(mu < 0) = NaN;

% Generate uniform random values, and apply the exponential inverse CDF.
u = rand(sizeOut, 'like', mu) - 0.5;
l = -mu .* sign(u) .* log(1 - 2 .* abs(u)); % == laplaceinv(u, mu)

