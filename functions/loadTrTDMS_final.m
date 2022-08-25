function [PiezoXRead,PiezoYRead,PiezoZRead,trackInt,trackLPF,trackPx,trackLn,trackFr]=loadTrTDMS_final(trfname,clipfactor)
disp('Loading Track TDMS')
xconv=(1/32767*76.213);
yconv=(1/32767*76.555);
zconv=(1/32767*50.942);
tdms_struct = TDMS_getStruct(trfname);
disp('Track Data Loaded')
fn = fieldnames(tdms_struct);
tempTrackData=tdms_struct.(fn{2});
clear tdms_struct


%Convert stage positions to nm

PiezoXRead=double(tempTrackData.X_readout__bits_.data)*xconv; %x piezo readout
PiezoYRead=double(tempTrackData.Y_readout__bits_.data)*yconv; %y piezo readout
PiezoZRead=double(tempTrackData.Z_readout__bits_.data)*zconv; %z piezo readout

PiezoXCmd=double(tempTrackData.X_control__bits_.data)*xconv; %x piezo control
PiezoYCmd=double(tempTrackData.Y_control__bits_.data)*yconv; %y piezo control

trackInt=tempTrackData.Intensity__Hz_.data; %intensity

trackLn=double(tempTrackData.Line.data);
trackPx=double(tempTrackData.Pixel.data);
trackFr=double(tempTrackData.Frame.data);
trackLPF=trackLn+trackPx*1e3+trackFr*1e6;

clear tempTrackData

if max(PiezoXRead)==76.2130
    cmdsatcurveX=54.7774;
    Xkey=find(PiezoXRead==76.2130); %Find all points with saturated readout
    dcmdX=PiezoXCmd(min(Xkey))-cmdsatcurveX; %Adjust the command value of saturated points to scale to the curve
    adjcmdX=PiezoXCmd(Xkey)-dcmdX; %shift command values to curve
    PiezoXRead(Xkey)=0.7301.*adjcmdX+36.22; %Calibrate
    clear Xkey dcmdX adjcmdX cmdsatcurveX
end

if max(PiezoYRead)==76.5550
    cmdsatcurveY=59.4975;
    Ykey=find(PiezoYRead==76.5550);
    dcmdY=PiezoYCmd(min(Ykey))-cmdsatcurveY;
    adjcmdY=PiezoYCmd(Ykey)-dcmdY;
    PiezoYRead(Ykey)=0.6865.*adjcmdY+35.71;
    clear Ykey dcmdY adjcmdY cmdsatcurveY
end

PiezoXRead=PiezoXRead(clipfactor:end-clipfactor);
PiezoYRead=PiezoYRead(clipfactor:end-clipfactor);
PiezoZRead=PiezoZRead(clipfactor:end-clipfactor);
trackInt=trackInt(clipfactor:end-clipfactor);
trackLPF=trackLPF(clipfactor:end-clipfactor);
trackPx=trackPx(clipfactor:end-clipfactor);
trackLn=trackLn(clipfactor:end-clipfactor);
trackFr=trackFr(clipfactor:end-clipfactor);
disp('Loading Track TDMS Complete')
end