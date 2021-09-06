%%%%%%%%%%%%%%%%%%%%%%%%%%% Simulate
% Genearte Markov process;
num_periods = 1000;
num_samples = 1;
N = iterRslt.params.numCountries;
rho_z = iterRslt.params.rho_z;
sigma_z = iterRslt.params.sigma_z;
md = arima('Constant', 0, 'AR', rho_z, 'Variance', sigma_z^2);
rng(0823);
z = simulate(md, num_periods+1, 'NumPaths', N);

simuOptions.num_periods = num_periods;
simuOptions.num_samples = 1;
simuOptions.z_exo = reshape(z,[1,num_periods+1,N]);

simuRslt = simulate_rbc(iterRslt,simuOptions);

%%%%%%%%%%%%%%%% Accuracy test %%%%
% Draw ergodic set
ergodicIdx = 501:1000;
ergodicSet = struct;
for i=1:N
    ergodicSet.(['z',num2str(i)]) = reshape(simuRslt.(['z',num2str(i)])(:,ergodicIdx),[],1);
    ergodicSet.(['K',num2str(i)]) = reshape(simuRslt.(['K',num2str(i)])(:,ergodicIdx),[],1);
end
numTestSamples = length(ergodicIdx);

% Number of paths one period forward each sample for accuracy test
numTestPaths = 1e4;
% draw pahts one period forward
% darw innovation
rng(0823);
epsilon = normrnd(0,sigma_z,numTestPaths*numTestSamples,N);
% replicate the ergoid set by numTestPaths
ergodicSetReplicate = struct;
for i=1:N
    ergodicSetReplicate.(['z',num2str(i)]) = repmat(ergodicSet.(['z',num2str(i)]),numTestPaths,1);
    ergodicSetReplicate.(['K',num2str(i)]) = repmat(ergodicSet.(['K',num2str(i)]),numTestPaths,1);
end
% generate the shock one period forward
simuOptions = struct;
simuOptions.num_periods = 2;
simuOptions.num_samples = numTestSamples*numTestPaths;
simuOptions.z_exo = zeros(numTestSamples*numTestPaths,3,N);
simuOptions.init = ergodicSetReplicate;
simuOptions.init.shock = ones(numTestPaths*numTestSamples,1);
for i=1:N
    simuOptions.z_exo(:,2,i) = rho_z*ergodicSetReplicate.(['z',num2str(i)]) + epsilon(:,i);
end
simuRsltAccuracyTest = simulate_rbc(iterRslt,simuOptions);

% evaluate euler residuals for each country standing at period 1
delta = iterRslt.params.delta;
sigma = iterRslt.params.sigma;
alpha = iterRslt.params.alpha;
beta = iterRslt.params.beta;
for i=1:N
    mpk_future = alpha*exp(simuRsltAccuracyTest.(['z',num2str(i)])(:,2)).*simuRsltAccuracyTest.(['K',num2str(i)])(:,2).^(alpha-1);
    lambda_future = simuRsltAccuracyTest.(['c',num2str(i)])(:,2).^(-sigma);
    lambda = simuRsltAccuracyTest.(['c',num2str(i)])(:,1).^(-sigma);
    eulerResidPath = -1 + beta*lambda_future.*(mpk_future+1-delta)./lambda;
    % integrate
    eulerResid = mean(reshape(eulerResidPath,[numTestPaths,numTestSamples]),1);
    meanEulerResid(i) = mean(abs(eulerResid(:)));
    maxEulerResid(i) = max(abs(eulerResid(:)));
end
meanEulerResid
maxEulerResid