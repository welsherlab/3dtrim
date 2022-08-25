function [alpha]=msdcalcExp_Alphaonly(x,y,z,samplingRate)
xyz=[x y z];
nData = size(xyz,1); %# number of data points
numberOfDeltaT = floor(nData/4); 
%# for MSD, dt should be up to 1/4 of number of data points

msd = zeros(numberOfDeltaT,3); %# We'll store [mean, std, n]
hWait=waitbar(0,'MSD','Color','w');
set(hWait,'Position',[249 260.25 270 56.25])
%# calculate msd for all deltaT's
for dt = 1:numberOfDeltaT
   deltaCoords = xyz(1+dt:end,:) - xyz(1:end-dt,:);
   squaredDisplacement = sum(deltaCoords.^2,2); %# dx^2+dy^2+dz^2

   msd(dt,1) = mean(squaredDisplacement); %# average
   msd(dt,2) = std(squaredDisplacement); %# std
   msd(dt,3) = length(squaredDisplacement); %# 
   if ~mod(dt+1,100)
   waitbar(dt/numberOfDeltaT,hWait)
   end
end

time=(1:length(msd(:,1)))/samplingRate;

%Diffusion coefficient in micron^2/sec
[fitresult,gof] = msdFitExp(time, msd(:,1)');
% 
% disp(['size of t is ' num2str(size(time))])
% disp(['size of msd is ' num2str(size(msd(:,1)))])
coeffs=coeffvalues(fitresult);
D=coeffs(1)/6;
alpha=coeffs(2);
Rsquared=gof.rsquare;

close(hWait);
end