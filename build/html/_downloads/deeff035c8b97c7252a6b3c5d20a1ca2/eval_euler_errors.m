% Extract the ergodic set
NUM_PERIODS = 1000;
w1 = reshape(SimuRslt.w1(:,end-NUM_PERIODS:end),1,[]);
shock = reshape(SimuRslt.shock(:,end-NUM_PERIODS:end),1,[]);
% Replicate the sample to accomodate future shock realizations
w1 = repmat(w1,IterRslt.shock_num,1);
shock1 = repmat(shock,IterRslt.shock_num,1);
shock2 = repmat([1:IterRslt.shock_num]',1,size(w1,2));

% Simulate forward for one period
simuOptions = struct;
simuOptions.init.w1 = w1(:);
simuOptions.init.shock = [shock1(:),shock2(:)];
% The following line states that the first two-period shock indexes are
% supplied and not regenerated
simuOptions.GEN_SHOCK_START_PERIOD = 2;
simuOptions.num_samples = numel(w1);
simuOptions.num_periods = 2;    % One-period forecasting error
% The following line simulates one period forward by starting from w1 and
% shock contained in simuOptions
simuForward = simulate_HL1996(IterRslt,simuOptions);

% Calculate Errors
beta = IterRslt.params.beta;
gamma = IterRslt.params.gamma;
c1 = simuForward.c1(:,1); c1n = simuForward.c1(:,2);
ps = simuForward.ps(:,1); psn = simuForward.ps(:,2);
pb = simuForward.pb(:,1);
ms1 = simuForward.ms1(:,1); mb1 = simuForward.mb1(:,1);
gn = IterRslt.var_shock.g(shock2(:))';
dn = IterRslt.var_shock.d(shock2(:))';
es1_error = -1 + beta*gn.^(1-gamma).*(c1n./c1).^(-gamma).*(psn+dn)./ps + ms1;
eb1_error = -1 + beta*gn.^(-gamma).*(c1n./c1).^(-gamma)./pb + mb1;
% Calculate expectation errors, integrating using the transition matrix
shock_trans = IterRslt.shock_trans(shock,:)';
shock_num = IterRslt.shock_num;
es1_expect_error = sum(shock_trans.*reshape(es1_error,shock_num,[]),1);
max_abs_es1_error = max(abs(es1_expect_error))
mean_abs_es1_error = mean(abs(es1_expect_error))
eb1_expect_error = sum(shock_trans.*reshape(eb1_error,shock_num,[]),1);
max_abs_eb1_error = max(abs(eb1_expect_error))
mean_abs_eb1_error = mean(abs(eb1_expect_error))