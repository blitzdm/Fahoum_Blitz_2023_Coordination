%==========================================================================
% This function loops through a list of exps (each individual fields) and
% plots the x,y values for each experiment on a scatter plot
% At the end of the function, there is a collection of lines for plotting
% different types of coordination. Feel free to remove these if they are
% not useful for your plotting needs. :-)
% Although this function is specific for Sav's entrainment data, it can be
% edited to fit with other data as needed... see Sav's entrainment data
% structs to get an idea for how to organize your struct to best fit for use
% with this function
% Created March 21, 2023 By: Savanna-Rae Fahoum
%==========================================================================

function Entrain_Graphs_IndExps(struct, Neu1, Neu2, Condition) % Neu1 = entrainment neuron, Neu2 = follow neuron

%creates the labels for your graphs
xlbl = append(Neu1, " Entrainment Frequency (Hz)");
ylbl = append(Neu2, " Burst Frequency (Hz)");

max_p = 0.01;

%make the figure
figure;
fig.Renderer = 'Painters'; %sets Renderer to Painters in figure properties

for i_exp = 1:length(struct.exps)
    p = struct.(struct.exps{i_exp}); 
    
    %determine the max value in each exp
    if max_p < max(p(:,2))
        max_p = max(p(:,2));
    end
    
    s = scatter(p(:, 1), p(:, 2), 250, 'filled'); %graph the x,y columns from each experiment field
    hold on
end

hold on
% generate arrays that will be plotted as lines to indicate the
% type of coordination
x_Coor11 = (0:0.01:0.16).';
y_Coor11 = (0:0.01:0.16).'; % for 1:1 coordination relative to the y-axis (y_Coor11)
y_Coor12 = (0:0.005:0.08).'; % 1:2 coordination
y_Coor21 = (0:0.02:0.32).'; % 2:1 coordination
y_Coor13 = (0:0.003:0.05).'; % 1:3 coordination
y_Coor31 = (0:0.03:0.48).'; % 3:1 coordination
y_Coor41 = (0:0.04:0.64).';% 4:1 coordination
y_Coor51 = (0:0.05:0.8).'; % 5:1 coordination
y_Coor61 = (0:0.06:0.96).';% 6:1 coordination

%plot coordination lines
plot(x_Coor11, y_Coor11, '-k', 'LineWidth', 1); 
plot(x_Coor11, y_Coor12, '--k');
plot(x_Coor11, y_Coor21, '--k');
plot(x_Coor11, y_Coor13, '--k');
plot(x_Coor11, y_Coor31, '--k');
plot(x_Coor11, y_Coor41, '--k');
plot(x_Coor11, y_Coor51, '--k');
plot(x_Coor11, y_Coor61, '--k');

% add the x and y labels to your graph
xlabel(xlbl);
ylabel(ylbl);
grph_title = append(Neu1, "2", Neu2, Condition);%label for the graph title
title(grph_title);
legend(struct.exps);

%set the x- and y-axis limits
xlim([0 0.13]);
ylim([0 0.3]);


%% Save Figure
filename = append(Neu1, "2", Neu2, Condition,"_IndDataPoints", ".pdf");
exportgraphics(figure(1), filename, 'ContentType', 'vector')
%close all

end