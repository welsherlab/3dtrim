function FormatAndSaveFigures(hFig,dirname,savename)

%Standardizes format of figures and saves as .fig and .png

figure(hFig)
hFig.InvertHardcopy = 'off';
set(hFig,'WindowStyle','normal')
set(hFig,'Units','inches')

cd(dirname)

axlist=findobj(gcf,'Type','Axes');
plotlist=findall(gcf,'Type','Line');
scatlist=findall(gcf,'Type','Scatter');
typelist=findall(gcf,'Type','Text');
leglist=findall(gcf,'Type','Legend');
cbarlist=findall(gcf,'Type','Colorbar');

for j=1:length(axlist)
    axlist(j).Box='on';
    axlist(j).GridAlpha=1;
    axlist(j).FontName='Helvetica';
    axlist(j).LineWidth=2;
    axlist(j).LabelFontSizeMultiplier=1.0;
end

%% Screen Figures

    for j=1:length(axlist)
        axlist(j).FontSize=20;
        axlist(j).TitleFontSizeMultiplier=1.0;
    end

    for q=1:length(plotlist)
        plotlist(q).LineWidth=2;
    end

    for k=1:length(scatlist)
        scatlist(k).SizeData=80; %3; %Normally 80
    end

    for i=1:length(typelist)
        typelist(i).FontSize=14;
        if length(typelist(1).String)>30
            typestring=typelist(1).String;
            cut=strfind(typestring,' ');
            cutnum=cut(cut>24);
            typelist(1).String={typestring(1:cutnum),typestring(cutnum+1:end)};
        end
    end


    for m=1:length(leglist)
        leglist(m).FontSize=16;
        leglist(m).LineWidth=2;
        leglist(m).Location='Best';
    end

    for n=1:length(cbarlist)
        cbarlist(n).LineWidth=2;
        cbarlist(n).FontSize=16;
    end

    pause(1)

    set(hFig,'Position',[0 0 12 12]) %12 12?

    hFig.PaperPositionMode='auto';
    hFig.PaperPosition=[0 0 12 12]; %Was 6 6
    drawnow

    hFig.Color =[1 1 1] ; %'k';

    for j=1:length(axlist)

        axlist(j).XColor=[0 0 0];
        axlist(j).YColor=[0 0 0];
        axlist(j).ZColor=[0 0 0];
        axlist(j).Color=[1 1 1];
        axlist(j).GridColor=[0.8 0.8 0.8] ;
    end

    for i=1:length(typelist)
        typelist(i).Color='k';
    end

    for m=1:length(leglist)
        leglist(m).Color='w';
        leglist(m).TextColor='k';
        leglist(m).EdgeColor='k';
    end

    for n=1:length(cbarlist)
        cbarlist(n).Color='k';
        cbarlist(n).EdgeColor='k';
    end
    drawnow
    savename_swt=[savename]  ;
    saveas(hFig,[savename_swt '.fig']) %Save .fig
    print([savename_swt '.png'],'-dpng', '-r300') %Save .png HQ

end