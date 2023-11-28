%This script will be used to collect data from excel and plot param data
%across time. This script can also be written to include gathering
%descriptive statistics for each neuron, and this data graphed as well.

exps = ["srf092821" "srf021522" "srf021622" "srf022122" "srf022222" "srf030122" "srf040622" "srf041122" "srf051122" "srf042522"]; %list of experiments/sheet names to scan through to collect all the datums!
%NOTE THAT srf022222 and srf030122 have data from one neuron missing, IC
%and DG, respectively.

%"srf051221" "srf092721" <-- these were excluded
%due to SIF duration being less than 1200 s.
%^^^ need to put srf043021 back in here... not sure why, but that
%data from experiment is not getting extracted from excel file <-- oh,
%that's becasue you don't have LG data from LPG kill condition in srf043021

neuron = ["LG_" "IC_" "DG_"]; %hmmm...combine all three datasets (LPGkill, GMkill, SIFapp1/2) into this one script, or a separate script for each dataset?
param = ["BurstNum" "On" "BD" "numspk" "FF" "CP"];
cond = ["_LPGIntact" "_LPGKill"];

label = [];
%This for-loop takes the names in the above vectors and appends them
%together to make a vector containing all label names for all
%neurons/params/conditions.
for i_neu = 1:length(neuron)
    for i_param = 1:length(param)
        for i_cond = 1:length(cond)
            lbl = append(neuron(i_neu), param(i_param), cond(i_cond)); %to put all above names together into single labels that serve as headers in my excel file
            label = [label lbl]; %to concatenate all label names into an array

            %need to figure out how to deal with labels that are not present in an
            %excel sheet
        end
    end
end

for i_exp = 1:length(exps)
    xlData = readtable('GMRParameters_LPGIntactKill_MATLABFormat.xlsx', 'Sheet', (exps{i_exp}));

    %avg_stdev_stderr_cv = []; %calculated vaules from each neuron parameter will be stored in this empty matrix in the same order as the variable name
    for i_data = 1:length(label)

        avg_stdev_stderr_cv = []; %calculated vaules from each neuron parameter will be stored in this empty matrix in the same order as the variable name

        x = xlData.(label{i_data});
        LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}) = x(~isnan(x));

        if ~isempty(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data})) == 1 %to only calculate summary data if there are values associated with the label

            mn = mean(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}));
            stdev = std(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}));
            stderr = std(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}))/sqrt(length(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data})));
            cv = std(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}))/mean(LPGIntactvsKilled_Params.IndData.(exps{i_exp}).(label{i_data}));

            avg_stdev_stderr_cv = [avg_stdev_stderr_cv; exps(i_exp) mn stdev stderr cv];

            LPGIntactvsKilled_Params.EXP_AVG_STDev_STDErr_CVData.(label{i_data}).Summary(i_exp, 1:5) = avg_stdev_stderr_cv;
        end
    end
end

%% plotting individual data. I typed stuff out here... maybe in the future I
%can make this more concise.
for i_exp = 1:length(exps)
    figure;
    t = tiledlayout(4,2);
    t.Title.String = exps(i_exp);
    t.Title.FontWeight = 'bold';

    %plotting CP_LPGIntact
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGIntact(1:end-1);
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGIntact(1:end-1);
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGIntact(1:end-1);

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_CP_LPGIntact;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_CP_LPGIntact;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_CP_LPGIntact;

    ax1 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Cycle Period (s), LPG Intact')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting CP_LPGKill
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGKill(1:end-1);
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGKill(1:end-1);
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGKill(1:end-1);

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_CP_LPGKill;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_CP_LPGKill;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_CP_LPGKill;

    ax2 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Cycle Period (s), LPG Killed')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting BD_LPG Intact
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGIntact;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGIntact;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGIntact;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_BD_LPGIntact;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_BD_LPGIntact;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_BD_LPGIntact;

    ax3 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Burst Duration (s), LPG Intact')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting BD_LPGKill
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGKill;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGKill;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGKill;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_BD_LPGKill;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_BD_LPGKill;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_BD_LPGKill;

    ax4 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Cycle Period (s), LPG Killed')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting FF_LPG Intact
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGIntact;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGIntact;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGIntact;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_FF_LPGIntact;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_FF_LPGIntact;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_FF_LPGIntact;

    ax5 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Firing Frequency (Hz), LPG Intact')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting FF_LPGKill
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGKill;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGKill;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGKill;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_FF_LPGKill;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_FF_LPGKill;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_FF_LPGKill;

    ax6 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('Firing Frequency (Hz), LPG Killed')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting numspk_LPG Intact
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGIntact;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGIntact;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGIntact;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_numspk_LPGIntact;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_numspk_LPGIntact;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_numspk_LPGIntact;

    ax7 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('No. Spikes/Burst, LPG Intact')
    hold off
    legend('LG', 'IC', 'DG');

    %plotting numspk_LPGKill
    x1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_On_LPGKill;
    x2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_On_LPGKill;
    x3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_On_LPGKill;

    y1 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).LG_numspk_LPGKill;
    y2 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).IC_numspk_LPGKill;
    y3 = LPGIntactvsKilled_Params.IndData.(exps(i_exp)).DG_numspk_LPGKill;

    ax8 = nexttile;
    plot(x1, y1);
    hold on
    plot(x2, y2);
    plot(x3, y3);
    ylabel('No. Spikes/Burst, LPG Killed')
    hold off
    legend('LG', 'IC', 'DG');

end

%% calculating total average/stdev/stderr/cv data for bar graphs
for i_avg = 1:length(fieldnames(LPGIntactvsKilled_Params.EXP_AVG_STDev_STDErr_CVData))

    num2AVG = str2double(LPGIntactvsKilled_Params.EXP_AVG_STDev_STDErr_CVData.(label{i_avg}).Summary(:, 2:5)); %apparently the values in the summary field are stored as a string array, so this converts the column of interest into numbers
   
    num2AVG = rmmissing(num2AVG);
    
    mn_total = mean(num2AVG(:,1));
    stdev_total = std(num2AVG(:,2));
    stderr_total = stdev_total/sqrt(length(num2AVG(:,1)));
    cv_total = stdev_total/mn_total;

    LPGIntactvsKilled_Params.DATAforBARS.(label{i_avg}) = [mn_total stdev_total stderr_total cv_total];

end

%% plot bar graphs

figure;
chart = tiledlayout(4, 1);
x_label = categorical({'LG' 'IC' 'DG'});
x_label = reordercats(x_label, {'LG' 'IC' 'DG'});
%Gather data for CP_LPGIntact
lbl1 = contains(label, "CP_LPGIntact"); %to index for CP_LPGIntact data
x_CP1 = label(lbl1); %use this string array to look explicitly for these label names
x_CP_LPGIntact = categorical(label(lbl1)); %
y_CP1 = [];
for i_CP1 = 1:length(x_CP1) %for-loop to gather data from "CP_LPGIntact" fields

    y_CP1_data = LPGIntactvsKilled_Params.DATAforBARS.(x_CP1(i_CP1));
    y_CP1 = [y_CP1; y_CP1_data];

end
%Gather data for CP_LPGKill
lbl2 = contains(label, "CP_LPGKill");
x_CP2 = label(lbl2);
x_CP_LPGKill = categorical(label(lbl2));
y_CP2 = [];
for i_CP2 = 1:length(x_CP2)

    y_CP2_data = LPGIntactvsKilled_Params.DATAforBARS.(x_CP2(i_CP2));
    y_CP2 = [y_CP2; y_CP2_data];

end
y_CP = [y_CP1(:,1), y_CP2(:,1)]; %Put all the CP data into one matrix
ax1 = nexttile;
x1 = bar(x_label, y_CP);
ylabel('Cycle Period (s)'); %THIS WORKS! BUT I NEED TO FIGURE OUT X-LABELS
x1(1).FaceColor = '#77AC30';
x1(2).FaceColor = 'white';
x1(2).EdgeColor = '#77AC30';
x1(2).LineWidth = 0.75;

sterr_CP = [y_CP1(:,3), y_CP2(:,3)];

hold on

[ngroups, nbars] = size(y_CP);
x = nan(nbars, ngroups);
for i = 1:nbars
x(i,:) = x1(i).XEndPoints;
end
errorbar(x', y_CP, sterr_CP, 'k', 'linestyle', 'none');
hold off

%NEED TO ADD ERRORS BARS: https://www.mathworks.com/help/matlab/creating_plots/bar-chart-with-error-bars.html
%legend(x_CP1(1:end), x_CP2(1:end));

%Gather data for BD_LPGIntact
lbl3 = contains(label, "BD_LPGIntact");
x_BD1 = label(lbl3);
x_BD_LPGIntact = categorical(label(lbl3));
y_BD1 = [];
for i_BD1 = 1:length(x_BD1)

    y_BD1_data = LPGIntactvsKilled_Params.DATAforBARS.(x_BD1(i_BD1));
    y_BD1 = [y_BD1; y_BD1_data];

end
%Gather data for BD_LPGKill
lbl4 = contains(label, "BD_LPGKill");
x_BD2 = label(lbl4);
x_BD_LPGKill = categorical(label(lbl4));
y_BD2 = [];
for i_BD2 = 1:length(x_BD2)

    y_BD2_data = LPGIntactvsKilled_Params.DATAforBARS.(x_BD2(i_BD2));
    y_BD2 = [y_BD2; y_BD2_data];

end
y_BD = [y_BD1(:,1), y_BD2(:,1)];
ax2 = nexttile;
x2 = bar(x_label, y_BD);
ylabel('Burst Duration (s)');
x2(1).FaceColor = '#77AC30';
x2(2).FaceColor = 'white';
x2(2).EdgeColor = '#77AC30';
x2(2).LineWidth = 0.75;

sterr_BD = [y_BD1(:,3), y_BD2(:,3)];

hold on
[ngroups, nbars] = size(y_BD);
x = nan(nbars, ngroups);
for i = 1:nbars
x(i,:) = x2(i).XEndPoints;
end
errorbar(x', y_BD, sterr_BD, 'k', 'linestyle', 'none');
hold off

%Gather data for FF_LPGIntact
lbl5 = contains(label, "FF_LPGIntact");
x_FF1 = label(lbl5);
x_FF_LPGIntact = categorical(label(lbl5));
y_FF1 = [];
for i_FF1 = 1:length(x_FF1)

    y_FF1_data = LPGIntactvsKilled_Params.DATAforBARS.(x_FF1(i_FF1));
    y_FF1 = [y_FF1; y_FF1_data];

end
%Gather data for FF_LPGKill
lbl6 = contains(label, "FF_LPGKill");
x_FF2 = label(lbl6);
x_FF_LPGKill = categorical(label(lbl6));
y_FF2 = [];
for i_FF2 = 1:length(x_FF2)

    y_FF2_data = LPGIntactvsKilled_Params.DATAforBARS.(x_FF2(i_FF2));
    y_FF2 = [y_FF2; y_FF2_data];

end
y_FF = [y_FF1(:,1), y_FF2(:,1)];
ax3 = nexttile;
x3 = bar(x_label, y_FF);
ylabel('Firing Frequency (Hz)');
x3(1).FaceColor = '#77AC30';
x3(2).FaceColor = 'white';
x3(2).EdgeColor = '#77AC30';
x3(2).LineWidth = 0.75;

sterr_FF = [y_FF1(:,3), y_FF2(:,3)];

hold on
[ngroups, nbars] = size(y_FF);
x = nan(nbars, ngroups);
for i = 1:nbars
x(i,:) = x3(i).XEndPoints;
end
errorbar(x', y_FF, sterr_FF, 'k', 'linestyle', 'none');
hold off

%Gather data for numspk_LPGIntact
lbl7 = contains(label, "numspk_LPGIntact");
x_ns1 = label(lbl7);
x_ns_LPGIntact = categorical(label(lbl7));
y_ns1 = [];
for i_ns1 = 1:length(x_ns1)

    y_ns1_data = LPGIntactvsKilled_Params.DATAforBARS.(x_ns1(i_ns1));
    y_ns1 = [y_ns1; y_ns1_data];

end
%Gather data for numspk_LPGKill
lbl8 = contains(label, "numspk_LPGKill");
x_ns2 = label(lbl8);
x_ns_LPGKill = categorical(label(lbl8));
y_ns2 = [];
for i_ns2 = 1:length(x_ns2)

    y_ns2_data = LPGIntactvsKilled_Params.DATAforBARS.(x_ns2(i_ns2));
    y_ns2 = [y_ns2; y_ns2_data];

end
y_ns = [y_ns1(:,1), y_ns2(:,1)];
ax4 = nexttile;
x4 = bar(x_label, y_ns);
ylabel('No. Spikes per Burst');

legend('LPG Intact', 'LPG Kill');

x4(1).FaceColor = '#77AC30';
x4(2).FaceColor = 'white';
x4(2).EdgeColor = '#77AC30';
x4(2).LineWidth = 0.75;

sterr_ns = [y_ns1(:,3), y_ns2(:,3)];

hold on
[ngroups, nbars] = size(y_ns);
x = nan(nbars, ngroups);
for i = 1:nbars
x(i,:) = x4(i).XEndPoints;
end
errorbar(x', y_ns, sterr_ns, 'k', 'linestyle', 'none');
hold off