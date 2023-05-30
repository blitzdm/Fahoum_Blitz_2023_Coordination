% This function plots mean data as bars w SEM and adds individual data
% points as dots. NOTE that you will need to edit the conditions field to
% plot the bars that you want to plot. In addition, you will need to set
% the dimensions of your figure @ line 44
% NOTE: this is set up for grouped sets of bars (conditions) with multiple
% bars for each set (categories)
% Data is just copied into a struct, see GMRCategories structr for example format
%Created by: Dawn M. Blitz

function BarDots(GMRCategories, filename) %include *.pdf in your filename for function command

figure
fig.Renderer = 'Painters'; %sets Renderer to Painters in figure properties

for i_condition = 1:(length(GMRCategories.conditions)) %how many bars get grouped
    x=0;
    for i_categories = 1:length(GMRCategories.categorylist) %these are all the bars within each condition
        x = x+(i_condition); %so the bars are aligned correctly
        y=mean(GMRCategories.(GMRCategories.conditions{i_condition})(:,i_categories));
        bar(x,y);
        stderror= std(GMRCategories.(GMRCategories.conditions{i_condition})(:,i_categories)) / sqrt( length(GMRCategories.(GMRCategories.conditions{i_condition})(:,i_categories)));
        hold on
        er = errorbar(x,y,stderror,stderror);
        er.Color = [0 0 0];
        er.LineStyle = 'none';

        for i_dots= 1 : length(GMRCategories.(GMRCategories.conditions{i_condition})(:,i_categories)) %now plot dots
            hold on
            y=(GMRCategories.(GMRCategories.conditions{i_condition})(:,i_categories));
            plot(x,y,'ko-', 'MarkerFaceColor','w','MarkerSize',5);
        end
        x=x-(i_condition)+4; %this groups 2 bars together and then a space
    end

   % if length(GMRCategories.conditions) == 2
    %     xticks([1.5 4.5 7.5 10.5 13.5 16.5 19.5]); %where the x axis labels line up
    %elseif length(GMRCategories.conditions) == 3
        xticks([2 6 10 14 18 22 26]); %where the x axis labels line up
    %end

    labels=({'All Coor'	'All UnCoor''One UnCoor''One Tonic'	'One Silent''All Tonic'	'All Silent'}); % create list of X axis labels
    xticklabels(GMRCategories.categorylist);
    ylabel("Mean %");
    ylim([0 80]);

    fig = gcf;  %gets the current figure handle
    fig.Units='inches';
    fig.Position(3:4)= [6.262,2.078];  %fig.position returns left/right top/bottom width and height so fig.Position(3:4) lets me set the width and height
    
   
end
  exportgraphics(figure(1), filename, 'ContentType', 'vector')  %exports the figure created as a *.pdf and sets the content type to vector so it can be edited in CorelDraw
end