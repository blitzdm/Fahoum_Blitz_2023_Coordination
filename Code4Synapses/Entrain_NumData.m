%==========================================================================
% This is a sister function to the Entrain_Graphs_IndExps.m function used
% to plot individual data points. The present function collects
% numerical data, both in terms of the means, SEM, SD, Number bursts for 
% each entrainemnt frequency in each preparation, as well as mean, SEM, SD, 
% Number bursts across all preparations at each entrainment frequency
%
%I am still struggling to figure out how to update the input structure to
%include the output variables (perExp and totalMean) each as their own field.
%
%Created 03.30.3032 By: Savanna-Rae Fahoum
%==========================================================================

function [perExp, totalMean] = Entrain_NumData(struct)
data = struct;

freqs = [0.03; 0.04; 0.05; 0.06; 0.075; 0.09; 0.12]; %list of entrainment frequencies

rawData = [];
perExp = [];

for i_exp = 1:length(data.exps)
    p = data.(data.exps{i_exp});

    for i_freqs = 1:length(freqs)
        for i_p = 1:length(p)
            if p(i_p, 1) == freqs(i_freqs) %if we're looking at the right entrain frequency
                rawData = [rawData; p(i_p,2)]; %put the entrain frequency and the burst frequency into an empty array
            end
            prepAVG = mean(rawData); %calculate the mean of the raw burst frequencies from that experiment...
            prepSD = std(rawData);
            prepSEM = prepSD/sqrt(length(rawData));
            count_rawData = length(rawData);
        end
        perExp = [perExp; struct.exps(i_exp) freqs(i_freqs) prepAVG prepSD prepSEM count_rawData];
        rawData = []; %clear rawData so that you can do the same thing again for the next entrain frequencies
    end
end
%Convert perExp to double to calculate means across experiments
Means = [];
totalMean = [];
doubleData = str2double(perExp);
for i_freqs = 1:length(freqs)
    for i_doub = 1:length(doubleData(:,2))
        if doubleData(i_doub,2) == freqs(i_freqs) && ~isnan(doubleData(i_doub, 3))
            Means = [Means; doubleData(i_doub, 3)];
        end
        mn_dD = mean(Means);
        std_dD = std(Means);
        sem_dD = std_dD/sqrt(length(Means));
        count = length(Means);
    end
    totalMean = [totalMean; freqs(i_freqs) mn_dD std_dD sem_dD count];
    Means = [];
end

data.perExp = perExp;
data.totalMean = totalMean;

end
