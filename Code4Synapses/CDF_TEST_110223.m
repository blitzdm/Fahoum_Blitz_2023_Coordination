%==========================================================================
% This function calculates the cumulative distribution (CDF) of a set of 
% data and measures the area between CDF curve and a y=x diagonal at each 
% entrainment frequency. The purpose of this function is to plot the CDF 
% curve, diagonal, and gather the numerical data for each entrainment 
% frequency.
% This function also plots data points for the area between CDF and y=x 
% diagonal...
% 
% Entrainment data is saved in its own data structure: 
% filename format, entrainNeu2testNeu_Entrainment (ex:LG2LPG_Entrainment.m)
% data structure format: there is a field called exps with a list of 
% experiment names as type string; all other fields are labeled with experiment names 
% containing matrix arrays with entrainment neuron frequency in column 1,
% and test neuron burst frequency in column 2, all data as type double
% Make sure to load the data struct you want to analyze before running this
% function
%
% Created March 21, 2023 By: Savanna-Rae Fahoum
%==========================================================================
function [inters, entrain_data, statdata] = CDF_TEST_110223(struct, Neu1, Neu2, Condition)
% input arguments are:
% struct = structname
% Neu1 = entrainment neuron, 
% Neu2 = test neuron,
% Condition = SIF or SIF:PTX
% Example line to run: CDF_TEST_053023(LG2DG_Entrainment, "LG", "DG", "SIF")

close all;
freqs = [0.03; 0.04; 0.05; 0.06; 0.075; 0.09; 0.12]; %list of entrainment frequencies

%collect all data points into an array
all_data = []; 
for i_exp = 1:length(struct.exps)
    p = struct.(struct.exps{i_exp});
    all_data = [all_data; p];
end

%____________________
% If you want to shuffle the data to get values that end up with a curve 
% close to y=x for area = 0. Decided against shuffling since this can
% change the results each time this function is run
%Shuf_all = [];
%Shuffle all data points from all preps
%all_entrain_freqs = all_data(:,1); all_bur_freqs = all_data(:,2); %set each column in p separately so they can be shuffled independent of each other
%for n = 1:1
%    shuf_allentrain = all_entrain_freqs(randperm(size(all_entrain_freqs, 1)),:);
%    shuf_allbur = all_bur_freqs(randperm(size(all_bur_freqs, 1)),:);
%    Shuf_all = [shuf_allentrain shuf_allbur];
%end


% If you want to randomize values for a curve that is close to y=x, for
% area to be close to zero. Also chose not to take this route since the
% results changed each time we ran the function.
%rando1 = datasample(all_data (:,1), length(all_data));
%rando2 = datasample(all_data (:,2), length(all_data));
%rando = [rando1 rando2];
%x = rand(2,length(Shuf_all)).'; % try using uniform distribution instead
%____________________

y = (0:0.001:1).'; %y = x line for zero entrainment to compare data to.

significands = [];
%shuf_sigs = [];
%Shuf_data = [];
%ran_sigs = [];
%y_sigs = [];

for i_exp = 1:length(struct.exps)
    p = struct.(struct.exps{i_exp});
    %gather significands from data struct
    for i_p = 1:length(p)
        p_ratio = p(i_p,1)/p(i_p, 2); %calculate the ratio between entrainment frequency and each individual burst frequency
        rounded = round(p_ratio, 3);
        signif = rounded - floor(rounded); %take the significand from the p_ratio...
        %significands collects the entrainment frequency (col 1) and the
        %calculated signif (col 2)
        significands = [significands; p(i_p,1) signif]; %...and place it into the second column of a list of values.
    end
    %______________
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
    %______________

end

%% Plot for each entrainment frequency on their own individual graph
ind_sigs = []; %empty array for collecting significands associated with one frequency
%shuf_ind = [];
%ran_ind = [];
all_ind_sigs = [];
entrain_data = []; %to place in the area between curve and diagonal at each entrainment frequency
%Shuf_AreaData = [];
%Ran_AreaData = [];
y_AreaData = [];
statdata = [];
inters = [];

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

    %_______
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
    %_______

    %% Calculate CDF for data structure and diagonal line and plot on graphs, where there is one graph for each distinct entrainment frequency

    figure;
    %histogram of struct data
    ind_sig_histo = histogram(ind_sigs(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1); %histogram of signifcands; 101 for bin size 0.02
    %'cdf' = Cumulative density function estimate. The height of each bar is the cumulative relative number of observations in each bin and all previous bins. The height of the last bar is less than or equal to 1.
    ind_Cumulative_Probability = (ind_sig_histo.Values).'; %take the values from the histogram to plot below
    ind_Cumulative_Probability_0 = [0; ind_Cumulative_Probability]; %adds a zero to the beginning of the list of data to be plotted
    ind_Cumulative_Probability_0(end) = 1; %sets the last value in the dataset to exactly 1
    ind_bins = (0:0.01:1).'; %column of bin values
    ind_bins_0 = [0; ind_bins]; %adds a zero a beginning of list of bin values to be plotted

    %r perfect diag
    y_data_histo = histogram(y, 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    y_CDF = (y_data_histo.Values).';
    y_CDF_0 = [0; y_CDF];

    %______
    %shuffled data
    %Shuf_data_histo = histogram(shuf_ind(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    %Shuf_CDF = (Shuf_data_histo.Values).';
    %Shuf_CDF_0 = [0; Shuf_CDF];

    %random sampled data
    %    ran_data_histo = histogram(ran_sigs(:,2), 101, 'Normalization', 'cdf', 'DisplayStyle','stairs', 'EdgeColor', [0 0 0], 'LineWidth', 1);
    %    ran_CDF = (ran_data_histo.Values).';
    %    ran_CDF_0 = [0; ran_CDF];
    %______


    %plot CDFs for struct data and diagonal line
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

    %% Area Between Curves - Dawn's Function
    % This section calcualtes the area between the struct data and the
    % diagonal line at each entrainment frequency.
    % Reports the intersection points between these two curves and the area
    % for each entrainment frequency, and plots the areas in a graph (see
    % at the end of the function)

    [inter_report, total_area] = areaBetwCurves(ind_bins_0, ind_Cumulative_Probability_0); %area between diagonal and struct data curves
    inters = [inters; inter_report]; %report y-intersections between CDF and diagonal
     [~, y_area] = areaBetwCurves(ind_bins_0, y_CDF_0); %for perfect diagonal

    %_____
    %Shuf_area = areaBetwCurves(ind_bins_0, Shuf_CDF_0); %for shuffled data
    %    ran_area = areaBetwCurves(ind_bins_0, ran_CDF_0); % for random distribution
    %_____
  

    %Collect the areas into an array to be plotted
    %real data
    if ind_sigs(1,2) == -1
        entrain_data = [entrain_data; NaN NaN]; %note the order of the data points = order of freqs
    else
        entrain_data = [entrain_data; freqs(i_freqs) total_area]; %note the order of the data points = order of freqs
    end

    y_AreaData = [y_AreaData; freqs(i_freqs) y_area];


    %_________
    %shuffled data
    %Shuf_AreaData = [Shuf_AreaData; freqs(i_freqs) Shuf_area];

    %uniform ditribution
    %    Ran_AreaData = [Ran_AreaData; freqs(i_freqs) ran_area];
    %_________
    %% stats test for significance, using Kolmogorov-Smirnov test

    %[~,p,ksstat] = kstest2(ind_Cumulative_Probability_0, ran_CDF_0); %for
    %significance between curve and random values - we decided not to use
    %this since the results are different each time the function is run
    %(due to the randomization being different each time).

    if ind_sigs(1,2) == -1
     statdata = [statdata; freqs(i_freqs) NaN NaN]; %skips where there is no data to analyze
    else
    
    [~,p,ksstat] = kstest2(ind_Cumulative_Probability_0, y_CDF_0);

    if p < 0.05/7 %divided alpha = 0.05 by 7 to account for 7 different manipulations (Powell et al., 2021). This also makes the test more conservative
        disp('Significantly integer coupled at '); disp(freqs(i_freqs))
        disp('p ='); disp(p)
    else
        disp('NOT Significantly integer coupled at '); disp(freqs(i_freqs))
        disp('p ='); disp(p)
    end

    disp('ksstat=')
    disp(ksstat)

    %collects the entrainment frequency (col1), p-value (col2), and ks-statistic (col3) into an array
    statdata = [statdata; freqs(i_freqs) p ksstat]; 
    end

    %clear these arrays before moving on to the next entrainment frequency
    ind_sigs = [];
    %ran_ind = [];
    %shuf_ind = [];
    %end

end
%% Final Figure - plot the area between curves as a function of entrainment frequency

figure;
n = plot(freqs, entrain_data(:,2), '--ok', 'LineWidth', 1);
hold on
n = plot(freqs, y_AreaData(:,2), '--or', 'LineWidth', 1);%plot uniform distribution
%n = plot(freqs, Shuf_AreaData(:,2), '--og', 'LineWidth', 1); %plot shuffled data
%n = plot(freqs, Ran_AreaData(:,2), '--or', 'LineWidth', 1);%plot uniform distribution

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
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for i_fig = 1:length(FigList)
FigHandle = FigList(8);%(i_fig);
FigName   = num2str(get(FigHandle, 'Number'));
filename = append(Neu1, "2", Neu2, Condition, FigName, " ", ".pdf");
set(0, 'CurrentFigure', FigHandle);
exportgraphics(figure(8), filename, 'ContentType', 'vector') %(figure(i_fig), filename, 'ContentType', 'vector')
end

%close all

end



