%This finction computes change-point analysis on 3D-TrIm trajectories to
%define statistically significant sub-diffusive regions. The false-positive
%rate can be altered using the gamma and delta variables - the pre-set values
%have a calculated false-positive rate of 10%.


function [CPData,All_D,All_SegDur,All_Alpha,All_MEANSegINT,AllDistanceData]=ProcessChangePoint_final(maindir)

cd(maindir)
set(0,'DefaultFigureWindowStyle','normal');
%% USER INPUTS
CPcutoff=610; %upper limit of trajectory length analyze in sec

gamma=0.90; % 10% false-positive rate
delta=.003; % decimate data 3msec, decimated data has a false positive rate of closer to 10% compared to 1 msec
%% ONLY SELECTS CORRECT MAT file
matlist=dir('**/*.mat');
checklist=[];
for b=1:length(matlist)
   strlist=strfind(matlist(b).name,'Processed Data.mat') ;
  if length(strlist)~=0
     checklist(b)=1 ;
  else
     checklist(b)=0;
  end
end
matlist=matlist(logical(checklist));

CPData=[];

%% COMPUTES IMPORTANT VARIABLES FROM TRACKING DATA AND WRITES MSD FIG

for f=1:length(matlist)
    
    matpname=[matlist(f).folder '\'];
        matfname=matlist(f).name;

        if length([matpname matfname])>260
           shortpname=fsoGetShortPath([matpname]);
           load([shortpname '\' matfname])
            else
        load([matpname matfname])
        end
        
        %% MAKE SUBFOLDER FOR FILE STORAGE
        
          matpname2 = fullfile(matpname,'TopHatFiltChangePointFigs');
          mkdir(matpname2);
          matpname3 = fullfile(matpname2,matfname(1:end-20));
          
                  if length(matpname3)>260
                      fsoGetShortPath(matpname2)
           matpname3=[fsoGetShortPath(matpname2) '\' matfname(1:end-20)];
                  end
%% Initilize variables 

       PXRd=PXRd'; % xcoords
       PYRd=PYRd'; % ycoords
       PZRd=PZRd'; % zcoords

            x=downsample(PXRd,300);
            y=downsample(PYRd,300);
            z=downsample(PZRd,300);
            intCP=downsample(Int,300);
        
        %% SKIP TRAJS LONGER THAN CUTOFF
        
        if length(PXRdFilt)/1000>CPcutoff
        
        %%add skipped traj in data structure so can be revisited if
        %%required
        CPData(f).label = matfname;
        CPData(f).D  =  'NA';
        CPData(f).SegDur  =  'NA';
        CPData(f).Alpha  =  'NA';
        CPData(f).MEANSegINT  =  'NA';
        CPData(f).CPanalysis  =  'NOT PROCESSED';
        else
            disp('Track Data Decimated')
            
         %% Change-Point ANALYSIS SECTION BELOW

changePointFound=1;
traj(1).x=x;
traj(1).y=y;
traj(1).z=z;
traj(1).SegINT=intCP'; 
traj(1).minIndex=1;
traj(1).active=1;
index=2;
prevMinIndex=1;
while changePointFound
    changePointFound=0;
    for i=1:length(traj)
        if traj(i).active
            prevMinIndex=traj(i).minIndex;
            [llrOut, kOut]=changePointPar_final(traj(i).x,traj(i).y,traj(i).z); %doesnt draw figure, saves time
            if llrOut>cfint(length(traj(i).x),gamma)
                changePointFound=1;
                cp(1)=kOut;
                traj(i).active=0;
                traj(index).x=traj(i).x(1:kOut);
                traj(index).y=traj(i).y(1:kOut);
                traj(index).z=traj(i).z(1:kOut);
                traj(index).SegINT=traj(i).SegINT(1:kOut); 
                traj(index).active=1;
                traj(index).minIndex=prevMinIndex;
                traj(index).D=var(diff(traj(i).x(1:kOut)))/2/delta...
                    +var(diff(traj(i).y(1:kOut)))/2/delta...
                    +var(diff(traj(i).z(1:kOut)))/2/delta;
                index=index+1;
                traj(index).x=traj(i).x(kOut+1:end);
                traj(index).y=traj(i).y(kOut+1:end);
                traj(index).z=traj(i).z(kOut+1:end);
                traj(index).SegINT=traj(i).SegINT(kOut+1:end);
                traj(index).active=1;
                traj(index).minIndex=kOut+prevMinIndex-1;
                traj(index).D=var(diff(traj(i).x(kOut+1:end)))/2/delta...
                    +var(diff(traj(i).y(kOut+1:end)))/2/delta...
                    +var(diff(traj(i).z(kOut+1:end)))/2/delta;
                index=index+1;
            elseif length(traj)==1
                traj(i).D=var(diff(traj(i).x(kOut+1:end)))/2/delta...
                    +var(diff(traj(i).y(kOut+1:end)))/2/delta...
                    +var(diff(traj(i).z(kOut+1:end)))/2/delta;
                changePointFound=0;
            end
        end
    end
end

for i=1:length(traj)
    if traj(i).active
        if length(traj(i).x)<=30
            D=var(diff(traj(i).x))/2/delta+var(diff(traj(i).y))/2/delta+var(diff(traj(i).z))/2/delta;
            traj(i).SegDur=length(traj(i).x)*3; %decimated to 3msec
            %Assume short trajs have alpha=1
            traj(i).Alpha=1;
            traj(i).MEANSegINT=mean(traj(i).SegINT);
        else
           
            [~,~,D]=msdcalc_CP(traj(i).x,traj(i).y,traj(i).z,300);
            traj(i).D=D;
            traj(i).SegDur=length(traj(i).x)*3; %decimated to 3msec
            [alpha]=msdcalcExp_Alphaonly(traj(i).x,traj(i).y,traj(i).z,300);
            traj(i).Alpha=alpha;
            traj(i).MEANSegINT=mean(traj(i).SegINT);
           
        end
    end
end

hCP=figure;
plotCP_final(traj);
axis image;
title([matfname(1:(end-4)) 'Trajectory CP'],'Interpreter', 'none');
figCPname=[matpname3 ' ChangePointTraj' '.fig'];
saveas(hCP,figCPname,'fig');
pngCPName=[matpname3 ' ChangePointTraj' '.png'];
print(pngCPName,'-dpng');

    %% SORT SEGMENTS BY TIME
        if size(traj,2) ==1 %No ChangePoints detected
             trajStruct=traj;
             
        else
        trajTable = struct2table(traj(:,2:end)); %first row is the complete traj, ignore
        rows = (trajTable.active==1); %find active segments
        activetrajTable=trajTable(rows,:);
        sortedactivetrajTable = sortrows(activetrajTable, 'minIndex'); % sort the table earliest segment to latest
        trajStruct=table2struct(sortedactivetrajTable);
        end
        index=1;
for i=1:length(trajStruct)
 
        data(index,1)=mean(trajStruct(i).z);
        data(index,2)=trajStruct(i).D;
        data(index,3)=trajStruct(i).SegDur;
        data(index,4)=trajStruct(i).Alpha;
        data(index,5)=trajStruct(i).MEANSegINT;
        index=index+1;
  
end
%%add data from this trajectory into data structure
CPData(f).label = matfname;
CPData(f).D  =  data(:,2)';
CPData(f).SegDur  =  data(:,3)';
CPData(f).Alpha  =  data(:,4)';
CPData(f).MEANSegINT  =  data(:,5)';
CPData(f).CPanalysis  =  'COMPLETE';

%% Add CP traj to isosurface render of cells

[XX,YY,ZZ]=meshgrid(excrop(1:(length(excrop))),eycrop(1:(length(eycrop))),ezcrop(1:(length(ezcrop))));
          
          sa = strel('sphere',5); %tophat SE
%          se = strel('sphere',5); %closing
hiR=0.9998;
gammaR=0.7;

%pre-allocate matrix to put individual volumes in
interp_zstackR3=zeros(size(zstackR),'uint16'); %scale global volume after
zstack_paintdR=zeros(size(zstackR),'uint16'); %scale each volume
THVol=zeros(size(zstackR),'uint16'); %tophat each volume

%% SCALES INDIVIDUAL VOL and perfoms TH transform
for volnum=1:size(zstackR,4)
    if localextremafill(volnum,5)~=0
       
        
        localsizex=localextremafill(volnum,1):localextremafill(volnum,2);
        localsizey=localextremafill(volnum,3):localextremafill(volnum,4);
        localsizez=localextremafill(volnum,5):localextremafill(volnum,6);
        
        
        tempvol=double(zstackR(localsizey,localsizex,localsizez,volnum));
        tempvol(tempvol==-16000)=NaN;
        interp_zstackR=uint16(inpaintn(tempvol,100));
        
        
        interp_zstackR3(localsizey,localsizex,localsizez,volnum)=interp_zstackR;
        zscale=rescale(interp_zstackR,0,1,'InputMin',400,'InputMax',15500);
        zstack_paintdR(localsizey,localsizex,localsizez,volnum)=uint8( 255.*imadjustn(zscale,stretchlim(zscale(:),[0 hiR]),[],gammaR) );
          % TopHat scaled grayscale
        THVol(localsizey,localsizex,localsizez,volnum)=imtophat(zstack_paintdR(localsizey,localsizex,localsizez,volnum),sa);
        
%         BWVolR_denoise(localsizey,localsizex,localsizez,volnum) = bwareaopen(THVol(localsizey,localsizex,localsizez,volnum), 125, 26);
      
        clear tempvol zscale
    end
    
    
end


%% Cat Global Volumes
% BWVolR_denoise=BWVolR_denoise(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
%non-scaled version
% interp_zstackR3=interp_zstackR3(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
%scaled
zstack_paintdR=zstack_paintdR(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
%scaled and tophat
THVol=THVol(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
%tophat binarized
% BWVolR_close=BWVolR_close(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
% zstack_paintdR3D=max(zstack_paintdR,[],4);
% BWVolR_denoise3D=max(BWVolR_denoise,[],4); 
THVol3D=max(THVol,[],4);
stats = regionprops3(THVol3D,'all'); %whats in the volume after all those operations


%% Statistical test to compare raw int with trasnform
        % pick a volume, i.e. vol 1
        RawScaled=uint8(zstack_paintdR(:,:,:,1));
        %individual scaled tophat
        TopHatScaled=uint8(THVol(:,:,:,1));

        SSIMscore = multissim3(TopHatScaled,RawScaled);

   %% Create figure and perform virus-cell distance measuremnt      
        
     [faces,vertices] = isosurface(XX,YY,ZZ,THVol3D,0.5);
    
if ~isempty(vertices) %on rare occasions no volume, skip these
hCPcopy2=copyfig(hCP);
hold on;
p2 = patch('Faces',faces,'Vertices',vertices);
p2.FaceColor = [0.6350 0.0780 0.1840]; %maroon
p2.EdgeColor = 'none';
p2.FaceAlpha = 0.25; 
%zoom in around traj
xlim([min(PXRd)-5 max(PXRd)+5]);
ylim([min(PYRd)-5 max(PYRd)+5]);
zlim([min(PZRd)-2 max(PZRd)+2]);
title([matfname(1:22) ' Iso TrajCP'],'Fontsize',12,'Interpreter', 'none','color','white');    
view(3); 
figCPcopy2name=[matpname3 ' ChangePointTraj iso view3' '.fig'];
saveas(hCPcopy2,figCPcopy2name,'fig');
pngCPcopy2Name=[matpname3 ' ChangePointTraj iso view3' '.png'];
print(pngCPcopy2Name,'-dpng');
view(2);
pngCPcopy2Name=[matpname3 ' ChangePointTraj iso view2' '.png'];
print(pngCPcopy2Name,'-dpng');
view([90,0]);
pngCPcopy2Name=[matpname3 ' ChangePointTraj iso ZY' '.png'];
print(pngCPcopy2Name,'-dpng');

     trajStruct=approachCell_final(trajStruct,vertices,hCPcopy2,matfname,matpname3);
    
    %temp storage of important variables
    DiffCoefftemp=[];
    rtemp=[];
    rsem=[];
    index=1;
for i=1:length(trajStruct)
    if trajStruct(i).active
        DiffCoefftemp(index)=trajStruct(i).D;
        rtemp(index)=mean(trajStruct(i).r);
        rsem(index)=std(trajStruct(i).r)/sqrt(length(trajStruct(i).r));
        index=index+1;
    end
end
    
    AllDistanceData(f).trajNumber=matlist(f).name(8:21); %Traj number
    AllDistanceData(f).D=horzcat(DiffCoefftemp);
    AllDistanceData(f).r=horzcat(rtemp);
    AllDistanceData(f).rerror=horzcat(rsem);
        
%% SAVES THE traj mat FILE
          saveDataName1=[matpname3 ' traj.mat'];
          save(saveDataName1,'traj','trajStruct','vertices','stats','SSIMscore'); 
%% Run Autogen to generate CP Avizo Project
cd(matpname); %the folder Avizo subfolder already located
AutogenTrImAvizoProjectUnified(vidfdate,vidfID,PXRdFilt,PYRdFilt,PZRdFilt,TrTime,zstack_paintdR,excrop,eycrop,ezcrop,traj,1,THVol3D);         
               
close all;
clear time traj trajStruct alpha data BWVolR_close BWVolR_close3D;
clear faces vertices XX YY ZZ DiffCoefftemp rtemp index;


else
    disp('no volume!')
     saveDataName1=[matpname3 ' traj.mat'];
     save(saveDataName1,'traj','trajStruct'); 
%% Run Autogen to generate CP Avizo Project

cd(matpname); %the folder Avizo subfolder already located
AutogenTrImAvizoProjectUnified(vidfdate,vidfID,PXRdFilt,PYRdFilt,PZRdFilt,TrTime,zstack_paintdR,excrop,eycrop,ezcrop,traj,1,THVol3D);
        
  
close all;
clear time traj trajStruct alpha data BWVolR_close BWVolR_close3D;
clear XX YY ZZ;
end
        end   
end

%% CATENATES THE IMPOTANT VARIABLES

m= size(CPData,2);
All_D=[];
All_SegDur=[];
All_Alpha=[];
All_MEANSegINT=[];

 
for i=1:m
All_D=horzcat(All_D,CPData(i).D);
All_SegDur=horzcat(All_SegDur,CPData(i).SegDur);
All_Alpha=horzcat(All_Alpha,CPData(i).Alpha);
All_MEANSegINT=horzcat(All_MEANSegINT,CPData(i).MEANSegINT);
end

%%SAVES THE MAT FILE

          saveDataName2=[matfname(1:6) ' CP.mat'];
                save(saveDataName2,'CPData','All_D','All_SegDur','All_Alpha','All_MEANSegINT','AllDistanceData'); 
    disp('all work complete!')
end

