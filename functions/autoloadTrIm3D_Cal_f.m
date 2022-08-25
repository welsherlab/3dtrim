function [pixelcenter,linecenter,zoffs]=autoloadTrIm3D_Cal_f(vidfname)
 zoffs= 0;
 zoomfactor=1.5;
 if vidfname(1)~=2 %If a vidfile path is provided in function input, check for zoomfactor
    zoomfactor=getzoom(vidfname);
 end
% vidfname to datenum to Cal_ID
Cal_ID = [];
% datenum = str2double(vidfname(1:6));
% % % % datestart=find(vidfname=='2',1);

% TWO possibilities by code: either a filename or a path name


[~,fname,~]=fileparts(vidfname);
if isempty(fname) %vidfname = vidfname
datenum=str2double(vidfname(1:6));
else
    datenum=str2double(fname(1:6));
end
    
% % datestart=strfind(vidfname,'VID');
% % 
% % datenum = str2double(vidfname(datestart-7:datestart-2));
%%TEMPLATE FOR ADDING NEW CALS...
%%if datenum >=newcaldate
%%Cal_ID = 'newdate';
%%elseif lastcaldate <= datenum && datenum < newcaldate
%%delete previous cal if >= statement replace with above


%UNABLE TO LOCATE CALS....
%09/17/20
if datenum >=220322
    Cal_ID = '22MAR22';
elseif datenum >=210603 && datenum <220322
    Cal_ID = '03JUN21';
elseif 210518 <= datenum && datenum <210603
    Cal_ID = '18MAY21';   
elseif 210401 <= datenum && datenum <210518
    Cal_ID = '01APR21';   
elseif 210325 <= datenum && datenum <210401
    Cal_ID = '25MAR21';    
elseif 210318 <= datenum && datenum <210325
    Cal_ID = '21MAR21';
elseif 210208 <= datenum && datenum <210318
    Cal_ID = '08FEB21';
elseif 210204 <= datenum && datenum <210208
    Cal_ID = '05FEB21';
elseif 210113 <= datenum && datenum <210204
    Cal_ID = '13JAN21';
elseif 201212 <= datenum && datenum <210113
    Cal_ID = '12DEC20';
elseif 201002 <= datenum && datenum < 201212
    Cal_ID = '02OCT20';
elseif 200917 <= datenum && datenum < 201002
    Cal_ID = '17SEP20';
elseif 200802 <= datenum && datenum < 200917
    Cal_ID = '02AUG20';
elseif 200730 <= datenum && datenum < 200802
    Cal_ID = '30JUL20';
elseif 200624 <= datenum && datenum < 200730
    Cal_ID = '24JUN20';
elseif 200130 <= datenum && datenum < 200624
    Cal_ID = '30JAN20';
elseif 200120 <= datenum && datenum < 200130
    Cal_ID = '20JAN20';
elseif 191008 <= datenum && datenum < 200120
    Cal_ID = '08OCT19';
end
% original code
% if Cal_ID=='17JAN21'
% if zoomfactor==1
%     pixelcenter = 249;
%     linecenter = 241;
% end
% if zoomfactor==1.5
%     pixelcenter =243;
%     linecenter = 235;
% end
% end

if Cal_ID=='22MAR22'
    zoffs=-0.1413;
if zoomfactor==1.5
    pixelcenter = 297.1332; 
    linecenter = 259.8023; 
end
if zoomfactor==1
    pixelcenter = 284.3912; 
    linecenter = 258.4612; 
end
end

if Cal_ID=='03JUN21'
if zoomfactor==1.5
    pixelcenter = 254.0883; 
    linecenter = 222.1411; 
    zoffs=-0.1428;
end
end

if Cal_ID=='18MAY21'
    
if zoomfactor==2
    pixelcenter = 283.0705;
    linecenter = 302.8122;
    zoffs=-0.1428;
end
if zoomfactor==1.5
        pixelcenter = 279.3229;
    linecenter = 290.5674;
    zoffs=-0.1428;
end

if zoomfactor==1
        pixelcenter = 272.4978;
    linecenter =278.4437;
    zoffs=-0.1428;
end

end

if Cal_ID=='01APR21'
if zoomfactor==1.5
    pixelcenter = 246.6042; % TW 247.2762;% ;
    linecenter = 232.2362; % TW 232.1798; %;
    zoffs=-0.1428;
%     meanalllncenters =
%   232.1798
% meanallzcenters =
%    -0.1428
% meanallpxcenters =
%   247.2762
end
end

if Cal_ID=='25MAR21'
if zoomfactor==1.5
    pixelcenter = 244.0895;
    linecenter = 231.2864;
    
end
end


if Cal_ID=='21MAR21'
if zoomfactor==1.5
    pixelcenter = 243.4349;
    linecenter = 232.0962;
  
end

if zoomfactor==1
    pixelcenter = 249.2619;
    linecenter = 239.4664;
    
end

end

if Cal_ID=='08FEB21'
if zoomfactor==1
    pixelcenter = 250.8391;
    linecenter = 240.0235;
    
% %         pixelcenter = 251;
% %     linecenter = 240;
end
if zoomfactor==1.5
        pixelcenter = 245.8016;
    linecenter = 232.9547;
%     pixelcenter = 246;
%     linecenter = 233;
end
if zoomfactor==2
        pixelcenter = 239.7645;
    linecenter = 225.9677;
%     pixelcenter = 240;
%     linecenter = 226;
end
end


if Cal_ID=='05FEB21'
   pixelcenter =   249.3736;
linecenter =   240.4553 ;
end

if Cal_ID=='13JAN21'
if zoomfactor==1
    pixelcenter = 249;
    linecenter = 241;
end
if zoomfactor==1.5
    pixelcenter =243;
    linecenter = 235;
end
if zoomfactor==2
    pixelcenter = 238;
    linecenter = 228;
end
end

if Cal_ID=='12DEC20'
       pixelcenter =    250.7758;
linecenter =   240.4020 ;
%    pixelcenter =   251;
% linecenter =   240 ;
end

if Cal_ID=='02OCT20' %CLOSED LOOP
pixelcenter = 263;
linecenter =  252;
 %This value is old/out of date. Need to re-eval.

end

% if Cal_ID=='02OCT20'   OPEN LOOP
% pixelcenter = 264;
% linecenter =  252;
%  %This value is old/out of date. Need to re-eval.
% 
% end
% 

if Cal_ID=='17SEP20'
pixelcenter = 260;
linecenter =  247;
 %This value is old/out of date. Need to re-eval.

end

if Cal_ID=='02AUG20'
pixelcenter = 271;
linecenter =  282;
 %This value is old/out of date. Need to re-eval.

end

if Cal_ID=='30JUL20'
pixelcenter = 272;
linecenter =  282;
 %This value is old/out of date. Need to re-eval.

end

if Cal_ID=='24JUN20'
pixelcenter = 258;
linecenter =  369;
zoffs= 0.394829747607422; %This value is old/out of date. Need to re-eval.

end

if Cal_ID=='30JAN20'
pixelcenter = 272;
linecenter =  220;
zoffs= 0.394829747607422;
% zoffs = -0.506406528585398; %  -1.5620;

end

if Cal_ID=='20JAN20' %190301 VID0083 TR363 Trim Cal 0.5TS
pixelcenter=268
linecenter=282
zoffs=-0.49

end

if Cal_ID=='08OCT19' %190301 VID0083 TR363 Trim Cal 0.5TS
pixelcenter=282
linecenter=269
zoffs=-0.26

end


if Cal_ID==3.23 %190301 VID0083 TR363 Trim Cal 0.5TS
pixelcenter=269
linecenter=208
zoffs=-0.17
%%%FOR DATA ACQUIRED AFTER JUN19
%%% FOR DATA ACQUIRED BETWEEN MAR19 and JUN19    
% % %    pixelcenter=269;
% % %    linecenter=208;
end