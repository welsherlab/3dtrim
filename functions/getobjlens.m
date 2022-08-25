function objType=getobjlens(vidfname)
objType = 'Nikon';
[filepath,name,~] = fileparts(vidfname);
strippedpath=strsplit(filepath,filesep);
% strippedpath=strippedpath(1:end-1);
Rootpath = char(join(string(strippedpath),filesep));
vidID=name(8:21);
ParamsFile=dir([Rootpath '\**\* ' vidID '*Imaging Parameters.txt']);

fid= fopen([ParamsFile.folder filesep ParamsFile.name],'r');
if fid~=-1
    linenum = 14;
    C = textscan(fid,'%s','delimiter',':', 'headerlines',linenum-1);
    if size(C{1,1},1)==1
        objType = 'Zeiss';
    else
        objType=C{1,1}{2,1};
    end
    fclose(fid);
end