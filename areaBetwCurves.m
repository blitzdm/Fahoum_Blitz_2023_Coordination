%For real analysis, each CDF has a matching x,x diagonal line? I think that
%will be necessary so the diag and CDF have the same number of X values
%Sav - yeah, every diagonal and CDF dataset has 102 values
% Example lines (x,x) and (x,y3)
%clc; clear; close all; % for testing, it was getting annoying clearing over and over

function total_area = areaBetwCurves(x, y3)

%x=[0;0;1;1]; y3 = [0;0.5;0.5;1];

%plot the graph to visualize what's going on
%figure;
%plot(x,x); %diagonal line
%hold on;
%plot(x, y3, 'o', 'MarkerEdgeColor', 'r');

%Determine the intersections between 2 plotted lines
[X0,Y0] = intersections(x,x,x,y3);

%put the intersection outputs into a matrix array (just for plotting
%right?)
inters = [X0 Y0];
%scatter(inters(:,1), inters(:,2), 'filled', 'magenta'); %plot the intersection points to confirm that they are correct
%patch(x,y3,'k');

xnew=[];
ynew=[];
%add the intersection points into the cdf and the diagonal curves
for i_intersect = 1: length(Y0)
    %need to insert the intersect values into the correct row of data array
    idx_row=find(y3>=Y0(i_intersect) & x>=X0(i_intersect), 1, 'first');  %find the first spot in CDF that is larger than the intersect value
    xnew=vertcat(x(1:idx_row-1),X0(i_intersect),x(idx_row:end)); % concatenate the beginning of the CDF up to that index, insert the intersect value, then add the rest of the X
    ynew=vertcat(y3(1:idx_row-1),Y0(i_intersect),y3(idx_row:end)); % concatenate the beginning of the CDF up to that index, insert the intersect value, then add the rest of the CDF
    x=[]; %I think we want to just keep updating the x and y columns so it works on the next loop
    x=xnew;
    y3=[];
    y3=ynew;
end

%figure
%plot(x,y3, 'b--o'); %check on the updated curves with inserted points
%hold on;
%plot(x, x, 'k');

%now calculate areas
area_cdf=[];
area_diag=[];
area_between=[];
area_all=[];

for i_intersect=1:length(Y0)
    startX=X0(i_intersect); %not sure why i'd need x, just need y?
    startY=Y0(i_intersect);
    if i_intersect < length(Y0) %so don't try to calculate area past the last intersection
        stopX=X0(i_intersect+1);
        stopY=Y0(i_intersect+1);

        idx1=find(y3==startY & x==startX, 1,'first');  %find index for the intersection
        idx2=find(y3==stopY & x==stopX, 1,'first');  %and index for the 2nd intersection
        %Make array with area diag column1, area CDF col 2, area_betweeb
        %=col3 (so we can easily see across at least
        area_all(i_intersect,1)=trapz(x(idx1:idx2), y3(idx1:idx2)); %area between the two intersections for the CDF?
        area_all(i_intersect,2)=trapz(x(idx1:idx2), x(idx1:idx2)); %area between the two intersections for the diagonal?

        %now individual arrays in case you want those
        area_cdf(i_intersect)=trapz(x(idx1:idx2), y3(idx1:idx2)); %area between the two intersections for the CDF?
        area_diag(i_intersect)=trapz(x(idx1:idx2), x(idx1:idx2)) ;%area between the two intersections for the diagonal?
        area_between(i_intersect)=abs(area_cdf(i_intersect)-area_diag(i_intersect));%diff between the two curves?
        %will need to sum the area betweens
        area_all(i_intersect,3)=abs(area_cdf(i_intersect)-area_diag(i_intersect));
        total_area=sum(area_all(1:end,3)); %this just reports to command line right now
    end
end
end
