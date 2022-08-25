function [zpos]=autoloadETLCal_f(vidfname,PDRatioEXP)
x=PDRatioEXP;

% convert vidfname to data then to Cal_ID
Cal_ID = [];
datenum = str2double(vidfname(1:6));

if datenum >=220322 %NEWCALDATE
    Cal_ID = 780.220322;
    
elseif datenum >=220316 && datenum < 220322
    Cal_ID = 780.220316;
    
elseif datenum >=220228 && datenum < 220316
    Cal_ID = 780.220228;

elseif datenum >= 220210 && datenum < 220228
    Cal_ID = 780.220210;
    
elseif datenum >= 210603 && datenum < 220210
    Cal_ID = 800.210603;
    
elseif datenum >= 210518 && datenum < 210603
    Cal_ID = 800.210321;
    
elseif datenum >= 210318 && datenum < 210518
    Cal_ID = 800.210321;
   
 elseif datenum >= 210202 && datenum <210318
    Cal_ID = 800.210202;      
    
elseif datenum >= 201211 && datenum <210201
    Cal_ID = '800.201212b';    
    
elseif datenum >= 201016 && datenum <201210
    Cal_ID = 800.201016;
    
elseif 200913 <= datenum && datenum < 201016
    Cal_ID = '800.200913b';
    
elseif 200911 <= datenum && datenum < 200913
    Cal_ID = 800.200911;
    
elseif 200910 <= datenum && datenum < 200911
    Cal_ID = 800.200910;
    
elseif 200130 <= datenum && datenum < 200910
    Cal_ID = 755.200130;
    
elseif datenum < 200130 
    Cal_ID = 2.232; %Note this is incorrect, but do not process data this old using the autoloader.
    
end

%FORMAT FOR NEW ENTIRES
% elseif datenum >=LASTCALDATE && datenum <NEWCALDATE
%     Cal_ID = NEWCALID;  


% if isequal(Cal_ID,NEWCALID)
% comat= ...
% [PASTE COEFFS HERE
%];
%  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

if isequal(Cal_ID,780.220322)
comat= ...
    [6.729892e+01
5.020713e+00
4.586332e+01
5.476885e+00
-5.465856e+00
2.245985e+01
-2.663538e+00
7.265174e+00
];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end

if isequal(Cal_ID,780.220316)
comat= ...
    [1.042279e+02
-1.811329e+01
7.619792e+01
1.676873e-01
-8.632097e+00
3.556752e+01
-4.592920e+00
1.153561e+01
];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end

if isequal(Cal_ID,780.220228)
comat= ...
    [7.453190e+04
-5.573205e+04
7.370525e+04
-2.057452e+03
-9.413275e+03
2.875313e+04
-9.746255e+03
1.041242e+04
];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end

if isequal(Cal_ID,780.220210)
comat= ...
    [4.220678e+01
1.497941e+01
3.228072e+01
5.825094e-01
-1.679892e+00
1.256866e+01
1.776709e+00
4.900710e+00];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end

if isequal(Cal_ID,800.210603)
comat= ...
    [5.424912e+04
-2.875758e+04
8.003305e+04
-1.073338e+04
-4.968653e+03
2.639172e+04
-6.430542e+03
1.458179e+04];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end


if isequal(Cal_ID,800.210518)
comat= ...
    [5.129883e+04
2.560651e+04
8.538434e+04
-6.021209e+03
-2.391324e+03
2.374490e+04
3.259992e+03
1.526478e+04];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end

if isequal(Cal_ID,800.210321)
    comat= ...
    [2.454363e+01
3.773165e+00
9.591718e+00
1.188904e-01
-1.703350e+00
7.778013e+00
-5.877984e-02
1.598884e+00];
  zpos=(comat(1).*x.^3 + comat(2).*x.^2 + comat(3).*x + comat(4)) ./ (x.^4 + comat(5).*x.^3 + comat(6).*x.^2 + comat(7).*x + comat(8)); 

end





% original code below

if isequal(Cal_ID,800.210202)
% % %    fitresultCAL = 
% % % 
% % %      General model Rat34:
% % %      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
% % %                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% % %      Coefficients (with 95% confidence bounds):

       p1 =       31.11;%  (25.24, 36.72)
       p2 =       14.78;%  (3.486, 23.73)
       p3 =       18.59;%  (9.271, 43.7)
       p4 =       0.8899 ;% (-0.2768, 0.1521)
       q1 =      -1.564;%  (-2.091, -0.9116)
       q2 =       9.461;%  (6.802, 13.47)
       q3 =       1.165 ;% (-1.123, 3.317)
       q4 =       2.779;%  (1.434, 7.609)
 
    zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
end


if isequal(Cal_ID,'800.201212b')
% % %    fitresultCAL = 
% % % 
% % %      General model Rat34:
% % %      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
% % %                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% % %      Coefficients (with 95% confidence bounds):
       p1 =       30.98;%  (25.24, 36.72)
       p2 =       13.61;%  (3.486, 23.73)
       p3 =       26.49;%  (9.271, 43.7)
       p4 =    -0.06236 ;% (-0.2768, 0.1521)
       q1 =      -1.501;%  (-2.091, -0.9116)
       q2 =       10.14;%  (6.802, 13.47)
       q3 =       1.097 ;% (-1.123, 3.317)
       q4 =       4.521;%  (1.434, 7.609)
 
    zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
end

if isequal(Cal_ID,800.201016)
    
%     General model Rat34:
%      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
%                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
%      Coefficients (with 95% confidence bounds):
       p1 =   3.561e+04 ;% (-7.368e+07, 7.375e+07)
       p2 =   3.607e+04 ;% (-7.458e+07, 7.465e+07)
       p3 =   6.083e+04 ;% (-1.259e+08, 1.26e+08)
       p4 =   1.486e+04 ;% (-3.076e+07, 3.079e+07)
       q1 =       -2469 ;% (-5.118e+06, 5.113e+06)
       q2 =   1.286e+04  ;%(-2.661e+07, 2.664e+07)
       q3 =       -1563;%  (-3.247e+06, 3.244e+06)
       q4 =        7187;%  (-1.487e+07, 1.489e+07)
zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
end



if isequal(Cal_ID,'800.200913b')
% %    fitresultCAL = 
% % 
% %      General model Rat34:
% %      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
% %                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
%      Coefficients (with 95% confidence bounds):
       p1 =       262.5 ;% (-922.6, 1448)
       p2 =       40.44 ;% (-161.2, 242.1)
       p3 =       255.6 ;% (-1039, 1550)
       p4 =       50.04 ;% (-204.4, 304.5)
       q1 =      -24.94 ;% (-141, 91.13)
       q2 =       102.4 ;% (-380.2, 584.9)
       q3 =      -14.11 ;% (-86.62, 58.39)
       q4 =       40.04 ;% (-163.8, 243.8)
zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
       % % % gofCAL = 
% % % 
% % %   struct with fields:
% % % 
% % %            sse: 0.030397476673240
% % %        rsquare: 0.999886356446909
% % %            dfe: 13
% % %     adjrsquare: 0.999825163764475
% % %           rmse: 0.048355635001550 
end



if isequal(Cal_ID,800.200911)
% % %    fitresultCAL = 
% % % 
% % %      General model Rat34:
% % %      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
% % %                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% % %      Coefficients (with 95% confidence bounds):
       p1 =       32.45 ;% (16.52, 48.37)
       p2 =       5.414 ;% (-7.245, 18.07)
       p3 =       10.37 ;% (-0.7034, 21.44)
       p4 =       1.539 ;% (-0.3007, 3.379)
       q1 =      -2.386 ;% (-4.801, 0.02947)
       q2 =       8.378 ;% (2.655, 14.1)
       q3 =     -0.2485 ;% (-3.013, 2.516)
       q4 =       1.486 ;% (-0.3203, 3.293)
     zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
       
       
% % gofCAL = 
% % 
% %   struct with fields:
% % 
% %            sse: 0.0268
% %        rsquare: 0.9998
% %            dfe: 12
% %     adjrsquare: 0.9997
% %           rmse: 0.0472 
end
if isequal(Cal_ID,800.200910)
% % %       General model Rat34:
% % %      fitresultCAL(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
% % %                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% % %      Coefficients (with 95% confidence bounds):
       p1 =   7.245e+04 ;% (-2.859e+08, 2.86e+08)
       p2 =   1.434e+05 ;% (-5.658e+08, 5.661e+08)
       p3 =    4.81e+04 ;% (-1.898e+08, 1.899e+08)
       p4 =   3.048e+04 ;% (-1.203e+08, 1.204e+08)
       q1 =       -8460 ;% (-3.339e+07, 3.338e+07)
       q2 =   4.247e+04 ;% (-1.676e+08, 1.677e+08)
       q3 =   -1.18e+04 ;% (-4.657e+07, 4.655e+07)
       q4 =   1.053e+04 ;% (-4.154e+07, 4.156e+07) 
    
      zpos=(p1.*x.^3 + p2.*x.^2 + p3.*x + p4) ./ (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4); 
       
       
end


if isequal(Cal_ID,755.200130)

% 
% General model Rat34:
%      f(x) = (p1*x^3 + p2*x^2 + p3*x + p4) /
%                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% Coefficients (with 95% confidence bounds):
       p1 =   2.664e+05; % (-1.527e+09, 1.527e+09)
       p2 =  -1.487e+05; % (-8.524e+08, 8.521e+08)
       p3 =   1.286e+05; % (-7.37e+08, 7.373e+08)
       p4 =  -2.442e+04; % (-1.4e+08, 1.4e+08)
       q1 =   1.243e+04; % (-7.123e+07, 7.126e+07)
       q2 =   2.641e+04; % (-1.514e+08, 1.514e+08)
       q3 =   -1.13e+04; % (-6.477e+07, 6.475e+07)
       q4 =        6294; % (-3.607e+07, 3.608e+07)
% 
% Goodness of fit:
%   SSE: 0.3158
%   R-square: 0.9999
%   Adjusted R-square: 0.9998
%   RMSE: 0.08028
% 

zpos = (p1.*x.^3 + p2.*x.^2 + p3.*x + p4)./(x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);

           
           
% % % %            
% % % %           General model Rat43:
% % % %      f(x) = (p1*x^4 + p2*x^3 + p3*x^2 + p4*x + p5) /
% % % %                (x^3 + q1*x^2 + q2*x + q3)
% % % % Coefficients (with 95% confidence bounds):
% % %        p1 =       6.411;% (4.357, 8.465)
% % %        p2 =       5.304 ;% (0.2777, 10.33)
% % %        p3 =      -5.841  ;%(-7.808, -3.875)
% % %        p4 =       5.783  ;%(4.482, 7.084)
% % %        p5 =      -1.085  ;%(-1.347, -0.8224)
% % %        q1 =      0.7816  ;%(0.366, 1.197)
% % %        q2 =     -0.5141  ;%(-0.6364, -0.3919)
% % %        q3 =      0.2811  ;%(0.2142, 0.348)
% % % 
% % % % % % Goodness of fit:
% % % % % %   SSE: 0.2666
% % % % % %   R-square: 0.9999
% % % % % %   Adjusted R-square: 0.9999
% % % % % %   RMSE: 0.07376 
% % % % % %            
% % %         zpos=(p1.*x.^4 + p2.*x.^3 + p3.*x.^2 + p4.*x + p5)./(x.^3 + q1.*x.^2 + q2.*x + q3);   
           
end





if isequal(Cal_ID,2.232)
%Alt Cal 2PD

% General model Rat54:
%      f(x) = 
%                (p1*x^5 + p2*x^4 + p3*x^3 + p4*x^2 + p5*x + p6) /
%                (x^4 + q1*x^3 + q2*x^2 + q3*x + q4)
% Coefficients (with 95% confidence bounds):
       p1 =        1659 ;% (-1.292e+09, 1.292e+09)
       p2 =      -149.9 ;% (-1.103e+08, 1.103e+08)
       p3 =        1191 ;% (-9.293e+08, 9.293e+08)
       p4 =       -1263 ;% (-9.892e+08, 9.892e+08)
       p5 =       952.9;%  (-7.466e+08, 7.466e+08)
       p6 =      -217.8 ;% (-1.706e+08, 1.706e+08)
       q1 =       575.1 ;% (-4.512e+08, 4.512e+08)
       q2 =        -472 ;% (-3.701e+08, 3.701e+08)
       q3 =         212;%  (-1.661e+08, 1.661e+08)
       q4 =      -26.19;% (-2.052e+07, 2.052e+07)

% Goodness of fit:
%   SSE: 0.4262
%   R-square: 0.9997
%   Adjusted R-square: 0.9997
%   RMSE: 0.09842


zpos=(p1.*x.^5 + p2.*x.^4 + p3.*x.^3 + p4.*x.^2 + p5.*x + p6) ./ ...
               (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);

end


if isequal(Cal_ID,2.231)
%TEST PD RAT oNLY

% inear model Poly8:
%      f(x) = p1*x^8 + p2*x^7 + p3*x^6 + p4*x^5 + 
%                     p5*x^4 + p6*x^3 + p7*x^2 + p8*x + p9
% Coefficients (with 95% confidence bounds):
       p1 =        1206  ;%(399.9, 2013)
       p2 =       -5675  ;%(-9002, -2347)
       p3 =   1.109e+04  ;%(5458, 1.671e+04)
       p4 =  -1.164e+04  ;%(-1.666e+04, -6608)
       p5 =        7099  ;%(4550, 9649)
       p6 =       -2554  ;%(-3288, -1820)
       p7 =       533.4  ;%(420.1, 646.8)
       p8 =      -78.93;%  (-87.12, -70.74)
       p9 =       7.392;%  (7.198, 7.586)
% 
% Goodness of fit:
%   SSE: 0.1859
%   R-square: 0.9999
%   Adjusted R-square: 0.9999
%   RMSE: 0.06427



zpos =   p1.*x.^8 + p2.*x.^7 + p3.*x.^6 + p4.*x.^5 + ... 
                    p5.*x.^4 + p6.*x.^3 + p7.*x.^2 + p8.*x + p9;
end

if isequal(Cal_ID,2.23)
% General model:
%      f(x) = a.*exp(b.*x.^-1) + c.*exp(d.*x.^-2)+ e.*exp(f.*x) + e
% Coefficients (with 95% confidence bounds):
       a =     -0.4151  ;%(-0.5378, -0.2925)
       b =      0.8316  ;%(0.7659, 0.8974)
       c =  -7.726e-08 ;% (-6.478e-07, 4.933e-07)
       d =      0.8655  ;%(0.4946, 1.236)
       e =       2.458;%  (2.165, 2.751)
       f =      0.8196;%  (0.6339, 1.005)
% 
% Goodness of fit:
%   SSE: 0.302
%   R-square: 0.9998
%   Adjusted R-square: 0.9998
%   RMSE: 0.07932

zpos =    a.*exp(b.*x.^-1) + c.*exp(d.*x.^-2)+ e.*exp(f.*x) + e;

end

if isequal(Cal_ID,3.23)
    %500 nm TS RED
%Labeled as Cal 3.2t
%      General model Rat34:

%      Coefficients (with 95% confidence bounds):
       p1 =   5.368e+04;%  (-5.396e+08, 5.397e+08)
       p2 =   2.468e+04  ;%(-2.48e+08, 2.48e+08)
       p3 =   6.379e+04  ;%(-6.415e+08, 6.416e+08)
       p4 =       -5028  ;%(-5.057e+07, 5.056e+07)
       q1 =        3785  ;%(-3.805e+07, 3.806e+07)
       q2 =        8368  ;%(-8.413e+07, 8.415e+07)
       q3 =        3157  ;%(-3.173e+07, 3.174e+07)
       q4 =        4834  ;%(-4.861e+07, 4.862e+07)
zpos = (p1.*x.^3 + p2.*x.^2 + p3.*x + p4)./(x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);

end

if isequal(Cal_ID,3.22)
    
% Linear model Poly8:

% Coefficients (with 95% confidence bounds):
       p1 =      -20.74;%  (-38.2, -3.28)
       p2 =      -4.805 ;% (-20.2, 10.59)
       p3 =       28.86  ;%(8.934, 48.78)
       p4 =       11.23  ;%(-3.705, 26.17)
       p5 =      -12.02  ;%(-20.26, -3.773)
       p6 =      -10.36  ;%(-14.68, -6.044)
       p7 =      -0.621  ;%(-1.936, 0.694)
       p8 =       13.22  ;%(12.85, 13.59)
       p9 =      -2.201  ;%(-2.256, -2.145)

% Goodness of fit:
%   SSE: 0.2171
%   R-square: 0.9998
%   Adjusted R-square: 0.9998
%   RMSE: 0.07661
     zpos = p1.*x.^8 + p2.*x.^7 + p3.*x.^6 + p4.*x.^5 + ...
                    p5.*x.^4 + p6.*x.^3 + p7.*x.^2 + p8.*x + p9;

end

if isequal(Cal_ID,2.2)

       a =       -0.5145 ;
       b =      0.1217  ;
       c =   -1.2714;
       d =      0.4246  ;
       e =   2.3158   ;
       f =    0.6606 ;
       
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end



if isequal(Cal_ID,3.2)
    
%   General model Rat34:

% Coefficients (with 95% confidence bounds):
       p1 =       17.51;%  (13.62, 21.4)
       p2 =       5.222;%  (1.53, 8.914)
       p3 =       1.739;%  (0.6187, 2.859)
       p4 =      -1.024;%  (-1.358, -0.6907)
       q1 =       1.473;%  (1.375, 1.57)
       q2 =       2.208;%  (1.861, 2.555)
       q3 =      0.8823;%  (0.5962, 1.168)
       q4 =      0.3552;%  (0.2381, 0.4722)


% Goodness of fit:
%   SSE: 0.1682
%   R-square: 0.9999
%   Adjusted R-square: 0.9998
%   RMSE: 0.05385


zpos = (p1.*x.^3 + p2.*x.^2 + p3.*x + p4)./(x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);

end



if isequal(Cal_ID,3.1)
    
%   General model Rat34:

% Coefficients (with 95% confidence bounds):
       p1 =       138.7;%
       p2 =      -45.57  ;%(-123.1, 32.01)
       p3 =       51.89  ;%(-31.43, 135.2)
       p4 =      -3.979  ;%(-10.33, 2.375)
       q1 =       3.749  ;%(-1.107, 8.605)
       q2 =       15.33  ;%(-7.409, 38.06)
       q3 =       -2.69  ;%(-7.286, 1.906)
       q4 =       2.375  ;%(-1.431, 6.18)

% Goodness of fit:
%   SSE: 0.05982
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 0.0336

zpos = (p1.*x.^3 + p2.*x.^2 + p3.*x + p4)./(x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);

end
    

if isequal(Cal_ID,'Test3PD3GDD0')


  p1 =      0.2347  ;
       p2 =     -0.9877  ;
       p3 =      0.3752  ;
       p4 =       2.983  ;
       p5 =      -2.036 ;
       p6 =      -4.715 ;
       p7 =       2.479  ;
       p8 =       3.985 ;
       p9 =       3.884  ;
       p10 =      -3.684  ;




   zpos = p1.*x.^9 + p2.*x.^8 + p3.*x.^7 + p4.*x.^6 + p5.*x.^5 + p6.*x.^4 + p7.*x.^3 + p8.*x.^2 + p9.*x + p10;


end

if isequal(Cal_ID,'Test3PD3GDD12850')

% Linear model Poly9:

% Coefficients (with 95% confidence bounds):
       p1 =      0.1759  ;
       p2 =     -0.7052  ;
       p3 =     0.06057;
       p4 =       2.537  ;
       p5 =      -1.042 ;
       p6 =      -4.629  ;
       p7 =       1.461 ;
       p8 =       4.146  ;
       p9 =       4.181  ;
       p10 =      -3.506 ;

% Goodness of fit:
%   SSE: 0.1621
%   R-square: 0.9999
%   Adjusted R-square: 0.9999
%   RMSE: 0.03531
  
     zpos = p1.*x.^9 + p2.*x.^8 + p3.*x.^7 + p4.*x.^6 + p5.*x.^5 + p6.*x.^4 + p7.*x.^3 + p8.*x.^2 + p9.*x + p10;

end


if isequal(Cal_ID,'Test3PD2')
 %GDD 12850
%  Coefficients (with 95% confidence bounds):
       p1 =       20.04  ;
       p2 =        21.4  ;
       p3 =       13.19  ;
       p4 =       42.41  ;
       p5 =      -31.14  ;
       q1 =       9.115  ;
       q2 =       5.426  ;
       q3 =      -2.267  ;
       q4 =        9.46  ;
 
% Goodness of fit:
%   SSE: 0.0996
%   R-square: 0.9999
%   Adjusted R-square: 0.9999
%   RMSE: 0.02757

  zpos = (p1.*x.^4 + p2.*x.^3 + p3.*x.^2 + p4.*x + p5) ./ ...
               (x.^4 + q1.*x.^3 + q2.*x.^2 + q3.*x + q4);
end

if isequal(Cal_ID,'Test3PD1')
    
%     x=PDdiff;
% General model Fourier3:
%      f(x) =  a0 + a1*cos(x*w) + b1*sin(x*w) + 
%                a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w)
% Coefficients (with 95% confidence bounds):
%        a0 =      -1.588  (-1.712, -1.465)
%        a1 =      -1.897  (-2.071, -1.723)
%        b1 =       6.388  (6.151, 6.626)
%        a2 =       1.048  (0.9606, 1.136)
%        b2 =      -1.651  (-1.774, -1.527)
%        a3 =     -0.9762  (-1.037, -0.9157)
%        b3 =     -0.1013  (-0.1452, -0.05731)
%        w =       1.151  (1.123, 1.18)
% 
% Goodness of fit:
%   SSE: 0.09964
%   R-square: 0.9999
%   Adjusted R-square: 0.9999
%   RMSE: 0.0279

       a0 =      -1.588 ;%
       a1 =      -1.897  ;%(-2.071, -1.723)
       b1 =       6.388  ;%(6.151, 6.626)
       a2 =       1.048  ;%(0.9606, 1.136)
       b2 =      -1.651  ;%(-1.774, -1.527)
       a3 =     -0.9762  ;%(-1.037, -0.9157)
       b3 =     -0.1013  ;%(-0.1452, -0.05731)
       w =       1.151  ;%(1.123, 1.18)
zpos =  a0 + a1.*cos(x.*w) + b1.*sin(x.*w) + a2.*cos(2.*x.*w) + b2.*sin(2.*x.*w) + a3.*cos(3.*x.*w) + b3.*sin(3.*x.*w);

end


if isequal(Cal_ID,'DET10A')
    
%     if isequal(Cal_ID,'DET10A'
   
           a =       5.107 ;
       b =      -1.601  ;
       c =    -0.02504  ;
       d =       5.617  ;
       e =      0.2188  ;
       f =      0.6187  ;
    
     zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
end

if isequal(Cal_ID,'DET100')
   
       a =       33.46;
       b =     -0.4431;
       c =  -1.295e-09;
       d =       19.75;
       e =      -28.85;
       f =      -26.53;


    zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
  

end

    
if isequal(Cal_ID,55)
   
    
% fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =       2.855  (-5.159, 10.87)
%        b =      -1.407  (-5.302, 2.488)
%        c =    -0.07561  (-0.2247, 0.07343)
%        d =       4.165  (2.881, 5.449)
%        e =      0.7838  (-2.987, 4.554)
%        f =      0.3043  (-0.5204, 1.129)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.7198
%        rsquare: 0.9992
%            dfe: 45
%     adjrsquare: 0.9991
%           rmse: 0.1265
% 
% 
% CAL_coeffs =

   a= 2.8554 ; 
   b= -1.4067 ;
   c= -0.0756  ;
   d= 4.1653;
   e=0.7838   ;
   f=0.3043;

    zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
    
end

if isequal(Cal_ID,54)

% fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =       5.495  (5.213, 5.777)
%        b =      -1.413  (-1.613, -1.213)
%        c =    -0.04122  (-0.05261, -0.02983)
%        d =       4.523  (4.308, 4.737)
%        e =   1.824e-05  (-0.0004585, 0.000495)
%        f =       2.652  (-4.722, 10.03)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.4640
%        rsquare: 0.9995
%            dfe: 49
%     adjrsquare: 0.9995
%           rmse: 0.0973
% 
% 
% CAL_coeffs =
% 
%     5.4951   -1.4130   -0.0412    4.5227    0.0000    2.6516

       a =       5.495 ;
       b =      -1.413 ;
       c =    -0.04122 ;
       d =       4.523 ;
       e =   1.824e-05 ;
       f =       2.652 ;
       
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end


if isequal(Cal_ID,53)

% fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -3.532  (-3.986, -3.077)
%        b =     0.06126  (0.05791, 0.06462)
%        c =       -7.71  (-20.9, 5.477)
%        d =      -3.181  (-5.139, -1.223)
%        e =       1.596  (1.178, 2.014)
%        f =      0.7468  (0.2452, 1.248)

 a =      -3.532;
       b =     0.06126 ;
       c =       -7.71;
       d =      -3.181 ;
       e =       1.596 ;
       f =      0.7468 ;
       
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end


if isequal(Cal_ID,'51.HOT')

%     
%     fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -3.037  (-3.908, -2.166)
%        b =     0.05635  (0.04956, 0.06313)
%        c =      -150.8  (-223, -78.59)
%        d =      -2.762  (-2.957, -2.566)
%        e =       4.463  (3.712, 5.214)
%        f =       1.491  (1.15, 1.831)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.5572
%        rsquare: 0.9994
%            dfe: 23
%     adjrsquare: 0.9993
%           rmse: 0.1556
% 
% 
% CAL_coeffs =

   a= -3.0371;
   b=0.0563;
   c=-150.8088;
   d=-2.7615 ;
   e=4.4630; 
   f=1.4906;
   
      
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;


   
end
    
if isequal(Cal_ID,50)

a=   -3.0340 ;
b= 0.0650 ;
c= -347.4856;
d= -8.1199 ;
e= 3.4526;
f= 0.4884;
   
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;


% fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -3.034  (-3.271, -2.797)
%        b =       0.065  (0.06297, 0.06704)
%        c =      -347.5  (-5471, 4776)
%        d =       -8.12  (-25.47, 9.229)
%        e =       3.453  (3.232, 3.673)
%        f =      0.4884  (0.3862, 0.5907)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.3609
%        rsquare: 0.9998
%            dfe: 45
%     adjrsquare: 0.9998
%           rmse: 0.0896
% 
% 
% CAL_coeffs =
% 
%    -3.0340    0.0650 -347.4856   -8.1199    3.4526    0.4884
end



if isequal(Cal_ID,47)
            

       a =      -2.828;
       b =     0.06364;
       c =      -12.72;
       d =      -2.893;
       e =       3.207;
       f =      0.5317;
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.0420
%        rsquare: 1.0000
%            dfe: 45
%     adjrsquare: 1.0000
%           rmse: 0.0305
% 
% 
% CAL_coeffs =
% 
%    -2.8280    0.0636  -12.7157   -2.8928    3.2071    0.5317
% 

    
end
    
    
if isequal(Cal_ID,45)

    
     a =      -3.843;
       b =     0.04097;  
       c =      -28.78 ;
       d =      -2.871  ;
       e =       3.144;
       f =    0.8645 ;

         
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;


    %         General model:
%      fitresultCAL(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -3.843  (-4.101, -3.584)
%        b =     0.04097  (0.03966, 0.04228)
%        c =      -28.78  (-33.86, -23.71)
%        d =      -2.871  (-3.077, -2.665)
%        e =       3.144  (2.942, 3.346)
%        f =      0.8645  (0.7467, 0.9823)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.0302
%        rsquare: 1.0000
%            dfe: 45
%     adjrsquare: 1.0000
%           rmse: 0.0259 
end

if isequal(Cal_ID,44 )
    
           a =      -5.839  ;
       b =     0.03415  ;
       c =      -11.69 ;
        d =      -2.342 ;
        e =        4.92  ;
       f =      0.5535  ;

     
zpos =    a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
    
%     General model:
%      f(x) = a*exp(b*x.^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
% Coefficients (with 95% confidence bounds):
%        a =      -5.839  (-6.304, -5.373)
%        b =     0.03415  (0.03281, 0.03548)
%        c =      -11.69  (-16.46, -6.922)
%        d =      -2.342  (-2.664, -2.02)
%        e =        4.92  (4.557, 5.284)
%        f =      0.5535  (0.4135, 0.6934)
% 
% Goodness of fit:
%   SSE: 0.04783
%   R-square: 1
%   Adjusted R-square: 1
%   RMSE: 0.0326

end

if isequal(Cal_ID,43)
          a =      -7.012;
        b =     0.03087;
        c =      -6.272;
        d =      -2.912;
        e =       5.717;
        f =      0.3574;
     
zpos =a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
%          fitresultCAL = 
% 
%      General model:
%      fitresultCAL(x) = a*exp(b*x^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -7.012  (-7.517, -6.507)
%        b =     0.03087  (0.02972, 0.03203)
%        c =      -6.272  (-10.46, -2.082)
%        d =      -2.912  (-4.502, -1.322)
%        e =       5.717  (5.353, 6.082)
%        f =      0.3574  (0.2607, 0.4541)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.0387
%        rsquare: 1.0000
%            dfe: 45
%     adjrsquare: 1.0000
%           rmse: 0.0293
%
          
end



if isequal(Cal_ID,40)

         a =      -47.36;  
        b =     0.04017;  
        c =       5.764; 
        d =      0.1241; 
        e =       21.44; 
        f =     0.03812; 
    
    
zpos = a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
   
     
%      General model:
%      fitresultCAL(x) = a*exp(b*x^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
%      Coefficients (with 95% confidence bounds):
%        a =      -47.36  (-436.6, 341.9)
%        b =     0.04017  (-0.08533, 0.1657)
%        c =       5.764  (-825.4, 836.9)
%        d =      0.1241  (-18.75, 18.99)
%        e =       21.44  (-584.8, 627.7)
%        f =     0.03812  (-0.9255, 1.002)
% 
% gofCAL = 
% 
%   struct with fields:
% 
%            sse: 0.3714
%        rsquare: 0.9996
%            dfe: 45
%     adjrsquare: 0.9996
%           rmse: 0.0908
% 
% 
% CAL_coeffs =
% 
%   -47.3585    0.0402    5.7645    0.1241   21.4405    0.0381
%     
%     
end



if isequal(Cal_ID,39)

%     General model:
%      f(x) = a*exp(b*x^-2) + c*exp(d*x^-1)+ e*exp(f*x) + e
% Coefficients (with 95% confidence bounds):
%        a =       5.436  (0.8023, 10.07)
%        b =      -1.127  (-1.339, -0.9139)
%        c =      -22.08  (-42.03, -2.127)
%        d =      0.2752  (0.1558, 0.3946)
%        e =       24.17  (7.617, 40.73)
%        f =      -1.477  (-1.708, -1.246)
% 
% Goodness of fit:
%   SSE: 0.3329
%   R-square: 0.9997
%   Adjusted R-square: 0.9996
%   RMSE: 0.08601

a =       5.436;
b =      -1.127;
c =      -22.08;
d =      0.2752;
e =       24.17;
f =      -1.477;

 
zpos = a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end


if isequal(Cal_ID,'36.bad')
    

       a =      -16.15 ;
       b =     0.07475 ;
       c =       1.507  ;
       d =       0.311;
       e =       8.696 ;
       f =     0.07031 ;
 
zpos = a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
 
end
 
if isequal(Cal_ID,35.845)

       a =       1.284;
       b =   -0.001953;
       c =       68.87;
       d =    -0.02985;
       e =      -66.62;
       f =      -11.04;
          
    zpos= a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end
    
if isequal(Cal_ID,34.805)

    a =      -31.17;
       b =     0.04113;
       c =       4.718;
       d =       -2.44;
       e =       17.37;
       f =   -0.007921;
        
zpos=a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;

end


if isequal(Cal_ID,27)
    
    a=-46.6;
    b=0.03253;
    c=1.734;
    d=-2.808;
    e=24.41;
    f=0.0184;
    
    zpos=[a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e];
    
end


if isequal(Cal_ID,25)
    
    a =       3.053;
    b =     -0.8022 ;
    c =     -0.3044 ;
    d =       1.653;
    e =        1.04;
    f =      0.2495;
    
    zpos=a.*exp(b.*x.^-2) + c.*exp(d.*x.^-1)+ e.*exp(f.*x) + e;
end


if isequal(Cal_ID,24)
    
    zpos=-0.7026.*exp(1.305.*PDRatioEXP.^-1)+4.702.*exp(-1.758.*PDRatioEXP.^-1)+2.339.*exp(-0.04358.*PDRatioEXP+2.339); %Custom Exponential Fit Cal 24 Cut
    
end


if isequal(Cal_ID,22)
    
    zpos=-1.912.*exp(0.1281.*PDRatioEXP.^-2)+5.389.*exp(-0.5043.*PDRatioEXP.^-1)+4.003e-12.*exp(10.6.*PDRatioEXP+4.003e-12); %Custom Exponential Fit Cal 22
    
end


if isequal(Cal_ID,21)
    
    a =      -2.837;
    b =       1.545;
    c =    8.09e+05;
    d =     0.05545;
    e =   -8.09e+05;
    
    zpos=a.*exp(b.*x.^-2) + c.*exp(d.*x) + e.*exp(d.*x);
    
end


if isequal(Cal_ID,20)
    
    a =       2.177;
    b =      0.1364;
    c =      -64.75;
    d =       -2.69;
    
    zpos=a.*exp(b.*x) + c.*exp(d.*x);
end

end
