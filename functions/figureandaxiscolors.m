function figureandaxiscolors(figurecolor,axiscolor,fname)
set(gcf,'Color',figurecolor)
hAxes=findobj(gcf,'type','axes');
set(hAxes,'XColor',axiscolor)
set(hAxes,'YColor',axiscolor)
set(hAxes,'ZColor',axiscolor)
set(hAxes,'Color',figurecolor)
for i=1:length(hAxes)
    set(get(hAxes(i),'xlabel'),'color',axiscolor)
    set(get(hAxes(i),'ylabel'),'color',axiscolor)
end
grid on
set(gcf,'InvertHardCopy','off')
hLeg=[];
hLeg=findobj(gcf,'tag','legend');
if ishandle(hLeg)
    set(hLeg,'TextColor',axiscolor);
end

if nargin==3
    [~,NAME,~] = fileparts(fname);
    title(NAME,'Color',axiscolor)
end