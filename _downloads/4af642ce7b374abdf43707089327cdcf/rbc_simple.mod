% Parameters
parameters beta sigma alpha delta rho_z;
beta  = 0.99;		% discount factor
sigma = 2.0;		% CRRA coefficient
alpha = 0.36;		% capital share
delta = 0.025;		% depreciation rate
rho_z = 0.80;       % persistence in prod.

% Exogenous variables
varexo epsilon_z;
shocks;
var epsilon_z; stderr 0.01;
end;

% Endogenous variables
var K_next c w z;







% Model
model;
  #kret_next = z(+1)*alpha*K_next^(alpha-1) + 1-delta;
  #euler_residual = c^(-sigma) - beta*c(+1)^(-sigma)*kret_next;
  #market_clear = z*K_next(-1)^alpha + (1-delta)*K_next(-1) - c - K_next;
  w = z*(1-alpha)*K_next(-1)^alpha;
  log(z) = rho_z*log(z(-1)) + epsilon_z;
  euler_residual;
  market_clear;

end;

initval;
K_next = 1;
c = 1;
w = 1;
z = 1;
end;
steady;
stoch_simul(periods=1000);