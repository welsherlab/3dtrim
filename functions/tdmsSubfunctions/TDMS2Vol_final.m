function [exTr,eyTr,ez,SZ,system_params,zstackR,zstackG,zstackB,zstacknorm,VolTime,localextrema,FPV,Zrange,FrTime,perfrint,pervolint,zstackR_sd]=TDMS2Vol_final(savedir,vidpname,vidfname,PXRd,PYRd,PZRd,volsize,red,green,blue,trackLPF,customsystem_params,trackFr,lagPD1,lagPD2,trackPx,trackLn)

system_params=gensysparams([vidpname '\' vidfname]);

if system_params.obj == 'Nikon'
    [pixelcenter,linecenter,~]=autoloadTrIm3D_Cal_Nikon([vidpname '\' vidfname]);
elseif system_params.obj == 'Zeiss'
    [pixelcenter,linecenter,~]=autoloadTrIm3D_Cal_f([vidpname '\' vidfname]);
end

if customsystem_params~=0
    system_params.customsystem_params(1)=customsystem_params(2);
end

system_params.fps=0.922987;

numelFR=1805731;% at t1, 1203820 at t0.7, set according to fps;
s_per_el=1./(system_params.fps.*numelFR); %0.6 usec / VID el this should be a constant for 24ticks/el, not related to fps
chunksize=(volsize+2).*numelFR;

%OBJ: Read TDMS in approx. volume size chunks and output volume

substart=1;
subfin=0;

%% Begin reading file
[~,metaStruct] = TDMS_getStruct([vidpname '\' vidfname],4,{'GET_DATA_OPTION','getnone'});
numelFile=max(metaStruct.numberDataPoints);
estnumvols=floor(numelFile/numelFR/volsize);

objStruct = struct;
objStruct.groupsKeep = metaStruct.groupNames;

oln=[];
opx=[];
ofr=[];
oi1=[];
oi2=[];
opd1=[];
opd2=[];
opdr=[];
VolTime=[];
oz=[];
zstackR=[];
ex=[];
ey=[];
ez=[];
SZ=[];
voldat=[];
zstacknorm=[];
zstackG=[];
zstackR_sd=[];
zstackB=[];
localextrema=[];
FPV=[];
Zrange=[];
flag=0;
volnum=1;
i=0
t1=1;
perfrint=[];
pervolint=[];
FrTime=[];
hw = waitbar(0,'Loading TDMS and Assembling Volume Structure...');

while flag~=1 %While reading has not reached flag for end-of-file.
    subfin=substart+chunksize-length(oln);
    if subfin>metaStruct.numberDataPoints(3)
        subfin=metaStruct.numberDataPoints(3);
    end
    
    if substart>subfin
        VidLnT=[];
        VidPxT=[];
        VidFrT=[];
        VidINT1T=[];
        VidINT2T=[];
        VidPD1T=[];
        VidPD2T=[];
        VidPDR=[];
        flag=1;
    else
        opts={'META_STRUCT',metaStruct,'GET_DATA_OPTION','getSubset','OBJECTS_GET',objStruct,'SUBSET_GET',[substart subfin],'SUBSET_IS_LENGTH',false};
        [tdms_structVIDseg,~] = TDMS_getStruct([vidpname '\' vidfname],4,opts);
        
        fnVID = fieldnames(tdms_structVIDseg);
        
        VidLnT=tdms_structVIDseg.(fnVID{2}).Line.data;
        VidPxT=tdms_structVIDseg.(fnVID{2}).Pixel.data;
        VidFrT=tdms_structVIDseg.(fnVID{2}).Frame.data;
        VidINT1T=tdms_structVIDseg.(fnVID{2}).VID1.data;
        VidINT2T=tdms_structVIDseg.(fnVID{2}).VID2.data;
        VidPD1T=tdms_structVIDseg.(fnVID{2}).PD1.data;
        VidPD2T=tdms_structVIDseg.(fnVID{2}).PD2.data;
        VidPDR=tdms_structVIDseg.(fnVID{2}).PDR.data;
        clear tdms_structVIDseg
    end
    
    i=i+1
    
    VidPDR=[opdr VidPDR];
    VidLnT(VidLnT<0)=0;
    VidLnT=[oln VidLnT];
    VidPxT=[opx VidPxT];
    VidFrT=[ofr VidFrT];
    VidINT1T=[oi1 VidINT1T];
    VidINT2T=[oi2 VidINT2T];
    VidPD1T=[opd1 VidPD1T];
    VidPD2T=[opd2 VidPD2T];    
    
    
    %% BUILD FRAMELIST FOR VOLUME
    framestart=(find( VidLnT==0&VidPxT==0)); %find list of frame edges, pixel/ln 0,0.
    framestart=uniquetol(framestart,1e-1);
    minfr=VidFrT(min(framestart));
    frameend=framestart(framestart>1)-1;
    maxfr=VidFrT(max(frameend));
    framelist=minfr:maxfr;
    
    if    length(framelist)>3
        
        if length(framelist)<volsize
            volsize=length(framelist);
        end
        %% FIND FULL Z PIEZO RANGE DURING ACQUISITION TO EVALUATE SAMPLING
        
        ZTravel=[];
        FPVtemp=[];
        TheoreticalMaxFill=[];
        for f=3:length(framelist) %3 = min FPV
            framelistT=framelist(1:f);
            ZTravel(f-2)=range(PZRd(ismember(trackFr',framelistT)));
            FPVtemp(f-2)=length(framelistT);
            TheoreticalMaxFill(f-2)=FPVtemp(f-2)/(16+(2*ZTravel(f-2)));
        end
        
        BestTheoreticalFill=find(TheoreticalMaxFill==max(TheoreticalMaxFill),1);
        
        FPV(volnum)=FPVtemp(BestTheoreticalFill);
        Zrange(volnum)=ZTravel(BestTheoreticalFill);
        
        %% PROCESS TIME SERIES VIDEO
        
        maxfrnum=framelist(FPV(volnum));
        minfrnum=framelist(1);
        
        frInd=find(VidFrT>=(minfrnum)&VidFrT<=maxfrnum&VidPDR>5e3&1:length(VidFrT)<=length(VidPD2T));
        min_px=min(frInd);
        max_px=max(frInd);
        
        
        if volnum==1
            
            vidLPF=double(VidLnT)+double(VidPxT)*1e3+double(VidFrT)*1e6;
            vidLPFmin=vidLPF(min_px)+1000;
            
            if vidLPFmin<trackLPF(1) %If Video starts before track (aka. negative trajectory time due to clipping of 1s traj)
                dtTr=find(vidLPF>=trackLPF(1),1);
                basetime=(vidLPFmin-vidLPF(dtTr)).*s_per_el;
                clear dtTr
            else %Video starts after trajectory due to clipping image of incomplete frames
                dtIm=find(trackLPF>=vidLPFmin,1);
                basetime=dtIm.*1e-5;
                clear dtIm
            end
            
            clear vidLPF vidLPFmin
            ImTimePrev=basetime;
            
        else
            
            ImTimePrev=(sum(FPV(1:end-1))./system_params.fps)+basetime;
            
        end
        
        ImTimeSec=(sum(FPV)./system_params.fps)+basetime;    
       
        VolTime(volnum,1)=ImTimeSec;
        VolTime(volnum,2)=ImTimePrev;        
        oi1=VidINT1T(max_px+1:end);
        oi2=VidINT2T(max_px+1:end); 
        opx=VidPxT(max_px+1:end);
        oln=VidLnT(max_px+1:end);
        ofr=VidFrT(max_px+1:end);
        opdr=VidPDR(max_px+1:end);
        VidLnT=VidLnT(min_px:max_px);
        VidPxT=VidPxT(min_px:max_px);
        VidFrT=VidFrT(min_px:max_px);
        VidINT1T=VidINT1T(min_px:max_px);
        VidINT2T=VidINT2T(min_px:max_px);
        VidPDR=VidPDR(min_px:max_px);
        
        if volnum==1
            opd1=VidPD1T(max_px+lagPD1+1:end);
            opd2=VidPD2T(max_px+lagPD2+1:end);
            VidPD1T=VidPD1T(min_px+lagPD1:max_px+lagPD1);
            VidPD2T=VidPD2T(min_px+lagPD2:max_px+lagPD2);
        else
            opd1=VidPD1T(max_px+1:end);
            opd2=VidPD2T(max_px+1:end);
            VidPD1T=VidPD1T(min_px:max_px);
            VidPD2T=VidPD2T(min_px:max_px);
        end
        
        PD1rat=double(VidPD1T)./double(VidPDR);
        clear VidPD1
        PD2rat=double(VidPD2T)./double(VidPDR);
        clear VidPD1T VidPD2T
        PDdiff=PD1rat-PD2rat;
        clear  PD1rat PD2rat
        
        %% Process ETL Signal and define Zplanes
       
        if system_params.obj == 'Nikon'
            zpos=autoloadETLCal_Nikon(vidfname,PDdiff);
        elseif system_params.obj == 'Zeiss'
            zpos=autoloadETLCal_f(vidfname,PDdiff);
        end
        clear PDdiff
        
        %Remove Flyback Pixels After Delag
        LinCon1=(VidLnT>-1&VidLnT<=511&VidPxT<=511);
        LinCon2=~(VidLnT==0&VidPxT==0);
        LinearRegime=LinCon1&LinCon2;
        zpos=zpos(LinearRegime);
        VidLnT=VidLnT(LinearRegime);
        VidPxT=VidPxT(LinearRegime);
        VidFrT=VidFrT(LinearRegime);
        VidINT1T=VidINT1T(LinearRegime);
        VidINT2T=VidINT2T(LinearRegime);
        clear LinearRegime LinCon1 LinCon2
        LinCon1=(trackLn>-1&trackLn<=511&trackPx<=511);
        LinCon2=~(trackLn==0&trackPx==0);
        LinearRegime=LinCon1&LinCon2;
        PXlin=PXRd(LinearRegime);
        PYlin=PYRd(LinearRegime);
        trackLn=trackLn(LinearRegime);
        trackPx=trackPx(LinearRegime);
        clear LinearRegime LinCon1 LinCon2
        
        vidLPF=double(VidLnT)+double(VidPxT)*1e3+double(VidFrT)*1e6; %Important to ID AFTER delaggint in CT mode.
        %% Synchronize Tracking and Imaging Coordinates
        
        vidPos=zeros(length(VidLnT),3);
        vidIndex=(1:length(vidPos(:,1)))';
        
        %Find Intersection of LPF ID in both data sets
        [~,iVid,iTrack]=intersect(vidLPF,trackLPF);
        
        
        
        
        clear vidLPF
        
        if isempty(iTrack)==0
            
            %Assign stage positions to confocal positions
            vidPos(iVid,1)=PXRd(iTrack);
            vidPos(iVid,2)=PYRd(iTrack);
            vidPos(iVid,3)=PZRd(iTrack);
            %% Convert to real space coordinates
            
            %Create temporary data including confocal data with assigned x,y,z
            tempInterpPos=vidPos(vidPos(:,1)~=0,:); %~=0 means a real stage position was sampled for the LPF value
            tempInterpIndex=vidIndex(vidPos(:,1)~=0);
            
            
            %Perform interpolation to find undefined values
            vidPos(:,1)=interp1(tempInterpIndex,...
                tempInterpPos(:,1),vidIndex);
            vidPos(:,2)=interp1(tempInterpIndex,...
                tempInterpPos(:,2),vidIndex);
            vidPos(:,3)=interp1(tempInterpIndex,...
                tempInterpPos(:,3),vidIndex);
            
            %Remove NaN's from the interp? Why does the interp return Nan's?
            noNaNs=~isnan(vidPos(:,1));
            zpos=zpos(noNaNs);
            VidLnT=VidLnT(noNaNs);
            VidPxT=VidPxT(noNaNs);
            VidFrT=VidFrT(noNaNs);
            VidINT1T=VidINT1T(noNaNs);
            VidINT2T=VidINT2T(noNaNs);
            vidPos=vidPos(noNaNs,:);
            clear noNaNs
            %Adjust pixel position to position in real space
            
            vidX=vidPos(:,1)+((double(VidPxT+1)'-pixelcenter)*system_params.Xdpix);
            vidY=vidPos(:,2)-((double(VidLnT+1)'-linecenter)*system_params.Ydpix);
            vidZ=(vidPos(:,3)-zpos');
            % %                 vidPos(824720,1)+((double(0+1)'-pixelcenter)*system_params.Xdpix)
            if volnum==1
                
                %Define common volume extrema - BE CAREFUL WITH SIGN (!)
                vidXTr=PXlin+((double(trackPx+1)-pixelcenter).*system_params.Xdpix);
                vidYTr=PYlin-((double(trackLn+1)-linecenter).*system_params.Ydpix);
                XminTr=min(vidXTr)-(system_params.Xdpix/2);
                XmaxTr=max(vidXTr)+(system_params.Xdpix/2);
                YminTr=min(vidYTr)-(system_params.Ydpix/2);
                YmaxTr=max(vidYTr)+(system_params.Ydpix/2);
                
                
                Xmin=min(PXRd(trackPx==0))+((1-pixelcenter)*system_params.Xdpix)-(system_params.Xdpix/2);
                Xmax=max(PXRd(trackPx==511))+((512-pixelcenter)*system_params.Xdpix)+(system_params.Xdpix/2);
                Ymin=min(PYRd(trackLn==0))-((512-linecenter)*system_params.Ydpix)-(system_params.Ydpix/2);
                Ymax=max(PYRd(trackLn==511))-((1-linecenter)*system_params.Ydpix)+(system_params.Ydpix/2);
                
                Zmin=min(PZRd)+min(-zpos)-0.25;
                Zmax=max(PZRd)+max(-zpos)+0.25;
                
                ex=[Xmin:(1/system_params.x_px_per_um):Xmax+system_params.Xdpix];
                ey=[Ymax:-(1/system_params.y_px_per_um):Ymin-system_params.Ydpix];
                ey=flip(ey);
                ez=[Zmin:(1/system_params.z_px_per_um):(Zmax+0.5)]; %Give 1 bin extra in case of noise/heating. Crop will happen anyway.
                
                exTr=[XminTr:system_params.Xdpix:XmaxTr+system_params.Xdpix];
                %                     eyTr=[YminTr:system_params.Ydpix:YmaxTr+system_params.Ydpix];
                eyTr=[YmaxTr:-(1/system_params.y_px_per_um):YminTr-system_params.Ydpix];
                eyTr=flip(eyTr);
                %Still issues due to flip + span. Either solve by trashing pixels or
                %shifting the bins.
                
                %Temporary fix pending further testing:
                if eyTr(1)>min(vidYTr)
                    minYcent=min(vidYTr);
                    newedge=minYcent-(system_params.Ydpix/2);
                    deltabin=eyTr(1)-newedge;
                    eyTr=eyTr-deltabin;
                end
                clear vidXTr vidYTr PXlin PYlin
                SZ=[length(eyTr)-1 length(exTr)-1 length(ez)-1];
                zstacknorm=zeros(SZ(1),SZ(2),SZ(3),estnumvols,'uint8');
                zstackR=zeros(SZ(1),SZ(2),SZ(3),estnumvols,'int16');
                zstackR_sd=zeros(SZ(1),SZ(2),SZ(3),estnumvols,'double');
                zstackR_sd=[];
            end
            xcoordvol=discretize(vidX,exTr,'IncludedEdge','right'); %pixel
            ycoordvol=discretize(vidY,eyTr,'IncludedEdge','right');
            %                 xcoordvol=discretize(vidX,ex,'IncludedEdge','right'); %pixel
            %                 ycoordvol=discretize(vidY,ey,'IncludedEdge','right');
            zcoordvol=discretize(vidZ,ez,'IncludedEdge','right');
            
            finchk=all([isfinite(ycoordvol),isfinite(xcoordvol),isfinite(zcoordvol)],2);
            localextrema(volnum,1)=min(xcoordvol);
            localextrema(volnum,2)=max(xcoordvol);
            localextrema(volnum,3)=min(ycoordvol);
            localextrema(volnum,4)=max(ycoordvol);
            localextrema(volnum,5)=min(zcoordvol);
            localextrema(volnum,6)=max(zcoordvol);
            
            %% BUILD RAW VOLUME
            
            pervolint(volnum)=sum(VidINT1T);
            
            zstacknorm(:,:,:,volnum)=uint8(accumarray([ycoordvol(finchk) xcoordvol(finchk) zcoordvol(finchk)],1,SZ)); %tells how many times sampled
            voldat=['size ' num2str(size(zstacknorm(:,:,:,volnum))) ' min coords ' num2str(ey(1)) ' ' num2str(ex(1)) ' ' num2str(ez(1)) ' max coords ' num2str(ey(end)) ' ' num2str(ex(end)) ' ' num2str(ez(end))];
            if red==1
                IntR=VidINT1T;
                zstackR(:,:,:,volnum)=int16(accumarray([ycoordvol(finchk) xcoordvol(finchk) zcoordvol(finchk)],IntR(finchk),SZ,@mean,-16000));

            end
            
            
            if green==1
                IntG=double(VidINT2T);
                zstackG(:,:,:,volnum)=int16(accumarray([ycoordvol(finchk) xcoordvol(finchk) zcoordvol(finchk)],IntG(finchk),SZ,@mean,-16000));
                
            end
            
            if blue==1
                IntB=double(VidINT1T);
                zstackB=accumarray([ycoordvol xcoordvol zcoordvol],IntB,SZ,@mean,NaN);
            end
            
            volnum=volnum+1;
        end
        %         end
    end
    substart=subfin+1;
    waitbar(subfin/metaStruct.numberDataPoints(3),hw)
    
end

close(hw)

%% Trim Over-Preallocated Array if need

if ~isempty(zstackG)
    zstackG=zstackG(:,:,:,1:volnum-1);
end

if ~isempty(zstackR)
    zstackR=zstackR(:,:,:,1:volnum-1);
end

zstacknorm=zstacknorm(:,:,:,1:volnum-1);
end

%GOAL PROGRESS:
%1. ID EOF flag X
%2. Set up while loop X
%3. Determine Segment indices X
%4. Build Volume X
%5. Hold and concatenate remainder X
%6. Test X
%7. Repeat X
%8. Ensure alignment of LPF and Int on second segment X
%9. Clean up call by combining system params into structure
%10. Add time axis
%11. Minimize footprint
%12. Add multiple camera views and save
%13. Add system params struct to saved mat
%14. Maybe functionalize system params, in future can just overwrite struct
%lines for differences? (ie: LSM_params.zoomfactor=2)
%15. Need to line up traj start if clipped image due to chameleon off. X