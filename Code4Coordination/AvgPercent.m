%==========================================================================
%FUNCTION AVERAGE PERCENT PER CATEGORY
%Input value (condition) = the name of the struct you want to calculate
%mean percent per category from
%then graphs the result as a stacked bar graph
%Created by: Savanna-Rae Fahoum
%==========================================================================
function IndMeanData = AvgPercent(condition, xlbl)

%Calculate mean percent All Coordinated
AllCoorList = [];
for i_exps = 1:length(condition.exps)

    Num_AllCoor = condition.(condition.exps{i_exps}).All_Coor;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerAllCoor = (Num_AllCoor/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllCoordinated = PerAllCoor %How to add new field to each exp field
    AllCoorList = [AllCoorList; PerAllCoor];
end
    AvgPerAllCoor = mean(AllCoorList);

%Calculate mean percent All Uncoordinated
AllUncoorList = [];
for i_exps = 1:length(condition.exps)

    Num_AllUncoor = condition.(condition.exps{i_exps}).All_UnCoor;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerAllUncoor = (Num_AllUncoor/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    AllUncoorList = [AllUncoorList; PerAllUncoor];
end
    AvgPerAllUncoor = mean(AllUncoorList);

%Calculate mean percent One Uncoordinated
OneUncoorList = [];
for i_exps = 1:length(condition.exps)

    Num_OneUncoor = condition.(condition.exps{i_exps}).One_UnCoor;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerOneUncoor = (Num_OneUncoor/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    OneUncoorList = [OneUncoorList; PerOneUncoor];
end
    AvgPerOneUncoor = mean(OneUncoorList);

%Calculate mean percent One Tonic
OneTonicList = [];
for i_exps = 1:length(condition.exps)

    Num_OneTonic = condition.(condition.exps{i_exps}).One_Tonic;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerOneTonic = (Num_OneTonic/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    OneTonicList = [OneTonicList; PerOneTonic];
end
    AvgPerOneTonic = mean(OneTonicList);

%Calculate mean percent One Silent
OneSilentList = [];
for i_exps = 1:length(condition.exps)

    Num_OneSilent = condition.(condition.exps{i_exps}).One_Silent;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerOneSilent = (Num_OneSilent/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    OneSilentList = [OneSilentList; PerOneSilent];
end
    AvgPerOneSilent = mean(OneSilentList);

%Calculate mean percent All Tonic
AllTonicList = [];
for i_exps = 1:length(condition.exps)

    Num_AllTonic = condition.(condition.exps{i_exps}).All_Tonic;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerAllTonic = (Num_AllTonic/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    AllTonicList = [AllTonicList; PerAllTonic];
end
    AvgPerAllTonic = mean(AllTonicList);

%Calculate mean percent All Silent
AllSilentList = [];
for i_exps = 1:length(condition.exps)

    Num_AllSilent = condition.(condition.exps{i_exps}).All_Silent;
    ExpCycles = length(condition.(condition.exps{i_exps}).GMR_Category);
    PerAllSilent = (Num_AllSilent/ExpCycles)*100;
    %condition.(condition.exps{i_exps}).PercentAllUncoordinated = PerAllUncoor %How to add new field to each exp field
    AllSilentList = [AllSilentList; PerAllSilent];
end
    AvgPerAllSilent = mean(AllSilentList);

%Store the average percent per category in a field within the structure for
%the condition specified @ input
%condition.AvgPercentperCategory_GRAPH = [];
%condition.AvgPercentperCategory_GRAPH = [condition.AvgPercentperCategory_GRAPH; AvgPerAllCoor AvgPerOneUncoor AvgPerOneTonic AvgPerOneSilent AvgPerAllUncoor AvgPerAllTonic AvgPerAllSilent]

IndMeanData = ["All Coor" "All UnCoor" "One UnCoor" "One Tonic" "One Silent" "All Tonic" "All Silent"; AllCoorList AllUncoorList OneUncoorList OneTonicList OneSilentList AllTonicList AllSilentList];

DiffBars = [AvgPerAllCoor AvgPerOneUncoor AvgPerOneTonic AvgPerOneSilent AvgPerAllUncoor AvgPerAllTonic AvgPerAllSilent];

condition.AvgPercent_per_Category = DiffBars;

%GRAPH CATEGORIES
%convert NaN to zeroes
for i_DiffBar = 1:length(DiffBars)
    if isnan(DiffBars(i_DiffBar))
        DiffBars(i_DiffBar) = 0;
    end
end


%% plot stacked bar graph
figure;
x_label = categorical(xlbl);
%x_label = reordercats(x_label, {'SIF only' 'SIF:PTX'});
x3 = bar(x_label, DiffBars, 'stacked');
legend("All Coordinated", "One Neuron Uncoordinated", "One Neuron Tonic", "One Neuron Silent", "All Uncoordinated", "All Tonic", "All Silent")
ylabel("Mean % Category", 'FontSize', 16);

x3(1).FaceColor = [0.1 0.355 0.86]; %all coordinated
x3(2).FaceColor = [0.1 0.6 0.1]; %one neuron uncoordinated
x3(3).FaceColor = [0.4 0.8 0.4]; %one neuron tonic
x3(4).FaceColor = [0.3 1 0.5]; %one neuron silent
x3(5).FaceColor = [1 0.8 0]; %all uncoordinated
x3(6).FaceColor = [0.9 0.3 0.5]; %all tonic
x3(7).FaceColor = [1 0 0]; %all silent