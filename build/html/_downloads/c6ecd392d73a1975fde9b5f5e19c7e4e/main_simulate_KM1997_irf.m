clc;

options=struct;
options.SimuPrintFreq=1000;
rng(0823);

SimuRslt = simulate_KM1997(IterRslt);

num_periods = length(SimuRslt.kF)-1;



% Get Ergodi Set
startIdx = round(num_periods/2);
endIdx = num_periods;
shock = SimuRslt.shock(:,startIdx:endIdx);
kF = SimuRslt.kF(:,startIdx:endIdx);
omega = SimuRslt.omega(:,startIdx:endIdx);
bF = SimuRslt.bF(:,startIdx:endIdx);

GDSGE_PP = IterRslt.output_interp;
output_var_index = IterRslt.output_var_index;
NumThreads = feature('numcores');

%% positive shock
Interp_pos = myinterp_mex(int32(NumThreads),GDSGE_PP.breaks,GDSGE_PP.coefs,int32(GDSGE_PP.pieces),int32(GDSGE_PP.order),int32(GDSGE_PP.dim),'not-a-knot',[shock(:)';kF(:)';omega(:)'],[],[],[]);
kFnext=Interp_pos(output_var_index.kFpol,:)';
omega_next_Neg=Interp_pos(output_var_index.omega_next(1),:)';
omega_next_Nor=Interp_pos(output_var_index.omega_next(2),:)';
omega_next_Pos=Interp_pos(output_var_index.omega_next(3),:)';

shockPos = shock;
shockPos(:) = 3;

lenSamples = numel(shock);
optionsPos.init.shock = [shock(:),shockPos(:)];
optionsPos.init.kF = [kF(:),kFnext];
optionsPos.init.omega = [omega(:),omega_next_Pos];
optionsPos.GEN_SHOCK_START_PERIOD = 2;

% Simulate forward
optionsPos.num_samples = lenSamples;
optionsPos.num_periods = 200;
%optionsPos.SimuPrintFreq = 10;
SimuRsltIrf_pos = simulate_KM1997(IterRslt,optionsPos);

optionsNor = optionsPos;
shockNor = shock;
shockNor(:) = 2;
optionsNor.init.shock = [shock(:),shockNor(:)];
optionsNor.init.omega = [omega(:),omega_next_Nor];
SimuRsltIrf_nor = simulate_KM1997(IterRslt,optionsNor);



% Construct and plot the IRF
irf_pos.q = mean(SimuRsltIrf_pos.q(:,2:end) - SimuRsltIrf_nor.q(:,2:end));
irf_pos.Y = mean(SimuRsltIrf_pos.Y(:,2:end) - SimuRsltIrf_nor.Y(:,2:end));
irf_pos.kF = mean(SimuRsltIrf_pos.Y(:,3:end) - SimuRsltIrf_nor.Y(:,3:end));
irf_pos.bF = mean(SimuRsltIrf_pos.Y(:,3:end) - SimuRsltIrf_nor.Y(:,3:end));

irf_pos.q_pct = mean(SimuRsltIrf_pos.q(:,2:end) - SimuRsltIrf_nor.q(:,2:end))./mean(SimuRsltIrf_nor.q(:,2:end));
irf_pos.Y_pct = mean(SimuRsltIrf_pos.Y(:,2:end) - SimuRsltIrf_nor.Y(:,2:end))./mean(SimuRsltIrf_nor.Y(:,2:end));
irf_pos.kF_pct = mean(SimuRsltIrf_pos.kF(:,3:end) - SimuRsltIrf_nor.kF(:,3:end))./mean(SimuRsltIrf_nor.kF(:,3:end));
irf_pos.bF_pct = mean(SimuRsltIrf_pos.bF(:,3:end) - SimuRsltIrf_nor.bF(:,3:end))./mean(SimuRsltIrf_nor.bF(:,3:end));


%% negative shock
optionsNeg = optionsPos;
shockNeg = shock;
shockNeg(:) = 1;
optionsNeg.init.shock = [shock(:),shockNeg(:)];
optionsNeg.init.omega = [omega(:),omega_next_Neg];
SimuRsltIrf_neg = simulate_KM1997(IterRslt,optionsNeg);

% Construct and plot the IRF
irf_neg.q = mean(SimuRsltIrf_neg.q(:,2:end) - SimuRsltIrf_nor.q(:,2:end));
irf_neg.Y = mean(SimuRsltIrf_neg.Y(:,2:end) - SimuRsltIrf_nor.Y(:,2:end));
irf_neg.kF = mean(SimuRsltIrf_neg.Y(:,3:end) - SimuRsltIrf_nor.Y(:,3:end));
irf_neg.bF = mean(SimuRsltIrf_neg.Y(:,3:end) - SimuRsltIrf_nor.Y(:,3:end));

irf_neg.q_pct = mean(SimuRsltIrf_neg.q(:,2:end) - SimuRsltIrf_nor.q(:,2:end))./mean(SimuRsltIrf_nor.q(:,2:end));
irf_neg.Y_pct = mean(SimuRsltIrf_neg.Y(:,2:end) - SimuRsltIrf_nor.Y(:,2:end))./mean(SimuRsltIrf_nor.Y(:,2:end));
irf_neg.kF_pct = mean(SimuRsltIrf_neg.kF(:,3:end) - SimuRsltIrf_nor.kF(:,3:end))./mean(SimuRsltIrf_nor.kF(:,3:end));
irf_neg.bF_pct = mean(SimuRsltIrf_neg.bF(:,3:end) - SimuRsltIrf_nor.bF(:,3:end))./mean(SimuRsltIrf_nor.bF(:,3:end));

save('KM_irf.mat','irf_pos','irf_neg');


figure(11);clf; 
subplot(2,2,1);
plot((irf_pos.q_pct(1:end))*100,'LineWidth',2);
hold on;
plot((-irf_neg.q_pct(1:end))*100,'--','LineWidth',2);
xlabel('Periods','interpreter','latex','FontSize',12);
ylabel('%');
title('Capital Price','interpreter','latex');
AX = legend('Positive 1% TFP Shock','Negative 1% TFP Shock');
set(gca,'FontSize',15);
% 
subplot(2,2,2);
plot((irf_pos.Y_pct(1:end))*100,'LineWidth',2);
hold on;
plot((-irf_neg.Y_pct(1:end))*100,'--','LineWidth',2);
xlabel('Periods','interpreter','latex','FontSize',12);
ylabel('%');
title('Output','interpreter','latex');
set(gca,'FontSize',15);

subplot(2,2,3);
plot((irf_pos.kF_pct(1:end))*100,'LineWidth',2); 
hold on;
plot((-irf_neg.kF_pct(1:end))*100,'--','LineWidth',2);
xlabel('Periods','interpreter','latex','FontSize',12);
ylabel('%');
title('Farmer''s Capital','interpreter','latex');
%AX = legend('Positive TFP Shock','Negative TFP Shock');
set(gca,'FontSize',15);

subplot(2,2,4);
plot((irf_pos.bF_pct(1:end))*100,'LineWidth',2); 
hold on;
plot((-irf_neg.bF_pct(1:end))*100,'--','LineWidth',2);
xlabel('Periods','interpreter','latex','FontSize',12);
ylabel('%');
title('Farmer''s Debt','interpreter','latex');
set(gca,'FontSize',15);

