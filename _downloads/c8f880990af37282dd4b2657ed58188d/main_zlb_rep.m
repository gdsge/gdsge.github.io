% clear;
% Uncomment to recompile
gndsge_codegen('zlb_rep');
options = struct;

% No ZLB as warmup
options.maxPriceAdjCostFactor=1e-2;
options.priceAdjCostFactor = 1;
options.xi = 9.7;
options.theta = 7.72;
options.R_ss = 1.0125;
options.pii_ub = 1 + 0.008;
options.pii_ss = 1 + 0.008;
options.pii_lb = 0.97;
options.pii_low = 0.98;
options.phi_pi = 2.5;
options.eta = 1.01;
options.beta = 0.99;
options.R_zlb = 0.0;
options.K_min = 20;
options.K_max = 40;
options.K_shift = 10;
options.K_pts = 41;
options.K = exp(linspace(log(options.K_min+options.K_shift),log(options.K_max+options.K_shift),options.K_pts)) - options.K_shift;
options.MaxIter=100;
options.NoSave = 1;
options.PrintFreq = 100;
IterRslt = iter_zlb_rep(options);

% Turn on ZLB
options.SkipModelInit = 1;
options.R_zlb = 1.0;
options.WarmUp = IterRslt;
options.MaxIter=inf;
options.beta = 1.005;
options.pii_lb = 0.97;
options.pii_low = 0.98;
options.K_min = 19;
options.K_max = 31;
options.K_shift = 10;
options.K_pts = 41;
options.TolEq = 1e-5;
options.Y_ss = 2.75;
options.phi_Y = 0.11;
options.K = exp(linspace(log(options.K_min+options.K_shift),log(options.K_max+options.K_shift),options.K_pts)) - options.K_shift;
IterRslt = iter_zlb_rep(options);
save('IterRslt_rep.mat','IterRslt');

SimuRslt = simulate_zlb_rep(IterRslt);
