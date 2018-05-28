% Metodos Numericos - EPGE/FGV 2018
% Instructor: Cezar Santos
% Problem Set 3 - Raul Guarini Riva

clc; close all; clear all;

%% Calibration and Steady State

% Same calibration as the previous problem set
beta = 0.987;
mu = 2;
alpha = 1/3;
delta = 0.012;
rho = 0.95;
sigma = 0.007;
m = 3;      % Tauchen's scale parameter

kss = ((alpha * beta)/(1 - beta*(1 - delta)))^(1/(1 - alpha));

% Defining functional forms for preferences and technology
u = @(c) (c.^(1-mu) - 1)/(1-mu);
f = @(z, k) exp(z).*k.^(alpha);

nk = 500;
nz = 7;
kgrid = linspace(0.75*kss, 1.25*kss, nk)';      % Column vector!!

% I use Tauchen's method, already implemented in the previous problem set
% in order to discretize productivity shock (via tauchen_ar1 function!)
[zgrid, P] = tauchen_ar1(0, rho, sigma^2, nz, m);
zgrid = zgrid';         % Row vector!
disp('Tauchen discretization done.')
disp(' ')   % Gimme some space!

%% Item 1 - Chebyshev Polynomials

% I will follow the steps from the slides
d = 10;         % Order of polynomial
gamma0 = ones(d+1, 1);     % Initial guess for gamma

% Finding the roots:
[~, roots] = chebyshev_poly(d+1, 0);

% Reverting to original grid:
a = 2/(max(kgrid) - min(kgrid));
b = -1*((max(kgrid) + min(kgrid)) / (max(kgrid) - min(kgrid)));
K0 = (roots - b)/a;

% % Using the resource constraint
% C0 = C_proj(gamma, K0, kgrid);
% K1 = K0.^alpha + (1 - delta)*K0 - C0;
% C1 = C_proj(gamma, K1, kgrid);

% % Creating the Risk Function
% R = @(gamma) beta*((C_proj(gamma, K0, kgrid)) / (C_proj(gamma, K0.^alpha + (1 - delta)*K0 - C_proj(gamma, K0, kgrid), kgrid))).^(-mu) * 

R = @(gamma) risk_function(gamma, K0, kgrid, alpha, mu, beta, delta);

[gamma_optimal, fval] = fsolve(R, gamma0)

