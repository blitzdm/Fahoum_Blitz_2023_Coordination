%==========================================================================
% This function is a sisiter function of Entrain_CDF.m. Itcalculates the
% cumulative distribution of a set of data and measures the area between
% CDF and a y=x diagonal at each entrainment frequency. The purpose of this
% function is to gather the numerical data without needing to make all the
% graphs for it every time. For funsies, I did leave the figure that gets
% created for the Area between significand CDF and y=x diagonal...
% This function Will be primarily used for Sav's entrainment data, which is
% saved as a struct with each experiment as its own field (see Entrainment
% structs for example).
%
% Created March 21, 2023 By: Savanna-Rae Fahoum
%==========================================================================
function [entrain_data, statdata] = CDF_TEST(struct, Neu1, Neu2, Condition)

%data = struct;
freqs = [0.03; 0.04; 0.05; 0.06; 0.075; 0.09; 0.12]; %list of entrainment frequencies

all_data = [];
%collect all data points into an array to be shuffled
for i_exp = 1:length(struct.exps)
    p = struct.(struct.exps{i_exp});
    all_data = [all_data; p];
end
%Shuf_all = [];

%Shuffle all data points from all preps
%all_entrain_freqs = all_data(:,1); all_bur_freqs = all_data(:,2); %set each column in p separately so they can be shuffled independent of each other
%for n = 1:1
%    shuf_allentrain = all_entrain_freqs(randperm(size(all_entrain_freqs, 1)),:);
%    shuf_allbur = all_bur_freqs(randperm(size(all_bur_freqs, 1)),:);
%    Shuf_all = [shuf_allentrain shuf_allbur];
%end

y = (0:0.001:1).';

%rando1 = datasample(all_data (:,1), length(all_data));
%rando2 = datasample(all_data (:,2), length(all_data));

%rando = [rando1 rando2];

%x = rand(2,length(Shuf_all)).'; % try using uniform distribution instead

significands = [];
shuf_sigs = [];
%Shuf_data = [];
ran_sigs = [];
y_sigs = [];

for i_exp = 1:length(struct.exps)

    p = struct.(struct.exps{i_exp});

    %gather significands
    for i_p = 1:length(p)
        p_ratio = p(i_p,1)/p(i_p, 2); %calculate the ratio between entrainment frequency and each individual burst frequency
        rounded = round(p_ratio, 3);
        signif = rounded - floor(rounded);
        significands = [significands; p(i_p,1) signif];
    end
    %significands from shuffled data
    %for i_shuf = 1:length(Shuf_all)
    %    shuf_ratio = Shuf_all(i_shuf,1)/Shuf_all(i_shuf,2);
    %    shuf_rounded = round(shuf_ratio, 3);
    %    shuf_signif = shuf_rounded - floor(shuf_rounded);
    %    shuf_sigs = [shuf_sigs; Shuf_all(i_shuf,1) shuf_signif];
    %end
    %significands from random sampled data
    %    for i_rand = 1:length(rando)
    %        ran = rando(i_rand,1)/rando(i_rand,2);
    %        ran_rounded = round(ran, 3);
    %        ran_signif = ran_rounded - floor(ran_rounded);
    %        ran_sigs = [ran_sigs; rando(i_rand,1) ran_signif];
    %    end

    %    for i_y= 1:length(y)
    %      ysig = y(i_y,1)/y(i_y,2);
    %      y_rounded = round(ysig, 3);
    %      y_signif = y_rounded - floor(y_rounded);
    %     y_sigs = [y_sigs; y(i_y,1) y_signif];
    % end
end

%% Plot for each entrainment frequency on their own individual graph
ind_sigs = []; %empty array for collecting significands associated with one frequency
%shuf_ind = [];
ran_ind = [];
all_ind_sigs = [];
entrain_data = []; %to place in the area between curve and diagonal at each entrainment frequency
%Shuf_AreaData = [];
Ran_AreaData = [];
y_AreaData = [];
statdata = [];

for i_freqs = 1:length(freqs)
    %significands grouped by frequency
    for i_sig = 1:length(significands)
        if significands(i_sig, 1) == freqs(i_freqs)
            ind_sigs = [ind_sigs; significands(i_sig,1) significands(i_sig,2)];
        end

        if significands(:,1) ~= freqs(i_freqs)
            ind_sigs = [ind_sigs; freqs(i_freqs) -1];
            disp('no data at entrainment frequency'); disp(freqs(i_freqs));
        end

    end
    %significands from shuffled data, also grouped by frequency
    %for i_shuf = 1:length(shuf_sigs)
    %    if shuf_sigs(i_shuf,1) == freqs(i_freqs)
    %        shuf_ind = [shuf_ind; shuf_sigs(i_shuf, 1) shuf_sigs(i_shuf, 2)];
    %    end
    %end

    %significands from random sampled data, also grouped by frequency
    %    for i_ran = 1:length(ran_sigs)
    %        if ran_sigs(i_ran,1) == freqs(i_freqs)
    %            ran_ind = [ran_ind; ran_sigs(i_ran, 1) ran_sigs(i_ran, 2)];
    %        end
    %end

    %% Calculate CDF

    figure;
    %real data
    ind_sig_histo = histogram(ind_sigs(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1); %histogram of signifcands; 101 for bin size 0.02
    %'cdf' = Cumulative density function estimate. The height of each bar is the cumulative relative number of observations in each bin and all previous bins. The height of the last bar is less than or equal to 1.
    ind_Cumulative_Probability = (ind_sig_histo.Values).';
    ind_Cumulative_Probability_0 = [0; ind_Cumulative_Probability]; %adds a zero to the beginning of the list of data to be plotted
    ind_bins = (0:0.01:1).'; %column of bin values
    ind_bins_0 = [0; ind_bins]; %adds a zero a beginning of list of bin values to be plotted

    %shuffled data
    %Shuf_data_histo = histogram(shuf_ind(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    %Shuf_CDF = (Shuf_data_histo.Values).';
    %Shuf_CDF_0 = [0; Shuf_CDF];

    %random sampled data
    %    ran_data_histo = histogram(ran_sigs(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    %    ran_CDF = (ran_data_histo.Values).';
    %    ran_CDF_0 = [0; ran_CDF];

    %r perfect diag
    y_data_histo = histogram(y, 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    y_CDF = (y_data_histo.Values).';
    y_CDF_0 = [0; y_CDF];


    m = plot(ind_bins_0, ind_Cumulative_Probability_0, '-k','LineWidth',1);
    hold on
    m = plot(ind_bins_0, ind_bins_0, '-k', 'LineWidth', 1);
    %    m = plot(ind_bins_0, ran_CDF_0, '-r', 'LineWidth', 1);
    m = plot(ind_bins_0, y_CDF_0, '-b', 'LineWidth', 1);
    patch(ind_bins_0, ind_Cumulative_Probability_0, 'k');
    grph_title = append(Neu1, "2", Neu2, Condition); %label for the graph title
    title(grph_title, freqs(i_freqs));
    ylabel("Cumulative Distribution Frequency")
    xlim([0 1]);
    ylim([0 1]);
    hold off

    %% Area Between Curves - Dawn Function
    total_area = areaBetwCurves(ind_bins_0, ind_Cumulative_Probability_0); % for CDF data
    %Shuf_area = areaBetwCurves(ind_bins_0, Shuf_CDF_0); %for shuffled data
    %    ran_area = areaBetwCurves(ind_bins_0, ran_CDF_0); % for uniform distribution
    y_area = areaBetwCurves(ind_bins_0, y_CDF_0); % for uniform distribution

    %Collect the areas into an array to be plotted
    %real data
    if ind_sigs(1,2) == -1
        entrain_data = [entrain_data; NaN NaN]; %note the order of the data points = order of freqs
    else
        entrain_data = [entrain_data; freqs(i_freqs) total_area]; %note the order of the data points = order of freqs
    end

    %shuffled data
    %Shuf_AreaData = [Shuf_AreaData; freqs(i_freqs) Shuf_area];

    %uniform ditribution
    %    Ran_AreaData = [Ran_AreaData; freqs(i_freqs) ran_area];

    y_AreaData = [y_AreaData; freqs(i_freqs) y_area];


    %% stat test for significance

    %[~,p,ksstat] = kstest2(ind_Cumulative_Probability_0, ran_CDF_0);
    if ind_sigs(1,2) == -1
     statdata = [statdata; freqs(i_freqs) NaN NaN];
    else
    
    [~,p,ksstat] = kstest2(ind_Cumulative_Probability_0, y_CDF_0);

    if p < 0.05/7
        disp('Significantly integer coupled at '); disp(freqs(i_freqs))
        disp('p ='); disp(p)
    else
        disp('NOT Significantly integer coupled at '); disp(freqs(i_freqs))
        disp('p ='); disp(p)
    end

    disp('ksstat=')
    disp(ksstat)

    statdata = [statdata; freqs(i_freqs) p ksstat];
    end


    %clear these arrays before moving on to the next entrainment frequency
    ind_sigs = [];
    %shuf_ind = [];
    ran_ind = [];
    %end
    %statdata = statdata

end
%% Final Figure - plot the area between curves as a function of entrainment frequency

figure;
n = plot(freqs, entrain_data(:,2), '--ok', 'LineWidth', 1);
hold on
%n = plot(freqs, Shuf_AreaData(:,2), '--og', 'LineWidth', 1); %plot shuffled data
%n = plot(freqs, Ran_AreaData(:,2), '--or', 'LineWidth', 1);%plot uniform distribution
n = plot(freqs, y_AreaData(:,2), '--or', 'LineWidth', 1);%plot uniform distribution

grph_title2 = append(Neu1, "2", Neu2, Condition, " AREA"); %label for the graph title
title(grph_title2);
xlabel("Entrainment Frequency");
ylabel("Area between Significand Curve and Diagonal")
xlim([0 0.13])
ylim([0 0.5])
%examples of perfect entrainment
y5 = [0.5, 0.5];
y25 = [0.25, 0.25];
x = [0, 0.13];
plot(x, y5, '--k', 'LineWidth', 0.75);
plot(x, y25, '--k', 'LineWidth', 0.75);
fig = gcf;
fig.Name = grph_title2;
hold off

%% Save Figures -- Currently set to save the last figure in the list since I have already saved everything else
%FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
%for i_fig = 1:length(FigList)
%FigHandle = FigList(i_fig);
%FigName   = num2str(get(FigHandle, 'Number'));
%filename = append(Neu1, "2", Neu2, Condition, FigName, " ", ".pdf");
%set(0, 'CurrentFigure', FigHandle);
%exportgraphics(figure(i_fig), filename, 'ContentType', 'vector')
%end

%close all

end



