
function [time,msd,D]=msdcalc_CP(x,y,z,samplingRate)
xyz=[x y z];
nData = size(xyz,1); %# number of data points
numberOfDeltaT = floor(nData/4); 
%# for MSD, dt should be up to 1/4 of number of data points

msd = zeros(numberOfDeltaT,3); 
hWait=waitbar(0,'MSD','Color','w');
set(hWait,'Position',[249 260.25 270 56.25])
%# calculate msd for all deltaT's
for dt = 1:numberOfDeltaT
   deltaCoords = xyz(1+dt:end,:) - xyz(1:end-dt,:);
   squaredDisplacement = sum(deltaCoords.^2,2); %# dx^2+dy^2+dz^2

   msd(dt,1) = mean(squaredDisplacement); %# average
   msd(dt,2) = std(squaredDisplacement); %# std
   msd(dt,3) = length(squaredDisplacement); %# 
   waitbar(dt/numberOfDeltaT,hWait)
end

time=(1:length(msd(:,1)))/samplingRate;

%Diffusion coefficient in micron^2/sec
D = lsqcurvefit(@slopeonly,6,time',msd(:,1))/6;

%Particle radius in nm
r=(1/((D*1e-12)*6*pi/1.381e-23/293.15*1.005e-3))*1e9;
%Draws figure, but not saved
% hMSD=figure;
% set(0,'CurrentFigure',hMSD);
% hold('on');
% errorbar(time,msd(:,1),msd(:,2)./sqrt(msd(:,3)));
% plot(time,6*D*time,'r');
% lims=[min(time) max(time) min(msd(:,1)) max(msd(:,1))];
% text(0.1*lims(2),0.9*lims(4),sprintf('D = %g',D),'Color','k');
% text(0.1*lims(2),0.8*lims(4),sprintf('r = %g',r),'Color','k');
close(hWait);