%%
% Investigate CMOD A7 clock resolution
%
% CMOD A7 uses an Artix-7 xc7a35tcpq236-1
%  The input clock is 12 MHz (83.333 nsec period)
Fin = 12e6;
% The MMCM input clock frequency must fall between 10 and 800 MHz
Fin_range = [10,800]*1e6;
%
% Fvco is the VCO frequency. The allowable range is 600-1200
Fvco_range = [600,1200]*1e6;
Fout_range = [4.69,800]*1e6;

% Fvco = Fin * (M/8) where M is an integer
% Fout0 = Fvco / (DO/8) where DO is an integer
M_range = [max(ceil(Fvco_range(1)*8/Fin),2*8),min(floor(Fvco_range(2)*8/Fin),64*8)];
%%
Ms = M_range(1):M_range(2);
nM = length(Ms);
DO_range = zeros(nM,2);
for i=1:nM
  %%
  M = Ms(i);
  Fvco = Fin*M/8;
  DO_range(i,:) = [max(2,ceil(Fin*M/Fout_range(2))),min(128,floor(Fin*M/Fout_range(1)))];
end
nFout = sum(DO_range(:,2)-DO_range(:,1))+nM;
%%
Fout = zeros(nFout,1);
Fvco = zeros(nFout,1);
PhaseRes = zeros(nFout,1);
iFout = 0;
for i=1:nM
  M = Ms(i);
  Fvco_i = Fin*M/8;
  DO = DO_range(i,1):DO_range(i,2);
  Fout(iFout+(1:length(DO))) = Fvco_i*8./DO;
  Fvco(iFout+(1:length(DO))) = Fvco_i;
  PhaseRes(iFout+(1:length(DO))) = 56*DO/8;
  iFout = iFout + length(DO);
end
%%
[sFout,IA,IC] = unique(Fout);
dFout = (sFout(2:end)./sFout(1:end-1))-1;
uPhaseRes = PhaseRes(IA);
figure;
ax = [ nsubplot(2,1,1), nsubplot(2,1,2) ];
plot(ax(1),sFout(2:end)*1e-6,dFout*100,'.');
ylabel('% deviation to next freq');
plot(ax(2),sFout(2:end)*1e-6,uPhaseRes(2:end),'.');
xlabel('MHz');
ylabel('Phase Resolution');
set(ax(1),'XTickLabel',[],'YAxisLocation','Right');
linkaxes(ax,'x');
%xlim([100 300]);
%%
% Here I'm looking at the actual output frequency allowing for a final
% divisor of 20 or 21. This alone gets us down to less than 6e-4 increase
% between possible frequencies.
Fout20 = Fout/20;
Fout21 = Fout/21;
[sFout2X,IA2X,IC2X] = unique([Fout20;Fout21]);
dFout2X = (sFout2X(2:end)./sFout2X(1:end-1))-1;
sFout2Xa = sFout2X(1:end-1);
V = sFout2Xa >= 9.5e6 & sFout2Xa <= 9.75e6;
figure;
plot(sFout2Xa(V)*1e-6,dFout2X(V),'.');
xlabel('MHz');
ylabel('% deviation to next freq');
%%
sFout20 = sFout/20;
sFout21 = sFout/21;
figure;
plot(sFout20(2:end)*1e-6,dFout*100,'.',sFout21(2:end)*1e-6,dFout*100,'.');
xlabel('MHz');
ylabel('Phase Resolution');
%%
% If we used dynamic phase shifting to adjust our master clock's period,
% how much flexibility would that buy us?
% The fine resolution divides the output period into 56*DO phases
% Refering to ug472 p. 75, since our input clock is 12 MHz, we cannot
% have a D value greater than 1 or we would end up with PFD < the 10 MHz
% minimum. (That was what I assumed above.)
PFD_MAX = 450e6;
PFD_MIN = 10e6;
Dmin = ceil(Fin/PFD_MAX);
Dmax = floor(Fin/PFD_MIN);
% p. 75 neglects the fact that M is constrained between 2 and 64
Mmin = max(2,ceil(Fvco_range(1)*Dmin/Fin));
Mmax = min(64,floor(Fvco_range(2)*Dmax/Fin));
Mideal = Dmin*Fvco_range(2)/Fin;
%% Based on the previous calculations, in order to get a 100 MHz
% output from a 12 MHz input, We want D=1, M=100
% To get to 100 by integers, Fvco to be divisible by 100, so M must be a
% multiple of 25 between 50 and 64, so 50
M = 50;
DO = 6;
% Fractional mult and divide gives us more options maybe? Yes
% M*8 must be integer between 16 and 512 and must be divisible by 25
% M = 62.5;
% DO = 7.5;
% However, for the pusposes of this exercise, where we want to adjust
% the frequency via phase shifting, we cannot use fractional divide.

%%
% Actually, let's suppose we wanted to go with a second clock tile
% so we could get the minimum Fvco, setting M = DO and D = 1
Fin = 199e6; % MHz
M = 4; % 600 MHz minimum
Fvco = Fin*M;
DO = 4;
Fout = Fvco/DO;
Pout = 1/Fout;
Pdph = 1/(56*Fvco);
% Now every 12 clocks, I can increase or decrease the period by Pdph
% So the maximum average period is
Pmax = Pout+Pdph/12;
Pmin = Pout-Pdph/12;
Foutmax = 1/Pmin;
Foutmin = 1/Pmax;
dF = Foutmax/Foutmin - 1;
