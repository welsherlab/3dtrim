function system_params=gensysparams(varargin)

system_params=struct('minPixel',1,'minLine',1,'zoomfactor',1.5,'system_factor',12.77,'pixels_per_line',512,'magnification',100,'z_px_per_um',2,'fps',1.3845);
system_params.dpix=system_params.system_factor/system_params.pixels_per_line/system_params.magnification*1000/system_params.zoomfactor; %pixel size in microns
system_params.obj='Zeiss';
objType='Zeiss';
if nargin==1
   zoomfactor=getzoom(varargin{1});
   % objType=getobjlens(varargin{1});
   if isempty(zoomfactor)
   else
       system_params.zoomfactor=zoomfactor;
       % system_params.obj=objType;
   end
end

system_params.Xdpix=0.2753./system_params.zoomfactor;
system_params.Ydpix=0.2794./system_params.zoomfactor;

system_params.x_px_per_um=1/system_params.Xdpix; %number of pixels per micron
system_params.y_px_per_um=1/system_params.Ydpix; %number of pixels per micron
end
