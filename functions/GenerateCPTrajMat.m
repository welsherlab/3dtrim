function CPTrajMat=GenerateCPTrajMat(traj,PXRdFilt,PYRdFilt,PZRdFilt)

%% 210901 Jacks addition if no CP changes are found only one segment in traj struct
sz=size(traj,2);
if sz==1
    trajTable = struct2table(traj,'AsArray',true); %default wont create single row table
    rows = (trajTable.active==1); %find active segments
    activetrajTable=trajTable(rows,:);
    sortedactivetrajTable = sortrows(activetrajTable, 'minIndex'); % sort the table earliest segment to latest
    delta=.003;
    continuousPlot=[];
    sz=height(sortedactivetrajTable);
    i=1;
    continuousPlot(i).time=sortedactivetrajTable.minIndex(i)*delta:delta:(sortedactivetrajTable.minIndex(i)*delta)+((length(sortedactivetrajTable.x{i,1}))-1)*delta;
    continuousPlot(i).Drep=repmat(sortedactivetrajTable.D(i),length(sortedactivetrajTable.x{i,1}),1);


    continuousPlot(sz).time=continuousPlot(i).time(end)+delta:delta:(continuousPlot(i).time(end)+delta)+((length(sortedactivetrajTable.x{sz,1}))-1)*delta;
    continuousPlot(sz).Drep=repmat(sortedactivetrajTable.D(sz),length(sortedactivetrajTable.x{sz,1}),1);

    CPdiffcoeff=vertcat(continuousPlot.Drep);

    TrTimeCP=[continuousPlot.time];

    PXRdFiltCP=downsample(PXRdFilt,3);
    PYRdFiltCP=downsample(PYRdFilt,3);
    PZRdFiltCP=downsample(PZRdFilt,3);

    Xchk=iscolumn(PXRdFiltCP);
    Timechk=iscolumn(TrTimeCP);
    CPchk=iscolumn(CPdiffcoeff);

    if ~iscolumn(PXRdFiltCP)
        PXRdFiltCP=PXRdFiltCP';
        PYRdFiltCP=PYRdFiltCP';
        PZRdFiltCP=PZRdFiltCP';
    end

    if ~iscolumn(TrTimeCP)
        TrTimeCP=TrTimeCP';
    end

    if ~iscolumn(CPdiffcoeff)
        CPdiffcoeff=CPdiffcoeff';
    end


    CPTrajMat=[PXRdFiltCP PYRdFiltCP PZRdFiltCP TrTimeCP CPdiffcoeff];
else
    clear sz;
    %% Back to CJs original code
    trajTable = struct2table(traj(:,2:end)); %first row is the complete traj, ignore

    rows = (trajTable.active==1); %find active segments
    activetrajTable=trajTable(rows,:);
    sortedactivetrajTable = sortrows(activetrajTable, 'minIndex'); % sort the table earliest segment to latest
    delta=.003;
    continuousPlot=[];
    sz=height(sortedactivetrajTable);
    for i=1:height(sortedactivetrajTable)-1
        continuousPlot(i).time=sortedactivetrajTable.minIndex(i)*delta:delta:(sortedactivetrajTable.minIndex(i)*delta)+((length(sortedactivetrajTable.x{i,1}))-1)*delta;
        continuousPlot(i).Drep=repmat(sortedactivetrajTable.D(i),length(sortedactivetrajTable.x{i,1}),1);
    end

    continuousPlot(sz).time=continuousPlot(i).time(end)+delta:delta:(continuousPlot(i).time(end)+delta)+((length(sortedactivetrajTable.x{sz,1}))-1)*delta;
    continuousPlot(sz).Drep=repmat(sortedactivetrajTable.D(sz),length(sortedactivetrajTable.x{sz,1}),1);

    CPdiffcoeff=vertcat(continuousPlot.Drep);

    TrTimeCP=[continuousPlot.time];

    PXRdFiltCP=downsample(PXRdFilt,3);
    PYRdFiltCP=downsample(PYRdFilt,3);
    PZRdFiltCP=downsample(PZRdFilt,3);

    Xchk=iscolumn(PXRdFiltCP);
    Timechk=iscolumn(TrTimeCP);
    CPchk=iscolumn(CPdiffcoeff);

    if ~iscolumn(PXRdFiltCP)
        PXRdFiltCP=PXRdFiltCP';
        PYRdFiltCP=PYRdFiltCP';
        PZRdFiltCP=PZRdFiltCP';
    end

    if ~iscolumn(TrTimeCP)
        TrTimeCP=TrTimeCP';
    end

    if ~iscolumn(CPdiffcoeff)
        CPdiffcoeff=CPdiffcoeff';
    end




CPTrajMat=[PXRdFiltCP PYRdFiltCP PZRdFiltCP TrTimeCP CPdiffcoeff];
end



end