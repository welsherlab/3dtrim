function plotCP_final(traj)
% axes(hAxes);
trajCell = struct2cell(traj);
sz = size(trajCell);

% Convert to a matrix
trajCell = reshape(trajCell, sz(1), []);      % Px(MxN)
% Make each field a column
trajCell = trajCell';                         % (MxN)xP

%Find "active" sections of trajectory
[~,j]=find([trajCell{:,6}]==1);
trajCell=trajCell(j,:);

%Sort by D
if length(j)>1
    trajCell=sortrows(trajCell,7);
end
% restrict colorbar to help visualization 
maxD=2.0;
minD=0.002;
% or float colorbr based on min and max D values
% maxD=1.2*max(cell2mat(trajCell(:,6)));
% minD=0.8*min(cell2mat(trajCell(:,6)));
%Create color map
maxIndex=round((maxD-minD)*5000);
cmap=parula(maxIndex);
cmap(isnan(cmap))=0;
colormap(cmap);
hold on

for i=1:size(trajCell,1)
    tempX=cell2mat(trajCell(i,1));
    tempY=cell2mat(trajCell(i,2));
    tempZ=cell2mat(trajCell(i,3));
    hLine=plot3(tempX,tempY,tempZ);
    index=round(5000*(cell2mat(trajCell(i,7))-minD));
    if index>=maxIndex
        index=maxIndex;
    end
    if index==0
        index=1;
    end
    if index<1
        index=1;
    end
    if ~isnan(index)
        set(hLine,'Color',cmap(index,:));
    else
        set(hLine,'Color',cmap(1,:));
    end
end

view(3);
axis image

xlabel('X [\mum]');ylabel('Y [\mum]');zlabel('Z [\mum]');
hColorbar=colorbar;
hColorbar.Ruler.MinorTick = 'on';
hText=get(hColorbar,'YLabel');
set(hText,'string','D [\mum^2/sec]')
figureandaxiscolors('k','w');
hColorbar.Color=[1 1 1];
caxis([minD maxD])