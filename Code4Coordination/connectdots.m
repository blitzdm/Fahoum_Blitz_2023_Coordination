% This function connects data points for different compared groups within a
% dataset.
% IMPORTANT NOTE: Whenever you run this function for a different group of
% data, you will need to edit line 16!! I haven't yet figured out how to make
% this line more flexible/based on your dataset

function connectdots(struct)

%figure

%fig = gcf;  %gets the current figure handle
%fig.Units='inches';
%fig.Position(3:4)= [6.262,2.078];  %fig.position returns left/right top/bottom width and height so fig.Position(3:4) lets me set the width and height

data2plot = [];
for i_exp = 1:length(struct.conditions)
    data2plot = [data2plot struct.(struct.conditions{i_exp})]; %to put all of the data into an array for plotting
end

for i_dat = 1 : length(data2plot) %max number of experiments
    %x = categorical (struct.conditions);
    %x = reordercats(x, struct.conditions);
    x = 1:length(struct.conditions);
    y = data2plot(i_dat, :);

    idx = ~any(isnan(y),1); %this will connect dots if there are NaNs (missing values for some conditions)
    plot(x(idx),y(idx), 'ko-');

    hold on

    plot(x,y,'ko','MarkerFaceColor','w','MarkerSize',10);

end
xlim padded; %little space above/below the data
ylim([0 100]); % doesn't seem to work with the 0 inf
end