%This function calculates the distance to the surface of the cell given an
%CP segments and isosurface vertices

function trajStruct=approachCell_final(trajStruct,vertices,hCPcopy2,matfname,matpname3)

for i=1:length(trajStruct)
    if trajStruct(i).active
        tempX=trajStruct(i).x;
        tempY=trajStruct(i).y;
        tempZ=trajStruct(i).z;
        nel=length(tempX);
        temp=zeros(nel,1);
        tempIndex=zeros(nel,1);
        hWait=waitbar(0,'Getting distance vectors');
        for j=1:nel
            d=bsxfun(@minus,[tempX(j) tempY(j) tempZ(j)],vertices);
            r=sqrt(sum(d.^2,2));
            [a,b]=min(r);
            temp(j)=a;
            tempIndex(j)=b;
            waitbar(j/nel,hWait)
        end
        close(hWait);
        trajStruct(i).r=temp;
        trajStruct(i).vertices=vertices(tempIndex,:);
        
    end
end

figure(hCPcopy2); %go to isosurface figure
lineHandles=findobj(gca,'type','line');
delete(lineHandles);
colorbar 'off';

%generate colormap
maxDistance=25;
minDistance=1;
nelCMAP=length(minDistance:maxDistance);
cmap=jet(nelCMAP);

for i=1:length(trajStruct)
    if trajStruct(i).active
        tempX=trajStruct(i).x;
        tempY=trajStruct(i).y;
        tempZ=trajStruct(i).z;
        meanDistance=mean(trajStruct(i).r);
        coercedMeanDistance=min(max(meanDistance,minDistance),maxDistance);
        cmapIndex=round(coercedMeanDistance);
        h=plot3(tempX,tempY,tempZ);
        h.Color=cmap(cmapIndex,:);
        hScat=scatter3(trajStruct(i).vertices(:,1),trajStruct(i).vertices(:,2),trajStruct(i).vertices(:,3));
        hScat.CData=cmap(cmapIndex,:);
        hScat.MarkerFaceColor='flat';
        
    end
end

    view(3); 
    title([matfname(1:22) ' Approach Cell'],'Fontsize',10,'Interpreter', 'none');    
    figCPcopy2name=[matpname3 ' approachCellTraj iso view3' '.fig'];
    saveas(hCPcopy2,figCPcopy2name,'fig');
    pngCPcopy2Name=[matpname3 ' approachCellTraj iso view3' '.png'];
    print(pngCPcopy2Name,'-dpng');
    view(2);
    pngCPcopy2Name=[matpname3 ' approachCellTraj iso view2' '.png'];
    print(pngCPcopy2Name,'-dpng');
    view([90,0]);
    pngCPcopy2Name=[matpname3 ' approachCellTraj iso ZY' '.png'];
    print(pngCPcopy2Name,'-dpng');