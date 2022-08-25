%% Batch Process 3D-TrIm Data
%This code requests user input to select the folder containing 3D-TrIm
%trajectories and will locate matching pairs of tracking and imaging data
%and transform the raw data into co-registered image volumes with overlaid
%trajectories. The resulting volume images and trajectory plots can be
%viewed independently or as overlays using the script files generated for
%Amira 2021.3 or newer. Additionally, the diffusion changepoint distribution of the
%trajectories are analyzed and exported.


% By: Courtney Johnson


runCP=1; %Optional: Setting to 1 will add a processing step to calculate trajectory diffusion change-points.
set(0,'defaultFigureWindowStyle','docked')

%% SELECT COLOR CHANNELS

% Intended for future use with multi-color imaging data, leave as set (red = 1, green = 0, blue = 0) for
% single-color operation.
red=1;
green=0;
blue=0;
numchan=red+green+blue;
skipstuck=0; %Optional: If set to 1 will detect trajectories with stationary particles and skip processing,

%% Set Intensity Histogram Threshold and Gamma, left as constants

hiR=0.9998;
hiG=0.9998;
hiB=0.9998;
gammaR=0.7;
gammaG=0.7;
gammaB=0.7;

%% SYSTEM PARAMETERS

volsize=16; %Target number of frames per volume (FPV)

% Piezo bits to um scaling
xconv=(1/32767*76.213);
yconv=(1/32767*76.555);
zconv=(1/32767*50.942);

% dPhotodiode synchronization values
lagPD1=135;
lagPD2=274;

%% SELECT DATA LOCATION AND FIND LIST OF TRAJECTORIES

mainpname=uigetdir; %Select the folder which contains .tdms files starting with TR.
[~,mainp]=fileparts(mainpname);
cd(mainpname);
dirnamelist=dir(pwd);
neldir=length(dirnamelist);

filenamelist_VID=dir(['*\*VID*' '.tdms']);
if isempty(filenamelist_VID)
    filenamelist_VID=dir(['*VID*' '.tdms']);
end
neltdms=length(filenamelist_VID);
tdmslist=filenamelist_VID;
allsize=[tdmslist(:).bytes];
[stucksize,numstuck]=mode(allsize(allsize>1e6));
if numstuck<5
    stucksize=0;
end

qWait=waitbar(0,'Processing 3D-TrIm Data...');
mainsavedir=('Processed Files');
mkdir(mainsavedir);

%% Loop through and Process Trajectories

for q=1:neltdms

    cd(mainpname)
    vidfname=filenamelist_VID(q).name;
    vidpname=filenamelist_VID(q).folder;
    vidbytes=filenamelist_VID(q).bytes;
    vidfID=vidfname(8:end-5);
    vidfdate=vidfname(1:6);
    if vidfname(8)=='V'

        %% Locate trajectory data file

        loc=strfind(vidfname,'TR');
        tag=vidfname(loc:loc+5);
        flist=dir(['**\*' tag '*' '.tdms']);

        if length(flist)==2

            trfname=flist(1).name;
            trpname=flist(1).folder;
            trbytes=flist(1).bytes;

            if trfname(8)=='V'
                trfname=flist(2).name;
                trpname=flist(2).folder;
                trbytes=flist(2).bytes;
            end

            TrMB=trbytes./(1024.^2); %Determine if trajectory is long enough to have meaningful quantity of image data. Conversion is 2mb of tr file = 1 fr vid


            %Skip processing short trajectories
            if TrMB<20||vidbytes<1e4||(vidbytes==stucksize&&skipstuck==1)
                disp(['Warning: ' trfname ' : Trajectory/Vid Data too short or Stuck']);
            else

                %%  Create Directory for Processed Trajectory Data
                dirname=[vidfdate ' ' vidfID ''];
                savedir=[mainpname '\' mainsavedir '\' dirname];
                %                     dirname=[pname '\' trfname(1:13) ' TS QoL Test Dlag FlFPV'];
                mkdir(savedir);
                cd(mainpname)

                %% Load Track Data
                [PXRd,PYRd,PZRd,Int,trackLPF,trackPx,trackLn,trackFr]=loadTrTDMS_final(trfname,1e5); %Function loads track data

                %% Load and Pre-Process Video

                %Note: Image data size depends on trajectory length and is
                %often too large to load entire dataset into RAM.
                % This function will load ~1 volume worth of data based on
                % framerate and FPV, and assemble the image data
                % volume-by-volume to reduce memory footprint.

                tic
                [ex,ey,ez,SZ,system_params,zstackR,zstackG,zstackB,zstacknorm,ImTime,localextrema,FPV,Zrange,FrTime,perfrint,pervolint,zstackR_sd]=TDMS2Vol_final(savedir,vidpname,vidfname,PXRd,PYRd,PZRd,volsize,red,green,blue,trackLPF,0,trackFr,lagPD1,lagPD2,trackPx,trackLn);
                ez=ez-0.2961; %Z Offset Correction, left as constant

                savesubdir=[savedir '\' num2str(volsize) ' FPV'];
                mkdir(savesubdir)
                cd(savesubdir)

                toc
                clear trackLPF trackFr trackPx trackLn
                if isfinite(ex) %Ensure video data was processed successfully before proceeding further
                    cd(savesubdir);

                    %% DEFINE GLOBAL AND LOCAL IMAGE SPACES

                    %Due to trajectory motion and sparse sampling of ETL,
                    %x/y/z coordinates are sampled unevenly. The function
                    %of this section is to determine the global volume
                    %boundary by determining which portions of the volume
                    %are too undersampled to interpolate.

                    for volnum=1:size(zstacknorm,4) %Loop through each volume
                        for nx=1:size(zstacknorm,2) %Loop through x coordinate values and determine sampling of image volume along the X axis
                            pxfill(nx,volnum)=100.*sum(sum(zstacknorm(:,nx,:,volnum)>0))./numel(zstacknorm(:,nx,:,volnum));
                        end
                        %

                        pxtest=find(pxfill(:,volnum)>0.7.*median(pxfill(:,volnum))); %Define X volume boundaries where sampling drops to <70%
                        if ~isempty(pxtest)
                            localextremafill(volnum,1)=min(pxtest);
                            localextremafill(volnum,2)=max(pxtest);
                        else
                            localextremafill(volnum,1)=0;
                            localextremafill(volnum,2)=0;
                        end

                    end

                    for volnum=1:size(zstacknorm,4) %Loop through y coordinate values and determine sampling of image volume along the Y axis
                        for ny=1:size(zstacknorm,1)
                            linefill(ny,volnum)=100.*sum(sum(zstacknorm(ny,:,:,volnum)>0))./numel(zstacknorm(ny,:,:,volnum));
                        end

                        linetest=find(linefill(:,volnum)>0.7.*median(linefill(:,volnum))); %Define X volume boundaries where sampling drops to <70%
                        if ~isempty(linetest)
                            localextremafill(volnum,3)=min(linetest);
                            localextremafill(volnum,4)=max(linetest);
                        else
                            localextremafill(volnum,3)=0;
                            localextremafill(volnum,4)=0;
                        end

                    end

                    for volnum=1:size(zstacknorm,4) %Should do this LAST and according to local regions each volnum for accuracy
                        for nz=1:size(zstacknorm,3)

                            planefill(nz,volnum)=100.*nnz(zstacknorm(localextremafill(volnum,3):localextremafill(volnum,4),localextremafill(volnum,1):localextremafill(volnum,2),nz,volnum))./numel(zstacknorm(localextremafill(volnum,3):localextremafill(volnum,4),localextremafill(volnum,1):localextremafill(volnum,2),nz,volnum));
                        end
                        planetest=find(planefill(:,volnum)>20);
                        if length(planetest)<4
                            planetest=find(planefill(:,volnum)>15);
                        end


                        if ~isempty(planetest)
                            localextremafill(volnum,5)=min(planetest);
                            localextremafill(volnum,6)=max(planetest);
                        else
                            localextremafill(volnum,5)=0;
                            localextremafill(volnum,6)=0;
                        end
                    end

                    globalextrema=[];

                    if  any(localextremafill(:,5))>0

                        globalextrema(1)=min(localextremafill(find(localextremafill(:,1)),1));  %Global X Minimum
                        globalextrema(2)=max(localextremafill(:,2)); %Global X Maximum
                        globalextrema(3)=min(localextremafill(find(localextremafill(:,3)),3)); %Global Y Minimum
                        globalextrema(4)=max(localextremafill(:,4)); %Global Y Maximum
                        globalextrema(5)=min(localextremafill(find(localextremafill(:,5)),5)); %Global Z Minimum
                        globalextrema(6)=max(localextremafill(:,6)); %Global Z Maximum

                        %% Process Image Volumes
                        % The purpose of this section is to process image
                        % volumes. Instead of scaling and interpolating the
                        % global image volume which may feature bleaching
                        % in later volumes or have spatially-varying
                        % sampling, volumes are instead treated on a
                        % local-volume basis before being re-inserted into
                        % its location in the 4D global volume space.

                        tic
                        if red==1

                            zstack_paintdR=zeros(size(zstackR),'uint8');
                            interp_zstackR2=zeros(size(zstackR),'uint16');
                            zstack_paintdR_TopHat=zeros(size(zstackR),'uint16');
                            BWVolR_denoise=zeros(size(zstackR),'uint16');
                            BWVolR_close=zeros(size(zstackR),'uint16');
                            se = strel('sphere',5);

                            hw = waitbar(0,'Inpainting 3D Volumes...');
                            for volnum=1:size(zstackR,4)
                                if localextremafill(volnum,5)~=0

                                    localsizex=localextremafill(volnum,1):localextremafill(volnum,2);
                                    localsizey=localextremafill(volnum,3):localextremafill(volnum,4);
                                    localsizez=localextremafill(volnum,5):localextremafill(volnum,6);
                                    tempvol=double(zstackR(localsizey,localsizex,localsizez,volnum));
                                    tempvol(tempvol==-16000)=NaN; %Flag unsampled voxels
                                    interp_zstackR=uint16(inpaintn(tempvol));
                                    interp_zstackR2(localsizey,localsizex,localsizez,volnum)=interp_zstackR;
                                    zscale=rescale(interp_zstackR,0,1,'InputMin',400,'InputMax',15500); %Rescale with fixed background threshold
                                    zstack_paintdR(localsizey,localsizex,localsizez,volnum)=uint8( 255.*imadjustn(zscale,stretchlim(zscale(:),[0 hiR]),[],gammaR)); %Scale contrast based on intensity histogram CDF.

                                    %Determine cellular boundaries through Top-Hat Transform Segmentation
                                    zstack_paintdR_TopHat(localsizey,localsizex,localsizez,volnum)=imtophat(zstack_paintdR(localsizey,localsizex,localsizez,volnum),se);

                                    BWVolR_denoise(localsizey,localsizex,localsizez,volnum) = bwareaopen(zstack_paintdR_TopHat(localsizey,localsizex,localsizez,volnum), 75, 26); %remove small clumps

                                    BWVolR_close(localsizey,localsizex,localsizez,volnum) = imclose(BWVolR_denoise(localsizey,localsizex,localsizez,volnum),se); %connect close surfaces
                                    clear tempvol zscale
                                end
                                waitbar(volnum/size(zstackR,4),hw)

                            end
                            toc
                            close(hw)

                            %Crop final volume to global volume space
                            %boundaries.
                            zstack_paintdR=zstack_paintdR(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            interp_zstackR2=interp_zstackR2(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            excrop=ex(globalextrema(1):globalextrema(2));
                            eycrop=ey(globalextrema(3):globalextrema(4));
                            ezcrop=ez(globalextrema(5):globalextrema(6));
                            zstacknormcrop=zstacknorm(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            zstack_paintdR_TopHat=zstack_paintdR_TopHat(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            BWVolR_close=BWVolR_close(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            BWVolR_close3D=max(BWVolR_close,[],4);
                        end

                        %Repeat above section for any other color channels
                        tic
                        if green==1

                            zstack_paintdG=zeros(size(zstackG),'uint8'); 
                            interp_zstackG2=zeros(size(zstackG),'uint8');
                            zstack_paintdG_TopHat=zeros(size(zstackG),'uint16'); %tophat each volume
                            BWVolG_denoise=zeros(size(zstackG),'uint16');
                            BWVolG_close=zeros(size(zstackG),'uint16');
                            se = strel('sphere',5);
                            hw = waitbar(0,'Inpainting 3D Volumes...');
                            for volnum=1:size(zstackG,4)
                                if localextremafill(volnum,5)~=0
                                    localsizex=localextremafill(volnum,1):localextremafill(volnum,2);
                                    localsizey=localextremafill(volnum,3):localextremafill(volnum,4);
                                    localsizez=localextremafill(volnum,5):localextremafill(volnum,6);
                                    tempvol=double(zstackG(localsizey,localsizex,localsizez,volnum));
                                    tempvol(tempvol==-16000)=NaN;
                                    interp_zstackG=uint16(gather(inpaintnGPUsingle(tempvol,100)));
                                    interp_zstackG2(localsizey,localsizex,localsizez,volnum)=interp_zstackG;
                                    zscale=rescale(interp_zstackG,0,1,'InputMin',400,'InputMax',15500);
                                    zstack_paintdG(localsizey,localsizex,localsizez,volnum)=uint8( 255.*imadjustn(zscale,stretchlim(zscale(:),[0 hiG]),[],gammaG) );
                                    zstack_paintdG_TopHat(localsizey,localsizex,localsizez,volnum)=imtophat(zstack_paintdG(localsizey,localsizex,localsizez,volnum),se);
                                    BWVolG_denoise(localsizey,localsizex,localsizez,volnum) = bwareaopen(zstack_paintdG_TopHat(localsizey,localsizex,localsizez,volnum), 75, 26); %remove small clumps
                                    BWVolG_close(localsizey,localsizex,localsizez,volnum) = imclose(BWVolG_denoise(localsizey,localsizex,localsizez,volnum),se); %connect close surfaces
                                    clear tempvol zscale

                                end
                                waitbar(volnum/size(zstackG,4),hw)

                            end
                            toc
                            close(hw)

                            zstack_paintdG=zstack_paintdG(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            interp_zstackG2=interp_zstackG2(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            zstack_paintdG_TopHat=zstack_paintdG_TopHat(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            BWVolG_close=BWVolG_close(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:);
                            BWVolG_close3D=max(BWVolG_close,[],4);

                        end


                        if blue==1

                            raw_zstackB=uint8(255.*imadjustn(rescale(zstackB,0,1),stretchlim(rescale(zstackB(~isnan(zstackB)),0,1),[loB hiB]),[],gammaB));
                            interp_zstackB=inpaintnGPU(zstackB,100);
                            zstack_paintdB=uint8(255.*imadjustn(rescale(interp_zstackB,0,1),stretchlim(rescale(zstackB(~isnan(zstackB)),0,1),[loB hiB]),[],gammaB));
                            zstack_map_sizeB=zstack_paintdB;
                            for volnum=1:size(zstackB,4)
                                ImName=([vidfdate ' ' vidfID ' Frame ' num2str(volnum) ' ' Blue_Dye ' ' voldat]);
                                ImExt=' -BLUE.vol';
                                fID=fopen([ImName ImExt],'w','l');
                                fwrite(fID,uint8(permute(zstack_paintdB(:,:,:,volnum),[2 1 3])),'uint8')
                                fclose(fID);
                            end
                        end

                        if red==0
                            raw_zstackR=uint8(zeros(size(zstacknorm)));
                            interp_zstackR2=[];
                        end

                        if green==0
                            zstackG=uint8(zeros(size(zstacknorm)));
                            interp_zstackG=[];
                            interp_zstackG2=[];
                            zstack_paintdG=uint8(zeros(size(zstacknormcrop)));
                        end

                        if blue==0
                            raw_zstackB=uint8(zeros(size(zstacknorm)));
                            zstack_paintdB=uint8(zeros(size(zstacknormcrop)));
                            zstack_map_sizeB=zeros(size(zstacknormcrop),'uint8');
                            zstack_map_sizeB(zstacknormcrop==0)=255;

                            interp_zstackB=[];
                        end

                        clear IntR IntG IntB CorIntR CorIntG CorIntB

                        IntFilt=downsample(Int,100);
                        PXRdFilt=downsample(PXRd,100);
                        PYRdFilt=downsample(PYRd,100);
                        PZRdFilt=downsample(PZRd,100);

                        TrTime=(1:length(IntFilt))./1000;

                        AutogenTrImAvizoProjectUnified(vidfdate,vidfID,PXRdFilt,PYRdFilt,PZRdFilt,TrTime,zstack_paintdR,excrop,eycrop,ezcrop,[],1,BWVolR_close) %Generate Amira-Avizo Script for 3D Visualization

                        RGBrawstack=cat(5, uint8(255.*imadjustn(rescale(zstackR,'InputMin',0),stretchlim(rescale(zstackR(zstackR>0),'InputMin',0),[0 hiR]),[],gammaR)), uint8(255.*imadjustn(rescale(zstackG,'InputMin',0),stretchlim(rescale(zstackG(zstackG>-1),'InputMin',0),[0 hiG]),[],gammaG)), raw_zstackB); %cat(4, raw_zstackR(:,:,nz,:), raw_zstackG(:,:,nz,:), raw_zstackB(:,:,nz,:));
                        RGBImFinal=cat(5, zstack_paintdR, zstack_paintdG, zstack_paintdB); %cat(4, zstack_paintdR(:,:,nz,:), zstack_paintdG(:,:,nz,:), zstack_paintdB(:,:,nz,:));
                        RGBAltFinal=cat(5, uint8(255.*imadjustn(rescale(zstackR(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:),'InputMin',0),stretchlim(rescale(zstackR(zstackR>0),'InputMin',0),[0 hiR]),[],gammaR)), uint8(255.*imadjustn(rescale(zstackG(globalextrema(3):globalextrema(4),globalextrema(1):globalextrema(2),globalextrema(5):globalextrema(6),:),'InputMin',0),stretchlim(rescale(zstackG(zstackG>-1),'InputMin',0),[0 hiG]),[],gammaG)), zstack_map_sizeB);
                        RGBrawstack=permute(RGBrawstack,[1 2 3 5 4]);
                        RGBImFinal=permute(RGBImFinal,[1 2 3 5 4]);
                        RGBAltFinal=permute(RGBAltFinal,[1 2 3 5 4]);
                        trxcenter= find(excrop<=median(PXRd),1,'last');
                        trycenter= find(eycrop>=median(PYRd),1,'last');
                        RGBMIPFinal=cat(4, squeeze(mip(zstack_paintdR,3)),squeeze(mip(zstack_paintdG,3)),squeeze(mip(zstack_paintdB,3)));
                        RGBMIPFinal(trycenter-1:trycenter+1,trxcenter,:,2:3)=255;
                        RGBMIPFinal(trycenter,trxcenter-1:trxcenter+1,:,2:3)=255;

                        RGBMIPFinal=permute(RGBMIPFinal,[1 2 4 3]);

                        for volnum=1:size(RGBMIPFinal,4)
                            ImTimeStr=sprintf('%0.2f',ImTime(volnum,1));
                            ImTimePrevStr=sprintf('%0.2f',ImTime(volnum,2));
                            MIPlabel=['Vol ' num2str(volnum) ' - ' ImTimePrevStr ' (s) : ' ImTimeStr ' (s) - ' num2str(FPV(volnum)) ' FPV - ' num2str(Zrange(volnum)) ' um Z-Travel'];
                            RGBMIPFinal(:,:,:,volnum)=insertText(RGBMIPFinal(:,:,:,volnum),[10 10],MIPlabel,'FontSize',18);

                        end

                        %% SAVE IMAGING FIGURES

                        saveVidMIP_local(RGBMIPFinal,vidfdate,vidfID,'Time Series',[],[])
                        stack2agif_local(vidfID,RGBMIPFinal) %stack2agif_local currently only works for 4D... can I fix this?

                        for volnum=1:size(RGBMIPFinal,4)
                            mkdir(['Vol ' num2str(volnum)])
                            cd(['Vol ' num2str(volnum)])
                            ImTimeStr=sprintf('%0.2f',ImTime(volnum,1));
                            ImTimePrevStr=sprintf('%0.2f',ImTime(volnum,2));
                            saveVid4DTrIm_local(RGBImFinal(:,:,:,:,volnum),['Painted Stack Volume ' num2str(volnum)])
                            saveVid4DTrIm_local(RGBrawstack(:,:,:,:,volnum),['RAW Image Stack Volume ' num2str(volnum) ' - ' ImTimePrevStr 's to ' ImTimeStr 's'])
                            saveVid4DTrIm_local(RGBAltFinal(:,:,:,:,volnum),['RGB Image Map Stack Volume ' num2str(volnum) ' - ' ImTimePrevStr 's to ' ImTimeStr 's'])
                            stack2agif_local([vidfdate ' ' vidfID  ' Volume #' num2str(volnum) ' - ' ImTimePrevStr 's to ' ImTimeStr 's' ' Final RGB Image.gif'],RGBImFinal(:,:,:,:,volnum));
                            stack2agif_local([vidfdate ' ' vidfID  ' Volume #' num2str(volnum) ' - ' ImTimePrevStr 's to ' ImTimeStr 's' ' Raw RGB Image.gif'],RGBrawstack(:,:,:,:,volnum));
                            stack2agif_local([vidfdate ' ' vidfID  ' Volume #' num2str(volnum) ' - ' ImTimePrevStr 's to ' ImTimeStr 's' ' Map RGB Image.gif'],RGBAltFinal(:,:,:,:,volnum));

                            cd('..')
                        end


                        %% SAVE TRACKING FIGURES

                        saveDataName2=[savesubdir '\' num2str(volsize) ' FPV Processed Data.mat'];
                        save(saveDataName2,'red','green','TrTime','savedir','vidpname','system_params','zstackR_sd','interp_zstackR','interp_zstackR2','interp_zstackG2','interp_zstackG','Zrange','FPV','planefill','linefill','pxfill','globalextrema','localextrema','localextremafill','localsizez','localsizey','localsizex','zstacknormcrop','ezcrop','eycrop','excrop','PXRdFilt','PYRdFilt','PZRdFilt','PXRd','PYRd','PZRd','Int','dirname','ex','ey','ez','SZ','zstack_map_sizeB','vidfdate','zstack_paintdG','zstack_paintdB','vidfname','vidfID','zstack_paintdR','RGBMIPFinal','RGBrawstack','RGBImFinal','RGBMIPFinal','RGBAltFinal','IntFilt','zstackR','zstackG','zstackB','zstacknorm','ImTime','zstack_paintdR_TopHat','BWVolR_close','BWVolR_close3D');


                        %% SAVE FIGURES

                        hScatter=figure;
                        hMSD=figure;
                        hInt2=figure;
                        hX=figure;
                        hY=figure;
                        hZ=figure;
                        hTrImVol=figure;
                        set(hTrImVol,'Renderer','OpenGL')

                        [~,~,c]=ind2sub(size(zstack_paintdR),find(zstack_paintdR>0));

                        hInt2=figure;
                        %Intensity
                        plot(TrTime,IntFilt,'r')
                        figureandaxiscolors('k','w',dirname);
                        hLegend=legend('Intensity');
                        xlabel('Time [sec]')
                        ylabel('Intensity [counts/sec]')
                        set(hLegend,'Color','w');
                        hInt2.PaperPosition=[0 0 14.4 14.4];
                        drawnow
                        FormatAndSaveFigures(hInt2,savesubdir,'Intensity Image')
                        close(hInt2)


                        %Generate 3D plot
                        set(0,'CurrentFigure',hScatter);
                        traj3D(PXRdFilt,PYRdFilt,PZRdFilt);
                        axis image
                        view(3)
                        xlabel('X [\mum]');
                        ylabel('Y [\mum]');
                        zlabel('Z [\mum]');
                        figureandaxiscolors('k','w',dirname);
                        hScatter.PaperPosition=[0 0 14.4 14.4];
                        drawnow
                        FormatAndSaveFigures(hScatter,savesubdir,'Trajectory')
                        close(hScatter)

                        %Generate X plot
                        hX=figure;
                        set(0,'CurrentFigure',hX)
                        plot(TrTime,PXRdFilt);
                        axis square
                        %         ylim([0 78]);
                        xlabel('Time [sec]');
                        ylabel('X [\mum]');
                        figureandaxiscolors('k','w',dirname);
                        hX.PaperPosition=[0 0 14.4 14.4];
                        drawnow
                        FormatAndSaveFigures(hX,savesubdir,'X')
                        close(hX)

                        %Generate Y plot
                        hY=figure;
                        set(0,'CurrentFigure',hY)
                        plot(TrTime,PYRdFilt);
                        axis square
                        %         ylim([0 78]);
                        xlabel('Time [sec]');
                        ylabel('Y [\mum]');
                        figureandaxiscolors('k','w',dirname);
                        hY.PaperPosition=[0 0 14.4 14.4];
                        drawnow
                        FormatAndSaveFigures(hY,savesubdir,'Y')
                        close(hY)

                        %Generate Z plot
                        hZ=figure;
                        set(0,'CurrentFigure',hZ);
                        hZ.PaperPosition=[0 0 14.4 14.4];
                        yyaxis left
                        plot(TrTime,PZRdFilt,'-b');
                        axis square
                        xlabel('Time [sec]');
                        ylabel('Z [\mum]');
                        figureandaxiscolors('k','w',dirname);

                        yyaxis right
                        hold on
                        plot(FrTime,perfrint,'.','LineStyle','none','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',30)
                        plot(ImTime(:,1),pervolint,'.','LineStyle','none','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',30)
                        ylabel('Sum VID1 Intensity')
                        xt=xlim;
                        xt(1)=0;
                        xlim(xt);
                        hleg=legend('Z Piezo','\Sigma Int Fr ','\Sigma Int Vol');
                        yyaxis left
                        drawnow
                        FormatAndSaveFigures(hZ,savesubdir,'Z')
                        close(hZ)

                        clear excrop eycrop ezcrop globalextrema localextremafill planetest linetest planefill nx ny nz linefill pxtest pxfill globalextrema localextrema PXRdFilt PYRdFilt PZRdFilt PXRd PYRd PZRd Int IntFilt PiezoXRead PiezoYRead PiezoZRead trackData xcoord ycoord zcoord  almap zstackR_t hV LinearRegime zcoordvol ycoordvol xcoordvol frind zstackpad ETLPDratshift ETLPDshift ex exret ey eyret ez ezret interp_zstackB interp_zstackR interp_zstackG IntG iTrack iVid PDdiffshift raw_zstackB raw_zstackG raw_zstackG raw_zstackR raw_zstackR REFPDshift RGBAltFinal RGBMIPFinal RGBrawstack tempInterpIndex tempInterpPos tempVidDataT TESTPDratshift TESTPDshift trackInt trackPix trackPos val vidIndex vidPos vidX vidY vidZ xcoordtrack ycoordtrack zcoordtrack t_ms int x y z msd time2 zpos zposadj Zstack_8G zstack_paintdB zstack_paintdR zstack_paintdG zstackB zstackG zstackR zstack_map_sizeB zstackG zstacknorm RGBAltFinal RGBrawstack zstack_paintdR_TopHat BWVolR_denoise BWVolR_close BWVolR_close3D

                    end
                end

            end
        end
        close all
        clear localextremafill emptyplanes planefill XX YY ZZ ImTime ETLPDratshift ETLPDshift ex exret ey eyret ez ezret interp_zstackB interp_zstackR interp_zstackG IntG iTrack iVid PDdiffshift raw_zstackB raw_zstackG raw_zstackG raw_zstackR raw_zstackR REFPDshift RGBAltFinal RGBImFinal RGBMIPFinal RGBrawstack tempInterpIndex tempInterpPos tempVidDataT TESTPDratshift TESTPDshift PZRdFilt trackInt trackPix trackPos val vidIndex vidPos vidX vidY vidZ xcoordtrack ycoordtrack zcoordtrack t_ms int TrTime x y z msd time2 zpos zposadj Zstack_8G zstack_paintdB zstack_paintdR zstack_paintdG zstackB zstackG zstackR zstack_map_sizeB zstackG zstacknorm RGBAltFinal RGBImFinal RGBrawstack zstack_paintdR_TopHat BWVolR_denoise BWVolR_close BWVolR_close3D
        %         cd('..')
    end
    waitbar(q/neltdms,qWait)
end

close(qWait)
if runCP==1
    [~,~,~,~,~,~]=ProcessChangePoint_final([mainpname '\' mainsavedir]);
end

function saveVidMIP_local(RGBIm,vidfdate,vidftrunc,stackname,Sample_Type,Dye_RGB)

nMax=size(RGBIm,4);
dirname=stackname;
mkdir(dirname)
cd(dirname)

for index=1:nMax
    RGBtemp=RGBIm(:,:,:,index);
    imwrite(squeeze(RGBtemp),[stackname ' ' 'Slice #  ' num2str(index) '.png'],'png')
    clear RGBtemp
end
cd('..')
close
end

function stack2agif_local(vidftrunc,RGBIm)

if size(RGBIm,3)~=3
    RGBIm=permute(RGBIm,[1 2 4 3]);
end
RGBIm=squeeze(RGBIm);
nT=size(RGBIm,4);

for T=1:nT
    tempim=RGBIm(:,:,:,T);
    [imindVol,cmVol] = rgb2ind(tempim,256);
    if T == 1
        imwrite(imindVol,cmVol,[vidftrunc '.gif'],'gif', 'Loopcount',1,'DelayTime',0.4);
    else
        imwrite(imindVol,cmVol,[vidftrunc '.gif'],'gif','WriteMode','append','DelayTime',0.4);
    end
end
end

function saveVid4DTrIm_local(RGBIm,stackname)

nMax=size(RGBIm,3);
mkdir(stackname)
cd(stackname)

for index=1:nMax
    RGBtemp=RGBIm(:,:,index,:);
    imwrite(squeeze(RGBtemp),[stackname ' ' 'Slice #  ' num2str(index) '.png'],'png')
    clear RGBtemp
end
cd('..')
end



