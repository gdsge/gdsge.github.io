function [z,P,d]=tauchen(n,mu,rho,sigma,k)
% One-dimensional Tauchen method to approximate AR(1) process by Markov chain
% z(t+1) = (1-rho)*mu + rho*z(t) + e(t),  where e(t)~Normal(0,sigma)
% Input Arguments:
%      n - number of states in Markov chain
%     mu - unconditional mean of process
%    rho - autocorrelation coefficient
%  sigma - standard deviation of innovations
% Optional Input Argument:
%      k - number of standard deviations from mean (default=3)
% Output Arguments:
%      z - Markov states
%      P - Markov transition matrix
%      d - Stationary distribution of Markov chain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Iskander Karibzhanov
%          Department of Economics
%          University of Minnesota
%          karib003@umn.edu

if nargin<5; k=3; end
z=linspace(-1,1,n)*k/sqrt(1-rho^2);
P=normcdf(bsxfun(@minus,z+z(n)/(n-1),rho*z'));
P(:,n)=1;
P(:,2:n)=diff(P,1,2);
z=sigma*z+mu;
[d,~]=eigs(P',1,1);
d=d'/sum(d);