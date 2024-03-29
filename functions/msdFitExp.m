function [fitresult, gof] = msdFitExp(time, msd)
%CREATEFIT1(TIME,Y)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : time
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 18-Jul-2019 10:52:15


%% Fit: 'MSD Fit'.
[xData, yData] = prepareCurveData( time, msd );

% Set up fittype and options.
ft = fittype( 'a*x^b', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.69820367062893 0.536653402219393];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );




