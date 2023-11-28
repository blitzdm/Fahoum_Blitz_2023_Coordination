

%clc; clear; close all; % for testing, it was getting annoying clearing over and over

function [inter_report, total_area, area_between] = areaBetwCurves(x, y3)
% x represents the bins for the cdf histogram; y3 represents the collected
% data... so when plotting: plot(x,x) = perfect diagonal (y=x), while
% plot(x,y3) = the curve of the data collected 

%__________________________
%lines for testing purposes, Example lines (x,x) and (x,y3)
%x=[0;0;1;1]; y3 = [0;0.5;0.5;1]; 
%plot the graph to visualize what's going on
%figure;
%plot(x,x); %diagonal line
%hold on;
%plot(x, y3, 'o', 'MarkerEdgeColor', 'r');
%__________________________

%Determine the intersections between 2 plotted lines
inter_report = [];
[X0,Y0] = intersections(x,x,x,y3); %find where the curve (x,y3) intersects with a diagonal line (x,x)
% the intersections function is written by:
% Version: 2.0, 25 May 2017
% Author:  Douglas M. Schwarz
% Email:   dmschwarz=ieee*org, dmschwarz=urgrad*rochester*edu
% Real_email = regexprep(Email,{'=','*'},{'@','.'})

% Because Matlab inputs a 1.0000 (w/ lots of zeros) for any value very
% close to 1, we need to replace any 1.0000... with 1
renum=1-X0(end); %calculate the difference between the last value in X0 and 1...
if renum < 0.01 && renum >0 %if difference between 1-last value in X0 is between 0 and 0.01
    X0(end)=1; Y0(end)=1; %replace the last value in X0 and Y0 with 1
elseif renum==0 %if the difference is 0,
    X0(end)=X0(end); Y0(end)=Y0(end); %leave the last value alone
else
    X0(end+1)=1; Y0(end+1)=1; %otherwise, add a row in X0 and Y0 with the number 1.
end
inter_report = [inter_report; X0, Y0];


%put the intersection outputs into a matrix array to report it
inters = [X0 Y0];

%_____________________________
% Checkp[oint to plot curve and diagonal again and highlight the intersectionsto calculate the area under that portion of
        % the curve/diagonal
% if you want to see magenta dots at intersections
%hold on
%scatter(inters(:,1), inters(:,2), 'filled', 'magenta'); %plot the intersection points to confirm that they are correct
%patch(x,y3,'k');
%_____________________________

%add the intersection points into the cdf and the diagonal curves into the
%correct row of the data array. Note that here, we are replacing the
%closest point to the intercept with the *actual* intercept.
for i_intersect = 1:length(Y0) %loop through the list of intersections...
    idx_row=find(y3>=Y0(i_intersect) & x>=X0(i_intersect), 1, 'first');  %...find the first spot in CDF that is larger than the intersect value
    x(idx_row)=X0(i_intersect); %... and replace the value in that row for x and y3 with the value of the intersection
    y3(idx_row)=Y0(i_intersect);
end

%_____________________________
% another plotting to checkpoint to make sure the function is working properly
% Check that the intersections were input correctly into the data array
%figure
%plot(x,y3, 'b--o'); %check on the updated curves with inserted points
%hold on;
%plot(x, x, 'k');
%_____________________________

%now calculate area of CDF curve and diagonal between every two
%intersection points
area_cdf=[]; %area under the CDF curve
area_diag=[]; %area under the diagonal line
area_between=[]; %area between CDF and diagonal
area_all=[];

for i_intersect=1:length(Y0) %this loop is accumulating the area of all the pieces between intersections
    startX=X0(i_intersect); %get the first X intersection as a starting point (x and y intersections are the same, seems redundant to look for both)
    startY=Y0(i_intersect);  %get the first Y intersection as a starting point

    if i_intersect < length(Y0) %so don't try to calculate area past the last intersection
        stopX=X0(i_intersect+1); %get the next intersection which should be the end of the measurement for this chunk
        stopY=Y0(i_intersect+1);

        % at this point, startX and stopX indicate the region between two
        % intersection points (this is the same for startY and stopY)
        % the next 2 lines of code find those regions in the data array to 
        % calculate the area under that portion of the curve/diagonal 

        idx1=find(y3==startY & x==startX, 1,'first');  %find index for the intersection in the data array
        idx2=find(y3==stopY & x==stopX, 1,'first');  %and index for the 2nd intersection in the data array

        %area_all is an array with area diag in column1, area CDF in col 2,
        %area_between in col3 (so we can easily see all values in a row for testing purposes)
        area_all(i_intersect,1)=trapz(x(idx1:idx2), y3(idx1:idx2)); %area between the two intersections for the CDF?
        area_all(i_intersect,2)=trapz(x(idx1:idx2), x(idx1:idx2)); %area between the two intersections for the diagonal?

        %now individual arrays in case you want those
        area_cdf(i_intersect)=trapz(x(idx1:idx2), y3(idx1:idx2)); %area between the two intersections for the CDF?
        area_diag(i_intersect)=trapz(x(idx1:idx2), x(idx1:idx2)) ;%area between the two intersections for the diagonal?
        area_between(i_intersect)=abs(area_cdf(i_intersect)-area_diag(i_intersect));%diff between the two curves?
        %also put the area_between into area_all, next line repeats calc
        area_all(i_intersect,3)=abs(area_cdf(i_intersect)-area_diag(i_intersect)); %this puts the area between CDF and diag into column 3 of area_all
    end
end    
    %now sum all the pieces of area into a single area value
    total_area=sum(area_all(1:end,3)); %this is sent to CDF_TEST_110223 for some magic for graphing I guess?
end
