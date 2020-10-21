%% Solve the warm-up problems
options.k = csvread('points.kgd'); options.kMin = options.k(1);
IterRslt = iter_ks1998;

%% Generate random numbers
% Parameters
num_periods = 11000;
num_samples = 10000;

% Transition matrix for aggregate shocks
shock_trans = IterRslt.shock_trans;
% Reduction along the z dimension (beta,e,z) -> (beta',e',z')
shock_trans_zp = sum(reshape(shock_trans,[6,2,6,2]),3);
z_trans = reshape(shock_trans_zp(1,:,:),[2,2]);

% Aggregate shock
rng(0729);
z_idx = gen_discrete_markov_rn(z_trans,1,num_periods,1);
% Idiosyncratic shock conditional on aggregate shock
% Permute to (beta,e) -> (beta',e') | (z,z')
shock_trans_conditional_on_z = permute(reshape(shock_trans,[6,2,6,2]),[1,3,2,4]) ./ reshape(z_trans,[1,1,2,2]);
ind_shock_idx = gen_discrete_markov_rn_with_agg(shock_trans_conditional_on_z, num_samples, num_periods, 6*ones(num_samples,1), z_idx);

simuOptions.num_samples = num_samples;
simuOptions.GEN_SHOCK_START_PERIOD = num_periods;
simuOptions.init.shock = ind_shock_idx + (z_idx-1)*6;
simuOptions.init.k = 11*ones(num_samples,1);
simuOptions.init.kbar = 11*ones(num_samples,1);
simuOptions.EnforceSimuStateInbound = 0;

%% Iterate transition coefficients phi
phi = [
      0.96053     0.095014            0      -1.2228
      0.96072     0.099212            0      -1.1583
    ]';
metric_phi = inf;
tol_phi = 1e-4;
update_speed = 0.5;
iter = 0;
while metric_phi>tol_phi
    options.phi = phi;
    options.WarmUp = IterRslt;
    IterRslt = iter_ks1998(options);
    SimuRslt = simulate_ks1998(IterRslt,simuOptions);
    
    % Collect samples and run regression
    burnPeriods = 1000;
    periodIndex = 1:num_periods;
    r2_z = zeros(1,2);
    rmse_z = zeros(1,2);
    phi_new = phi;
    for i_z=1:2
        periodSet = periodIndex(z_idx==i_z & periodIndex>burnPeriods);
        sample_lbar = SimuRslt.lbar(1,periodSet);
        sample_kbar = SimuRslt.kbar(1,periodSet);
        sample_kbar_next = SimuRslt.kbar(1,periodSet+1);
        mdl = fitlm(log(sample_kbar),log(sample_kbar_next));
        
        phi_new(1,i_z) = mdl.Coefficients.Estimate(2);
        phi_new(2,i_z) = mdl.Coefficients.Estimate(1);
        phi_new(4,i_z) = log(mean(sample_lbar));
        r2_z(i_z) = mdl.Rsquared.Ordinary;
        rmse_z(i_z) = mdl.RMSE;
    end
    
    iter = iter+1;
    metric_phi = max(abs(phi(:) - phi_new(:)));
    fprintf('iter, metric_phi: %d, %g\n',iter, metric_phi);
    % Update
    phi = phi_new*update_speed + phi*(1-update_speed);
end

%% Post analysis
disp('Converged transition coefficients (phi_k_1 phi_k_0 phi_l_1 phi_l_0):');
disp(phi')
% fraction negative wealth
sum(SimuRslt.k(:,num_periods)<0) / numel(SimuRslt.k(:,num_periods))
% Gini coefficients
samplePeriods = num_periods;
k = SimuRslt.k(:,samplePeriods);
ginicoeff(k(k>=0))

%%%%%%%%%%%%%%% MAIN ENDS HERE %%%%%%%%%%%%%%%%%%
function shock = gen_discrete_markov_rn_with_agg(trans,numPaths,lenPath,initShock,aggIdx)
% Generate idiosyncratic shocks conditional on aggregate shocks
numStates = size(trans,1);
shock = zeros(numPaths,lenPath);
shock(:,1) = initShock;
cumTrans = cumsum(trans, 2);
for t=1:lenPath-1
    for j=1:numStates
        % Find samples that has shock j
        idxOfShockJ = find(shock(:,t)==j);
        % Fill in numbers based on distribution weights
        un = rand(length(idxOfShockJ),1);
        % Look up trans_j
        [~,shock(idxOfShockJ,t+1)] = histc(un, [0 cumTrans(j,:,aggIdx(t),aggIdx(t+1))]);
    end
end
end