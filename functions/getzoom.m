function zoomfactor=getzoom(vidfname)
[filepath,name,~] = fileparts(vidfname);
strippedpath=strsplit(filepath,filesep);
% strippedpath=strippedpath(1:end-1);
Rootpath = char(join(string(strippedpath),filesep));
vidID=name(8:21);
ParamsFile=dir([Rootpath '\**\* ' vidID '*Imaging Parameters.txt']);

fid= fopen([ParamsFile.folder filesep ParamsFile.name],'r');
if fid~=-1
    linenum = 8;
    C = textscan(fid,'%*c%*c%*c%*c%f',1,'delimiter','\n', 'headerlines',linenum-1);
    zoomfactor=C{1};
    fclose(fid);
    if isempty(zoomfactor)
        zoomfactor=1.5;
    end
else
    zoomfactor=1.5;


end
end

%% OG File %%
% % % function zoomfactor=getzoom(vidfname)
% % %    fid= fopen([vidfname(1:end-5) ' Imaging Parameters.txt'],'r');
% % %    if fid~=-1
% % %    linenum = 9;
% % %  C = textscan(fid,'%*c%*c%*c%*c%f',1,'delimiter','\n', 'headerlines',linenum-1);
% % %  zoomfactor=C{1};
% % %  fclose(fid);
% % %    else
% % %        zoomfactor=1.5;
% % %
% % %
% % %  end
% % % end