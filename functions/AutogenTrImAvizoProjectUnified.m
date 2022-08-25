%GOAL: Avizo script auto generator should generate HUNDREDS of lines of
%code and write to text file with parameters varying by experiment.

function AutogenTrImAvizoProjectUnified(vidfdate,vidfID,PXRdFilt,PYRdFilt,PZRdFilt,TrTime,zstack_paintdR,excrop,eycrop,ezcrop,traj,fixednumsegstraj,labelvol)

%TEST BRANCH: 
% [] Add variable input TOP HAT. 
% [] If TOP HAT, generate LABEL FIELD data in new directory
% [] If TOP HAT, add load command to project
% [] If TOP HAT, generate and display ISOSURFACE of label field and
% DISTANCE MAP WITH RENDER
% [] Generate .vol.am files instead of .vol binary. Adjust project script
% accordingly. Use internal function for this scriptgen since short
% [] 

vidfID=strrep(vidfID,'.','');
vname="";

if size(zstack_paintdR,4)>1
    VidTS=1;
    voldirname='\Vol Bin TS\';
    mkdir(['Avizo\' voldirname(2:end)])
else
    VidTS=0;
    voldirname="";
end
globalvoldirname='\Vol Bin Global\';

if ~isempty(traj)
    CPTrajMat=GenerateCPTrajMat(traj,PXRdFilt,PYRdFilt,PZRdFilt);
    CPtraj=1;
    trajdirname='\Traj CSV CP\';
    spheredirname='\Sphere CSV CP\';
else
    CPTrajMat=[];
    CPtraj=0;
    trajdirname='\Traj CSV\';
    spheredirname='\Sphere CSV\';
end

if ~isempty(labelvol)
    labelvolpres=1;
    labeldirname='\Label Vol\';

    mkdir(['Avizo\' labeldirname(2:end)])
    
    if VidTS==1
        labelTSdirname='\Label Vol TS\';
        mkdir(['Avizo\' labelTSdirname(2:end)])
    end
    else
    labelvolpres=0;

end


mkdir(['Avizo\' globalvoldirname(2:end)])
mkdir(['Avizo\' trajdirname(2:end)])
mkdir(['Avizo\' spheredirname(2:end)])

%% EXPORT VOLUME
volheaderstring=genvolheader(excrop,eycrop,ezcrop,zstack_paintdR);

if VidTS==1
    for volnum=1:size(zstack_paintdR,4)
        ImName=([vidfdate ' ' vidfID ' Volume ' num2str(volnum)]);
        ImExt=' -RED.vol.am';
        fID=fopen([pwd '\Avizo\' voldirname ImName ImExt],'w','l','windows-1252');
        fprintf(fID,'%s\n',volheaderstring{:});
        fclose(fID);

        fID=fopen([pwd '\Avizo\' voldirname ImName ImExt],'a','l');
        fwrite(fID,uint8(permute(zstack_paintdR(:,:,:,volnum),[2 1 3])),'uint8');
        fclose(fID);
        vname(volnum)=string([ImName ImExt]);
    end
end

ImName=([vidfdate ' ' vidfID ' Time MIP']);
ImExt=' -RED.vol.am';
fID=fopen([pwd '\Avizo\' globalvoldirname ImName ImExt],'w','l','windows-1252');
fprintf(fID,'%s\n',volheaderstring{:});
fclose(fID);
        
fID=fopen([pwd '\Avizo\' globalvoldirname ImName ImExt],'a','l');
fwrite(fID,uint8(permute(max(zstack_paintdR,[],4),[2 1 3])),'uint8');
fclose(fID);
vnameglob=string([ImName ImExt]);

if isempty(fixednumsegstraj)
    seglength=ceil(length(CPTrajMat(:,5))./11); %Basically numseg
else
    seglength=fixednumsegstraj;
end

if CPtraj==1
    segnum=floor(linspace(1,seglength,length(CPTrajMat(:,5)))); %Basically segidx
else
    segnum=floor(linspace(1,seglength,length(TrTime))); %Basically segidx
end

%% EXPORT LABEL 

if labelvolpres==1
   labelheaderstring=genlabelvolheader(excrop,eycrop,ezcrop,labelvol) ;
   
    if VidTS==1
    for volnum=1:size(labelvol,4) %size(zstack_paintdR,4)
        ImName=([vidfdate ' ' vidfID ' Label Volume ' num2str(volnum)]);
        ImExt=' -.label.am';
        fID=fopen([pwd '\Avizo\' labelTSdirname ImName ImExt],'w','l','windows-1252');
        fprintf(fID,'%s\n',labelheaderstring{:}); %%s = string, \n means each element in string array is on new line
        fclose(fID);

        
        fID=fopen([pwd '\Avizo\' labelTSdirname ImName ImExt],'a','l'); %	'windows-1252' = ANSI, seems to be the encoding for .am amira
        fwrite(fID,uint8(permute(labelvol(:,:,:,volnum),[2 1 3])),'uint8');
        fclose(fID);
        lname(volnum)=string([ImName ImExt]);
    end
end

ImName=([vidfdate ' ' vidfID ' Time MIP']);
ImExt=' -label.am';
fID=fopen([pwd '\Avizo\' labeldirname ImName ImExt],'w','l','windows-1252');
 fprintf(fID,'%s\n',labelheaderstring{:}); %%s = string, \n means each element in string array is on new line
 
 
fID=fopen([pwd '\Avizo\' labeldirname ImName ImExt],'a','l');
fwrite(fID,uint8(permute(max(labelvol,[],4),[2 1 3])),'uint8');
fclose(fID);
lnameglob=string([ImName ImExt]);
else
    lname=[];
    lnameglob=[];
    labeldirname=[];
    labelTSdirname=[];
 
end
%% EXPORT TRAJECTORY

hWait = waitbar(0,'Exporting Trajectory');
if CPtraj==1
    CPtime=CPTrajMat(:,5);
    
    for seg=1:max(segnum)
        
        idx=find(segnum<=seg);
        CPTrajMat2=CPTrajMat(segnum<=seg,:);
        writematrix(CPTrajMat2,[pwd '\Avizo\' trajdirname vidfdate ' ' vidfID(9:end) ' TrajSeg ' sprintf('%03d',seg) '.csv']);
        tname(seg)=string([vidfdate ' ' vidfID(9:end) ' TrajSeg ' sprintf('%03d',seg) '.csv']);
        
        spherematTS=CPTrajMat(idx(end),:);
        writematrix(spherematTS,[pwd '\Avizo\' spheredirname vidfdate ' ' vidfID(9:end) ' SphereSeg ' sprintf('%03d',seg) '.csv']);
        sname(seg)=string([vidfdate ' ' vidfID(9:end) ' SphereSeg ' sprintf('%03d',seg) '.csv']);
        
        waitbar(seg/max(segnum),hWait)
    end
    
else
    
    for seg=1:max(segnum) %1:max(segnum)
        
        idx=find(segnum<=seg);
        trajmatTS=[PXRdFilt(segnum<=seg)' PYRdFilt(segnum<=seg)' PZRdFilt(segnum<=seg)' TrTime(segnum<=seg)' segnum(segnum<=seg)'];
        writematrix(trajmatTS,[pwd '\Avizo\' trajdirname vidfdate ' ' vidfID(9:end) ' TrajSeg ' sprintf('%03d',seg) '.csv']);
        tname(seg)=string([vidfdate ' ' vidfID(9:end) ' TrajSeg ' sprintf('%03d',seg) '.csv']);
        
        spherematTS=[PXRdFilt(idx(end)) PYRdFilt(idx(end)) PZRdFilt(idx(end)) TrTime(idx(end)) segnum(idx(end))];
        writematrix(spherematTS,[pwd '\Avizo\' spheredirname vidfdate ' ' vidfID(9:end) ' SphereSeg ' sprintf('%03d',seg) '.csv']);
        sname(seg)=string([vidfdate ' ' vidfID(9:end) ' SphereSeg ' sprintf('%03d',seg) '.csv']);
       
        waitbar(seg/max(segnum),hWait)
    end
    
end
close(hWait)


%% GENERATE AVIZO PROJECT SCRIPT

[~,medX]=min(abs(excrop-median(PXRdFilt)));
[~,medY]=min(abs(eycrop-median(PYRdFilt)));
[~,medZ]=min(abs(ezcrop-median(PZRdFilt)));

medloc=[string(medX) string(medY) string(medZ)];

voldatasize=size(permute(zstack_paintdR(:,:,:,1),[2 1 3]));
if CPtraj==1
    projname='AvizoScriptAutogenCP.hx';
else
    projname='AvizoScriptAutogen.hx';
end
textfilename=[pwd '\Avizo\' vidfdate ' ' vidfID ' ' projname]; %savedir \
scriptstring=AvizoTrImTemplateUnified(voldatasize,vname,vnameglob,tname,sname,lnameglob,labeldirname,excrop,eycrop,ezcrop,TrTime(end),CPtraj,voldirname,globalvoldirname,trajdirname,spheredirname,medloc);
Autogenscript = fopen(textfilename,'w');
fprintf(Autogenscript,'%s\n',scriptstring{:}); %%s = string, \n means each element in string array is on new line
fclose(Autogenscript);


end

function labelheaderstring=genlabelvolheader(excrop,eycrop,ezcrop,labelvol)
qq=sprintf('%s',34); % "
linebreak=sprintf('\r'); %return key 
volsize=size(labelvol);
xsize=string(volsize(2));
ysize=string(volsize(1));
zsize=string(volsize(3));
xmin=string(excrop(1));
ymin=string(eycrop(1));
zmin=string(ezcrop(1));
xmax=string(excrop(end));
ymax=string(eycrop(end));
zmax=string(ezcrop(end));

labelheaderstring=[ ...
    
"# AmiraMesh BINARY-LITTLE-ENDIAN 3.0" ...
    
    "# Dimensions in x-, y-, and z-direction" ...
    
    strcat("define Lattice ",xsize," ",ysize," ",zsize) ...

    "Parameters {" ...
    
    "Materials {" ...
    
    "Extracellular Space {" ...
    
    "Id 0" ...
    
    "}" ...
    
    "Cell {" ...
    
    "Id 1" ...
    
    "}" ...
    
    "}" ...
        
    strcat("Content ",qq,xsize,"x",ysize,"x",zsize," byte, uniform coordinates",qq,",") ...
    
       strcat(" CoordType ",qq,"uniform",qq,",") ...
        
       "# Bounding Box is xmin xmax ymin ymax zmin zmax" ...
       
        strcat("BoundingBox ",xmin," ",xmax," ",ymin," ",ymax," ",zmin," ",zmax)  ...
        
    "}" ...
    
linebreak...
    
"Lattice { byte Labels } @1" ...

    linebreak ...
    
    "# Data section follows" ...
    
    "@1" ...
    
    ];
end

function volheaderstring=genvolheader(excrop,eycrop,ezcrop,zstack_paintdR)
qq=sprintf('%s',34); % "
linebreak=sprintf('\r'); %return key 
volsize=size(zstack_paintdR);
xsize=string(volsize(2));
ysize=string(volsize(1));
zsize=string(volsize(3));
xmin=string(excrop(1));
ymin=string(eycrop(1));
zmin=string(ezcrop(1));
xmax=string(excrop(end));
ymax=string(eycrop(end));
zmax=string(ezcrop(end));

volheaderstring=[ ...
    
"# AmiraMesh BINARY-LITTLE-ENDIAN 3.0" ...
    
    "# Dimensions in x-, y-, and z-direction" ...
    
    strcat("define Lattice ",xsize," ",ysize," ",zsize) ...

    "Parameters {" ...
    
    strcat("Content ",qq,xsize,"x",ysize,"x",zsize," byte, uniform coordinates",qq,",") ...
    
       strcat(" CoordType ",qq,"uniform",qq,",") ...
        
       "# Bounding Box is xmin xmax ymin ymax zmin zmax" ...
       
        strcat("BoundingBox ",xmin," ",xmax," ",ymin," ",ymax," ",zmin," ",zmax)  ...
        
    "}" ...
    
linebreak...
    
"Lattice { byte Data } @1" ...

    linebreak ...
    
    "# Data section follows" ...
    
    "@1" ...
    
    ];
end