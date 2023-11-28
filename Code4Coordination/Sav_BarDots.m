% This function plots mean data as bars w SEM and adds individual data
% points as dots. NOTE that you will need to edit the conditions field to
% plot the bars that you want to plot. In addition, you will need to set
% the dimensions of your figure @ line 44
% NOTE: this is set up for grouped sets of bars (conditions) with multiple
% bars for each set (categories)
% Data is just copied into a struct, see GMRCategories struct for example format
% Created by: Dawn M. Blitz

function Sav_BarDots(struct)

close all %close open figures before making new ones from this function

figure
fig.Renderer = 'Painters'; %sets Renderer to Painters in figure properties

for i_condition = 1:(length(struct.conditions)) %how many bars get grouped
    serr = []; %empty array to dump condition values into and exclude NaN, to make it easier to calculate Standard Error
    x=0;
    x = x+(i_condition); %so the bars are aligned correctly
    y=mean(struct.(struct.conditions{i_condition}), 'omitnan');
    bar(x,y);

    serr = [serr; struct.(struct.conditions{i_condition})]; %take values from the condition field and dump into empty array
    serr = serr(~isnan(serr)); %excluded NaN from the list
    stderror = std(serr/sqrt(length(serr))); %calculate standard error

    hold on
    er = errorbar(x,y,stderror,stderror, 'LineWidth', 1);
    er.Color = [0 0 0];
end
ylabel("Mean %");
ylim([0 100]); % Plot connected data points
xticks([1 2 3]); %where the x axis labels line up
xticklabels(struct.conditions);
xlim padded

connectdots(struct); %plot and connect paired data points per preparation across conditions


fig = gcf;  %gets the current figure handle
fig.Units='inches';
%fig.Position(3:4)= [6.262,2.078];  %fig.position returns left/right top/bottom width and height so fig.Position(3:4) lets me set the width and height


SaveFigsFile(struct) %saves figures generated from this function based on
% the struct name as PDF files. NOTE that you need to have the folder you
% want to save to open in the path.

%close all
end