%NOTE: After running this script:
% Due to a few undefined descriptions for C, T, U, or S, make sure to check through each
%experiment and confirm that the "times" and "Cat" arrays for each neuron
%are all the same number of ROWS!
%If there are any "missing" values in the cat array for a neuron, these
%will need to be added in manually, and the struct saved. (as of
%02.17.2023)

% This script involves looking at each LG cycle, and determining whether
% IC, LPG, and DG start, are active, and/or stop during that LG cycle. This
% will be collected into a matrix as 0 and 1 (uncoorinated and coordinated,
% respectively), where each row corresponds to a combination of IC, LPG,
%and DG activity per LG cycle. After examination of the time window, each
% row of the matrix will be categorized based on the pattern of 1s and 0s
% present. For example, [1 1 1] would mean that the gastric mill pattern
% for that LG cycle is coordinated.



%This is a list of the structs that you need to open to run this script.
%You will need to run this separately for each condition (so, 6 times).
%MAKE SURE YOU SAVE YOUR STRUCT BEFORE MOVING ON TO THE NEXT RUN-THROUGH!
%and comment out the lines you don't want to analyze


%load('G:\Shared drives\Blitz
%Lab\Matlab\SavStuff\GMR_Categories\GMR_Categories.mat') %<--TEST to run
%individual exps, but you will need to make sure the individual exp is in
%the exp list first

% MCN5 LPG INTACT
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\MCN5_LPGIntact_forCategories.mat') %loads the struct with the data in it

% NOTE: MAKE SURE THAT YOU REMOVE THE LPGINTACT_EXPS FOLDER FROM PATH TO
% MAKE SURE THE CORRECT CHANNELS GET ANALYZED!!!

%LPG INTACT W LPG
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\LPGIntact_w_LPG_forCategories.mat') %loads the struct with the data in it

%LPG INTACT
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\LPGIntact_forCategories.mat') %loads the struct with the data in it

%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\LPGKilled_forCategories.mat') %loads the struct with the data in it
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\SIFPTXLPGKilled_forCategories.mat') %loads the struct with the data in it

%SIF:PTX_Control = SIF only; SIF:PTX_LPGIntact = SIF:PTX
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\SIFPTX_Control_forCategories.mat') %loads the struct with the data in it
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\SIFPTX_LPGIntact_forCategories.mat') %loads the struct with the data in it

load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\GMIntact_forCategories.mat') %loads the struct with the data in it
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\GMKilled_forCategories.mat') %loads the struct with the data in it

%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\SIF_App1_forCategories.mat') %loads the struct with the data in it
%load('G:\Shared drives\Blitz Lab\Matlab\SavStuff\GMR_Categories\SIF_App2_forCategories.mat') %loads the struct with the data in it

%Next, create the labels that you will need to look for data in the
% experiment file.
label = [];
for i_exp = 1: length(GMR_Categories.exps)
    for i_chan = 1 : length (GMR_Categories.channels)
        lbl = append(GMR_Categories.exps(i_exp), GMR_Categories.channels(i_chan)); %put label names together into one name (each neuron)
        label = [label ; lbl]; %create array with list of channel names (exp plus _neuron)
        load(GMR_Categories.exps(i_exp))
        %need to set all initial values to 0 somehow.
    end
end

%Loop through all exps-- main for-loop
for i_exp = 1: length(GMR_Categories.exps) %loop through all experiments
    data=[]; % this clears the struct
    data=load(GMR_Categories.exps{i_exp}); %this loads one exp with all its neuron fields into this struct

    %TO GET 0 (no burst) as first position of gastric neurons starting
    %just a tiny bit before the first PD burst

    LGch = append(GMR_Categories.exps(i_exp), "_LG"); %name the LG channel
    LGfirst=(data.(LGch).times(1)-0.02); %subtract tiny bit off the time of first LG burst
    numevents = (length(data.(LGch).level)-4); %shouldn't need to subtract 2 if export correctly from spike2
    
    %create the label names for each experiment...
    ICch = append(GMR_Categories.exps(i_exp), "_IC");
    DGch = append(GMR_Categories.exps(i_exp), "_DG");
    LPGch = append(GMR_Categories.exps(i_exp), "_LPG");

    %...so you can determine whether they exist in the experiment during
    %the loop
    vars = whos('-file', GMR_Categories.exps(i_exp));
    is1 = ismember(LPGch, {vars.name});
    is2 = ismember(LGch, {vars.name});
    is3 = ismember(DGch, {vars.name});
    is4 = ismember(ICch, {vars.name});

    %is1 = isfield(GMR_Categories.exps(i_exp), "_LPG");
    %is2 = isfield(GMR_Categories.exps(i_exp), "_LG");
    %is3 = isfield(GMR_Categories.exps(i_exp), "_DG");
    %is4 = isfield(GMR_Categories.exps(i_exp), "_IC");

    if is1 == 1 && is2 == 1 && is3 ==1 && is4 == 1

        for i_fix = 1 : length(GMR_Categories.channels)
            Channame = append(GMR_Categories.exps(i_exp), (GMR_Categories.channels{i_fix})); %name the neuron channel
            data.(Channame).times = [LGfirst; data.(Channame).times(1:end)]; %start time for all channels at LGfirst
            data.(Channame).level = [0; data.(Channame).level(1:end)]; %start all channel levels with 0
        end

    elseif is1 == 0 && is2 == 1 && is3 ==1 && is4 == 1

        Channs = [LGch ICch DGch];

        for i_Channs = 1 : length(Channs)   
            data.(Channs(i_Channs)).times = [LGfirst; data.(Channs(i_Channs)).times(1:end)]; %start time for all channels at LGfirst
            data.(Channs(i_Channs)).level = [0; data.(Channs(i_Channs)).level(1:end)]; %start all channel levels with 0
        end
     

    else 
        fprintf ('all zeros'); % to make sure the if-statements in lines 82 and 90 are running properly
    end


    %Set up some counters so you can keep track of things (71-78 in
    %Phase_CPscript)
    numevents = (length(data.(LGch).level)-4); %shouldn't need to subtract 2 if export correctly from spike2
    listnum=1;  % this is index for the rows of the cycle period data
    i_LG=3;
    %counters for each exp, for # of cycle pds dropped into LGburst or
    %DG burst column etc
    countDG=1; countIC=1; countLPG=1;


    %to collect burst start and stop times when ID'ed as coordinated for thte current LG cycle
    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [];

    %first find the current LG cycle and calculate LG CP
    %i_LG = 188;
    while i_LG < numevents
        CPnum=find(data.(LGch).level(i_LG:end)==1,1); % this returns how many more rows until the next 1 (including the current row)
        CPnum=(i_LG + CPnum - 1); %add the additonal rows to the current row number
        LGstart_prev=data.(LGch).times(CPnum);
        i_LG=CPnum + 1;
        %Current LG cycle stuff
        CPnum=find(data.(LGch).level(i_LG:end)==1,1); % this returns how many more rows until the next 1 (including the current row)
        CPnum=(i_LG + CPnum - 1); %add the additonal rows to the current row number
        LGstart_curr=data.(LGch).times(CPnum);
        LGburststop_curr=data.(LGch).times(CPnum+1);
        i_LG=CPnum + 1;
        CPnum=find(data.(LGch).level(i_LG:end)==1,1); % this returns how many more rows until the next 1
        CPnum=(i_LG + CPnum - 1); %add the additonal rows to the current row number
        LGstop_curr=data.(LGch).times(CPnum); %this is ALSO LGstart_next (for the start the next LG cycle)
        GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(listnum,1)= LGstart_curr;
        GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time2(listnum,1)= LGburststop_curr;
        GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(listnum,1) = (LGstop_curr-LGstart_curr); %start a list of cycle periods
        %Next LG cycle stuff
        i_LG=CPnum + 1;
        CPnum=find(data.(LGch).level(i_LG:end)==1,1); % this returns how many more rows until the next 1
        CPnum=(i_LG + CPnum - 1); %add the additonal rows to the current row number
        if CPnum < length(data.(LGch).times)
            LGstop_next=data.(LGch).times(CPnum);
        else
            LGstop_next = data.(LGch).times(end);
        end

        LG_Dur_Longest = LGstop_next - LGstart_prev; %Calculate the maximum duration that any other burst can be in order to be considered "coordinated". If a neuron burst is longer that this value, it gets categorized as "tonic"


        %% IC pattern within current LG cycle:
        ICch = append(GMR_Categories.exps(i_exp), "_IC"); %name the IC channel
        %determine the timepoints in IC data that have on/off data within
        %previous, current, and next LG cycle
        ICtime_1 = find(data.(ICch).times<LGstart_curr,1,'last'); %the last position in IC time before LGstart_curr
        ICtime_2 = find(data.(ICch).times>LGstop_curr,1,'first'); %the first position in IC time after LGstop_curr
        if length(data.(ICch).times) > 2
            ICtime_end = data.(ICch).times(end-3);
        elseif length(data.(ICch).times) == 2
            ICtime_end = data.(ICch).times(end-2);
        elseif length(data.(ICch).times) == 1
            ICtime_end = data.(ICch).times(end);
        end

        %Determine the number of starts (1) and stops (0) between
        %LGstart_prev and LGstop_next
        ICon_num = sum(data.(ICch).level(ICtime_1:ICtime_2) == 1); %returns the number of burst starts (between the last event before LGstart_curr and first event after LGstop_curr)
        ICoff_num = sum(data.(ICch).level(ICtime_1:ICtime_2) == 0); %returns the number of burst stops

        IC_num1 = find(data.(ICch).times>LGstart_curr,1,'first'); %determine the position of the first value that occurs after LGstart_curr
        %These values are all determined in reference to the first level
        %value that occurs after LGstart_curr. This takes care of the issue
        %where multiple bursts happen during one LG cycle (NOTE: this
        %does not give us an indiciation that there were two bursts within
        %one cycle)

        if ICtime_1 < ICtime_end

            if IC_num1-1 < length(data.(ICch).times)
                IC_Event0 = data.(ICch).level(IC_num1 - 1); %determine the last level number that occurs before LGstart_curr
                IC_EvTime0 = data.(ICch).times(IC_num1 - 1);%determine the time of the last level number that occurs before LGstart_curr
            else
                IC_Event0 = data.(ICch).level(end);
                IC_EvTime0 = data.(ICch).times(end);
            end

            if IC_num1 < length(data.(ICch).times)
                IC_Event1 = data.(ICch).level(IC_num1); %determine the level number (1 or 0) that occurs after LGstart_curr
                IC_EvTime1 = data.(ICch).times(IC_num1); %determine the time of the IC_Event1
            else
                IC_Event1 = data.(ICch).level(end);
                IC_EvTime1 = data.(ICch).times(end);
            end
            if IC_num1+1 < length(data.(ICch).times)
                IC_Event2 = data.(ICch).level(IC_num1 + 1); %determine the level number after Event1 " " that occurs after LGstart_curr
                IC_EvTime2 = data.(ICch).times(IC_num1 + 1); %determine the time of the IC_Event2
            else
                IC_Event2 = data.(ICch).level(end);
                IC_EvTime2 = data.(ICch).times(end);
            end
            if IC_num1+2 < length(data.(ICch).times)
                IC_Event3 = data.(ICch).level(IC_num1 + 2); %determine the level number after Event2 that occurs after LGstart_curr
                IC_EvTime3 = data.(ICch).times(IC_num1 + 2); %determine the time of the IC_Event3
            else
                IC_Event3 = data.(ICch).level(end);
                IC_EvTime3 = data.(ICch).times(end);
            end
            if IC_num1 + 3 < length(data.(ICch).times)
                IC_Event4 = data.(ICch).level(IC_num1 + 3); %determine the level number after Event3 that occurs after LGstart_curr
                IC_EvTime4 = data.(ICch).times(IC_num1 + 3); %determine the time of the level number that occurs after LGstart_curr
            else
                IC_Event4 = data.(ICch).level(end);
                IC_EvTime4 = data.(ICch).times(end);
            end

            %for cases where bursting might be tonic, these are some
            %possibilities:
            if IC_Event0 == 1 && IC_Event1 == 0 && IC_EvTime1 > LGstop_curr %for cases when a burst starts before LGstart_curr and ends after LGstop_curr
                IC_Dur_ExtCycle = IC_EvTime1 - IC_EvTime0;
            elseif IC_Event1 == 1 && IC_Event2 == 0 && IC_Event3 == 1 && IC_EvTime2 > LGstop_next %for cases when a burst starts after LGstart_curr and ends after LGstop_next
                IC_Dur_ExtCycle = IC_EvTime2 - IC_EvTime1;
            elseif IC_Event0 == 1 && IC_Event1 == 0 && IC_EvTime0 < LGstart_prev && IC_EvTime1 > LGstart_curr %for cases when a burst starts well before the current LG cycle and ends within or after the current LG cycle
                IC_Dur_ExtCycle = IC_EvTime1 - IC_EvTime0;
            end

            %Categorize the IC burst at the current LG cycle
            if    IC_Event0 == 0 && IC_Event1 == 0 && IC_Event2 == 0 && IC_Event3 == 0 && IC_Event4 == 0
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "S"; %give a false category for the last cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif    IC_Event0 == 0 && IC_Event1 == 1 && IC_Event2 == 0 && IC_Event3 == 0 && IC_Event4 == 0
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "S"; %give a false category for the last cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];

            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 > LGstart_curr && IC_Event2 == 1 && IC_EvTime2 < LGstop_curr && IC_Event3 == 0 && IC_EvTime3 < LGstop_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event1 == 1 && IC_EvTime1 > LGstart_curr && IC_Event2 == 0 && IC_EvTime2 <LGstop_curr && IC_Event3 == 1 && IC_EvTime3 < LGstop_curr && IC_Event4 == 0 && IC_EvTime4 < LGstop_curr %|| IC_EvTime4 > LGstop_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "U"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event1 == 1 && IC_EvTime1 > LGstart_curr && IC_Event2 == 0 && IC_EvTime2 <LGstop_curr && IC_Event3 == 1 && IC_EvTime3 < LGstop_curr && IC_Event4 == 0 && IC_EvTime4 < LGstop_next
                IC_EV3_Perc = abs((LGstop_curr - IC_EvTime3) / (LGstop_curr - LGstart_curr));
                if IC_EV3_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "U"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
                elseif IC_EV3_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime1 IC_EvTime2];
                end

            elseif IC_Event1 == 1 && IC_EvTime1 > LGstop_curr && IC_Event0 == 0 && IC_EvTime0 < LGstart_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "S"; %if the previous burst ended before the current LG cycle and the next burst starts after the current LG cycle then "S" for silent (there is no burst during LG cycle)
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 > LGstart_curr && IC_EvTime1 < LGstop_curr && IC_Event2 == 1 && IC_EvTime2 > LGstop_curr  %for cases when a burst from the previous cycle ends in the current cycle and no new burst begins in the current cycle
                IC_Ev0_Perc = abs((LGstart_curr - IC_EvTime0)/ (LGstart_curr-LGstart_prev)); %determine the percent of time that the neuron starts before LGstart_curr in the previous cycle
                if IC_Ev0_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "S";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime0 IC_EvTime1];
                end
            elseif IC_Event0 == 0 && IC_EvTime0 < LGstart_curr && IC_Event1 == 1 && IC_EvTime1 < LGstop_curr && IC_Event2 == 0 && IC_EvTime2 > LGstop_curr && IC_EvTime2 < LGstop_next %no burst in current cycle, burst for next cycle starts before next cycle and ends in the next cycle
                IC_Ev1_Perc = abs((LGstop_curr - IC_EvTime1)/ (LGstop_curr-LGstart_curr)); %determine the percent of time that the neuron starts before LG in the current cycle
                if IC_Ev1_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "S";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime1 IC_EvTime2];
                end

            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 > LGstop_curr && IC_Dur_ExtCycle > LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "T"; %if the burst starts before LGstart_curr and ends after LGstop_curr and it is longer than 2 LG cycles, then this burst is tonic
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event1 == 1 && IC_EvTime1 > LGstart_curr && IC_EvTime1 < LGstop_curr && IC_Event2 == 0 && IC_EvTime2 > LGstop_next && IC_Dur_ExtCycle > LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "T"; %if the burst starts after LGstart_curr and ends beyond LGstop_next such that the duration is longer than LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_prev && IC_Event1 == 0 && IC_EvTime1 > LGstop_next
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "T"; %if the burst starts before the previous cycle and ends after the next cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 > LGstop_next %burst starts before the current cycle and ends after the next cycle
                IC_Ev0_Perc = abs((LGstart_curr - IC_EvTime0) / LGstart_curr - LGstop_curr);
                if IC_Ev0_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "T"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime1 IC_EvTime2];
                end

            elseif IC_Event1 == 1 && IC_EvTime1 > LGstart_curr && IC_EvTime1 < LGstop_curr && IC_Event2 == 0 && IC_EvTime2 > LGstart_curr && IC_EvTime2 < LGstop_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C"; %if IC start and stop are within LG cycle, then coordinated
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime1 IC_EvTime2];
            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 < LGstop_curr %condition when IC starts before current LG cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C";
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime0 IC_EvTime1];
            elseif IC_Event1 == 1 && IC_EvTime1 > LGstart_curr && IC_Event2 == 0 && IC_EvTime2 > LGstop_curr && IC_EvTime2 < LGstop_next %for cases when burst starts within current cycle and ends in the next cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C";
                GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime1 IC_EvTime2];
            elseif IC_Event0 == 1 && IC_EvTime0 < LGstart_curr && IC_Event1 == 0 && IC_EvTime1 > LGstop_curr %&& IC_Dur_ExtCycle < LG_Dur_Longest %condition when IC starts before and ends after current cycle, and IC burst duration is less than LG cycle period
                IC_Ev0_Perc = abs((LGstart_curr - IC_EvTime0) / (LGstop_curr - LGstart_curr));
                IC_Ev1_Perc = abs((LGstop_curr - IC_EvTime1) / (LGstop_next - LGstop_curr));
                if IC_Ev0_Perc > 0.10 && IC_Ev1_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; IC_EvTime0 IC_EvTime1];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "T";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
                end

            end
        else
            GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(listnum,1) = "F";
            GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times; 0 0];
        end



        %% DG pattern within each LG cycle
        DGch = append(GMR_Categories.exps(i_exp), "_DG"); %name the DG channel

        DGtime_1 = find(data.(DGch).times<LGstart_curr,1,'last'); %the last position in DG time before LGstart_curr
        DGtime_2 = find(data.(DGch).times>LGstop_curr,1,'first'); %the first position in DG time after LGstop_curr
        if length(data.(DGch).times) > 2
            DGtime_end = data.(DGch).times(end-3);
        elseif length(data.(DGch).times) == 2
            DGtime_end = data.(DGch).times(end-1);
        elseif length(data.(DGch).times) == 1
            DGtime_end = data.(DGch).times(end);
        end


        %Determine the number of starts (1) and stops (0) between
        %LGstart_prev and LGstop_next
        DGon_num = sum(data.(DGch).level(DGtime_1:DGtime_2) == 1); %returns the number of burst starts (between the last event before LGstart_curr and first event after LGstop_curr)
        DGoff_num = sum(data.(DGch).level(DGtime_1:DGtime_2) == 0); %returns the number of burst stops


        DG_num1 = find(data.(DGch).times>LGstart_curr,1,'first'); %determine the position of the first value that occurs after LGstart_curr

        %if DGtime_1 == [] %for exps where DG is tonic for the entire time window...
         %   DGEvent0 = data.(DGch).level; %indicate the only event value...
          %  DG_EvTime0 = data.(DGch).times; %and the only time value
           % GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %indicate the tonic DG for the whole exp
        if DGtime_1 < DGtime_end
            if DG_num1-1 < length(data.(DGch).times)
                DG_Event0 = data.(DGch).level(DG_num1 - 1); %determine the last level number that occurs before LGstart_curr
                DG_EvTime0 = data.(DGch).times(DG_num1 - 1);%determine the time of the last level number that occurs before LGstart_curr
            else
                DG_Event0 = data.(DGch).level(end);
                DG_EvTime0 = data.(DGch).times(end);
            end
            if DG_num1 < length(data.(DGch).times)
                DG_Event1 = data.(DGch).level(DG_num1); %determine the level number (1 or 0) that occurs after LGstart_curr
                DG_EvTime1 = data.(DGch).times(DG_num1); %determine the time of the IC_Event1
            else
                DG_Event1 = data.(DGch).level(end);
                DG_EvTime1 = data.(DGch).times(end);
            end
            if DG_num1+1 < length(data.(DGch).times)
                DG_Event2 = data.(DGch).level(DG_num1 + 1); %determine the level number " " that occurs before LGstop_curr
                DG_EvTime2 = data.(DGch).times(DG_num1 + 1); %determine the time of the IC_Event2
            else
                DG_Event2 = data.(DGch).level(end);
                DG_EvTime2 = data.(DGch).times(end);
            end
            if DG_num1 + 2 < length(data.(DGch).times)
                DG_Event3 = data.(DGch).level(DG_num1 + 2); %determine the level number that occurs after LGstop_curr
                DG_EvTime3 = data.(DGch).times(DG_num1 + 2); %determine the time of the level number that occurs after LGstop_curr
            else
                DG_Event3 = data.(DGch).level(end);
                DG_EvTime3 = data.(DGch).times(end);
            end
            if DG_num1 + 3 < length(data.(DGch).times)
                DG_Event4 = data.(DGch).level(DG_num1 + 3); %determine the level number after Event3 that occurs after LGstart_curr
                DG_EvTime4 = data.(DGch).times(DG_num1 + 3); %determine the time of the level number that occurs after LGstart_curr
            else
                DG_Event4 = data.(DGch).level(end);
                DG_EvTime4 = data.(DGch).times(end);
            end

            %for cases where bursting might be tonic, these are some
            %possibilities:
            if DG_Event0 == 1 && DG_Event0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstop_curr %for cases when a burst starts before LGstart_curr and ends after LGstop_curr
                DG_Dur_ExtCycle = DG_EvTime1 - DG_EvTime0;
            elseif DG_Event1 == 1 && DG_Event2 == 0 && DG_Event3 == 1 && DG_EvTime2 > LGstop_next %for cases when a burst starts after LGstart_curr and ends after LGstop_next
                DG_Dur_ExtCycle = DG_EvTime2 - DG_EvTime1;
            elseif DG_Event0 == 1 && DG_Event1 == 0 && DG_EvTime0 < LGstart_prev && DG_EvTime1 > LGstart_curr %for cases when a burst starts well before the current LG cycle and ends within or after the current LG cycle
                DG_Dur_ExtCycle = DG_EvTime1 - DG_EvTime0;
            end

            %Categorize the DG burst at the current LG cycle


            if    DG_Event0 == 0 && DG_Event1 == 0 && DG_Event2 == 0 && DG_Event3 == 0 && DG_Event4 == 0
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif    DG_Event0 == 0 && DG_Event1 == 1 && DG_Event2 == 0 && DG_Event3 == 0 && DG_Event4 == 0
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstart_curr && DG_Event2 == 1 && DG_EvTime2 < LGstop_curr && DG_Event3 == 0 && DG_EvTime3 < LGstop_curr
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0) / (LGstart_curr - LGstart_prev));
                if DG_Ev0_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                elseif DG_Ev0_Perc > 0.10
                    if DG_EvTime4 < LGstop_curr
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0, DG_EvTime1];
                    end
                end
            elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_Event2 == 0 && DG_EvTime2 <LGstop_curr && DG_Event3 == 1 && DG_EvTime3 < LGstop_curr && DG_Event4 == 0 && DG_EvTime4 < LGstop_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "U"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_Event2 == 0 && DG_EvTime2 <LGstop_curr && DG_Event3 == 1 && DG_EvTime3 < LGstop_curr && DG_Event4 == 0 && DG_EvTime4 < LGstop_curr && DG_EvTime4 < LGstop_next
                DG_EV3_Perc = abs((LGstop_curr - DG_EvTime3) / (LGstop_curr - LGstart_curr));
                if DG_EV3_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "U"; %more than one bursts within a cycle - first burst start/end in the current cycle, secodn burst starts in current cycle and ends in next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                elseif DG_EV3_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime1 DG_EvTime2];
                end
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstart_curr && DG_Event2 == 1 && DG_EvTime2 < LGstop_curr && DG_Event3 == 0 && DG_EvTime3 > LGstop_curr
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0) / (LGstart_curr - LGstart_prev));
                DG_Ev2_Perc = abs((LGstop_curr - DG_EvTime2) / LGstop_curr - LGstart_curr);
                if DG_Ev0_Perc > 0.10 && DG_Ev2_Perc > 0.10 && DG_EvTime3 < LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime2 DG_EvTime3];
                elseif DG_Ev0_Perc < 0.10 && DG_Ev2_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                elseif DG_Ev0_Perc < 0.10 && DG_Ev2_Perc > 0.10 && DG_EvTime3 < LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                elseif DG_Ev0_Perc > 0.10 && DG_Ev2_Perc < 0.10 && DG_EvTime3 > LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                elseif DG_Ev0_Perc > 0.10 && DG_Ev2_Perc > 0.10 && DG_EvTime3 > LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end

            elseif DG_Event1 == 1 && DG_EvTime1 > LGstop_curr && DG_Event0 == 0 && DG_EvTime0 < LGstart_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S"; %if the previous burst ended before the current LG cycle and the next burst starts after the current LG cycle then "S" for silent (there is no burst during LG cycle)
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 1 && DG_EvTime2 > LGstop_curr  %for cases when a burst from the previous cycle ends in the current cycle and no new burst begins in the current cycle
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0)/ (LGstart_curr-LGstart_prev)); %determine the percent of time that the neuron starts before LGstart_curr
                if DG_Ev0_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                end
            elseif DG_Event0 == 0 && DG_EvTime0 < LGstart_curr && DG_Event1 == 1 && DG_EvTime1 < LGstop_curr && DG_Event2 == 0 && DG_EvTime2 > LGstop_curr
                if DG_EvTime2 < LGstop_next
                    DG_Ev1_Perc = abs((LGstop_curr - DG_EvTime1)/ (LGstop_curr-LGstart_curr)); %determine the percent of time that the neuron starts before LG
                    if DG_Ev1_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime1 DG_EvTime2];
                    end
                elseif DG_EvTime2 > LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end


            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstop_curr && DG_Dur_ExtCycle > LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %if the burst starts before LGstart_curr and ends after LGstop_curr and it is longer than 2 LG cycles, then this burst is tonic
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 0 && DG_EvTime2 > LGstop_next && DG_Dur_ExtCycle > LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %if the burst starts after LGstart_curr and ends beyond LGstop_next such that the duration is longer than LG_Dur_Longest
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_prev && DG_Event1 == 0 && DG_EvTime1 > LGstop_next
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %if the burst starts before the previous cycle and ends after the next cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_prev && DG_Event1 == 0 && DG_EvTime1 > LGstop_curr %burst starts before previous cycle and ends in the next cycle
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T";
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstop_next
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0) / (LGstart_curr - LGstart_prev));
                if DG_Ev0_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                end
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 1 && DG_EvTime2 < LGstop_curr
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0) / (LGstart_curr - LGstart_prev));
                DG_Ev2_Perc = abs((LGstop_curr - DG_EvTime2) / (LGstop_next - LGstop_curr));
                if DG_Ev0_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                elseif DG_Ev0_Perc > 0.10 && (DG_EvTime3 - DG_EvTime2) > LG_Dur_Longest
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T"; %if the burst starts before the current cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end

                % elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 0 && DG_EvTime2 > LGstop_curr && DG_EvTime2 < LGstop_next

            elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 0 && DG_EvTime2 > LGstart_curr && DG_EvTime2 < LGstop_curr
                GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C"; %if IC start and stop are within LG cycle, then coordinated
                GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime1 DG_EvTime2];
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 < LGstop_curr %condition when burst starts before current LG cycle
                DG_Ev1_Perc = abs((LGstart_curr - DG_EvTime1) / (LGstart_curr - LGstart_prev));
                if DG_Ev1_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                elseif DG_Ev1_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end

            elseif DG_Event1 == 1 && DG_EvTime1 > LGstart_curr && DG_EvTime1 < LGstop_curr && DG_Event2 == 0 && DG_EvTime2 > LGstop_curr && DG_EvTime2 < LGstop_next %for cases when burst starts within current cycle and ends in the next cycle
                DG_Ev1_Perc = abs((LGstop_curr - DG_EvTime1) / (LGstop_curr - LGstart_curr));
                if DG_Ev1_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime1 DG_EvTime2];
                elseif DG_Ev1_Perc < 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "S";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end
            elseif DG_Event0 == 1 && DG_EvTime0 < LGstart_curr && DG_Event1 == 0 && DG_EvTime1 > LGstop_curr && DG_Dur_ExtCycle < LG_Dur_Longest %condition when burst starts before and ends after current cycle, and IC burst duration is less than LG cycle period
                DG_Ev0_Perc = abs((LGstart_curr - DG_EvTime0) / (LGstart_curr - LGstart_prev));
                DG_Ev1_Perc = abs((LGstop_curr - DG_EvTime1) / (LGstop_next - LGstop_curr));
                if DG_Ev0_Perc > 0.10 && DG_Ev1_Perc > 0.10
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "C";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; DG_EvTime0 DG_EvTime1];
                else
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(listnum,1) = "T";
                    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                end
            end
        end



        %% LPG pattern at each LG cycle
        %is = isfield(GMR_Categories.exps(i_exp), "_LPG");

        if is1 == 1
            LPGch = append(GMR_Categories.exps(i_exp), "_LPG"); %name the LPG channel

            LPGtime_1 = find(data.(LPGch).times<LGstart_curr,1,'last'); %the last position in LPG time before LGstart_curr
            LPGtime_2 = find(data.(LPGch).times>LGstop_curr,1,'first'); %the first position in LPG time after LGstop_curr
            if length(data.(LPGch).times) > 2
                LPGtime_end = data.(LPGch).times(end-3);
            elseif length(data.(LPGch).times) == 2
                LPGtime_end = data.(LPGch).times(end-2);
            elseif length(data.(LPGch).times) == 1
                LPGtime_end = data.(LPGch).times(end);
            end

            %Determine the number of starts (1) and stops (0) between
            %LGstart_prev and LGstop_next
            LPGon_num = sum(data.(LPGch).level(LPGtime_1:LPGtime_2) == 1); %returns the number of burst starts (between the last event before LGstart_curr and first event after LGstop_curr)
            LPGoff_num = sum(data.(LPGch).level(LPGtime_1:LPGtime_2) == 0); %returns the number of burst stops

            LPG_num1 = find(data.(LPGch).times>LGstart_curr,1,'first'); %determine the position of the first value that occurs after LGstart_curr

            if LPGtime_1 < LPGtime_end

                if LPG_num1-1 < length(data.(LPGch).times)
                    LPG_Event0 = data.(LPGch).level(LPG_num1 - 1); %determine the last level number that occurs before LGstart_curr
                    LPG_EvTime0 = data.(LPGch).times(LPG_num1 - 1);%determine the time of the last level number that occurs before LGstart_curr
                else
                    LPG_Event0 = data.(LPGch).level(end); %determine the last level number that occurs before LGstart_curr
                    LPG_EvTime0 = data.(LPGch).times(end);%determine the time of the last level number that occurs before LGstart_curr
                end
                if LPG_num1 < length(data.(LPGch).times)
                    LPG_Event1 = data.(LPGch).level(LPG_num1); %determine the level number (1 or 0) that occurs after LGstart_curr
                    LPG_EvTime1 = data.(LPGch).times(LPG_num1); %determine the time of the IC_Event1
                else
                    LPG_Event1 = data.(LPGch).level(end); %determine the level number (1 or 0) that occurs after LGstart_curr
                    LPG_EvTime1 = data.(LPGch).times(end); %determine the time of the IC_Event1
                end
                if LPG_num1 + 1 < length(data.(LPGch).times)
                    LPG_Event2 = data.(LPGch).level(LPG_num1 + 1); %determine the level number " " that occurs before LGstop_curr
                    LPG_EvTime2 = data.(LPGch).times(LPG_num1 + 1); %determine the time of the IC_Event2
                else
                    LPG_Event2 = data.(LPGch).level(end); %determine the level number " " that occurs before LGstop_curr
                    LPG_EvTime2 = data.(LPGch).times(end); %determine the time of the IC_Event2
                end
                if LPG_num1 + 2 < length(data.(LPGch).times)
                    LPG_Event3 = data.(LPGch).level(LPG_num1 + 2); %determine the level number that occurs after LGstop_curr
                    LPG_EvTime3 = data.(LPGch).times(LPG_num1 + 2); %determine the time of the level number that occurs after LGstop_curr
                else
                    LPG_Event3 = data.(LPGch).level(end); %determine the level number that occurs after LGstop_curr
                    LPG_EvTime3 = data.(LPGch).times(end); %determine the time of the level number that occurs after LGstop_curr
                end
                if LPG_num1 + 3 < length(data.(LPGch).times)
                    LPG_Event4 = data.(LPGch).level(LPG_num1 + 3); %determine the level number after Event3 that occurs after LGstart_curr
                    LPG_EvTime4 = data.(LPGch).times(LPG_num1 + 3); %determine the time of the level number that occurs after LGstart_curr
                else
                    LPG_Event4 = data.(LPGch).level(end); %determine the level number after Event3 that occurs after LGstart_curr
                    LPG_EvTime4 = data.(LPGch).times(end); %determine the time of the level number that occurs after LGstart_curr
                end


                %for cases where bursting might be tonic, these are some
                %possibilities:
                if LPG_Event0 == 1 && LPG_Event1 == 0 && LPG_EvTime1 > LGstop_curr %for cases when a burst starts before LGstart_curr and ends after LGstop_curr
                    LPG_Dur_ExtCycle = LPG_EvTime1 - LPG_EvTime0;
                elseif LPG_Event1 == 1 && LPG_Event2 == 0 && LPG_Event3 == 1 && LPG_EvTime2 > LGstop_next %for cases when a burst starts after LGstart_curr and ends after LGstop_next
                    LPG_Dur_ExtCycle = LPG_EvTime2 - LPG_EvTime1;
                elseif LPG_Event0 == 1 && LPG_Event1 == 0 && LPG_EvTime0 < LGstart_prev && LPG_EvTime1 > LGstart_curr %for cases when a burst starts well before the current LG cycle and ends within or after the current LG cycle
                    LPG_Dur_ExtCycle = LPG_EvTime1 - LPG_EvTime0;
                end

                %Categorize the LPG burst at the current LG cycle
                if    LPG_Event0 == 0 && LPG_Event1 == 0 && LPG_Event2 == 0 && LPG_Event3 == 0 && LPG_Event4 == 0
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S"; %give a false category for the last cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif    LPG_Event0 == 0 && LPG_Event1 == 1 && LPG_Event2 == 0 && LPG_Event3 == 0 && LPG_Event4 == 0
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S"; %give a false category for the last cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstart_curr && LPG_Event2 == 1 && LPG_EvTime2 < LGstop_curr && LPG_Event3 == 0 && LPG_EvTime3 < LGstop_curr
                    LPG_Ev0_Perc = abs((LGstart_curr - LPG_EvTime0) / (LGstart_curr - LGstart_prev));
                    if LPG_Ev0_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    elseif LPG_Ev0_Perc > 0.10
                        if LPG_EvTime4 < LGstop_curr
                            GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                            GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                        else
                            GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle
                            GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime0, LPG_EvTime1];
                        end
                    end
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstart_curr && LPG_Event2 == 1 && LPG_EvTime2 < LGstop_curr && LPG_Event3 == 0 && LPG_EvTime3 > LGstop_curr
                    LPG_Ev0_Perc = abs((LGstart_curr - LPG_EvTime0) / (LGstart_curr - LGstart_prev));
                    LPG_Ev2_Perc = abs((LGstop_curr - LPG_EvTime2) / LGstop_curr - LGstart_curr);
                    if LPG_Ev0_Perc > 0.10 && LPG_Ev2_Perc > 0.10 && LPG_EvTime3 < LGstop_next
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime2 LPG_EvTime3];
                    elseif LPG_Ev0_Perc < 0.10 && LPG_Ev2_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %for cases where there are more than one burst within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime0 LPG_EvTime1];
                    elseif LPG_Ev0_Perc < 0.10 && LPG_Ev2_Perc > 0.10 && LPG_EvTime3 < LGstop_next
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "U"; %for cases where there are more than one burst within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    elseif LPG_Ev0_Perc > 0.10 && LPG_Ev2_Perc < 0.10 && LPG_EvTime3 > LGstop_next
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    elseif LPG_Ev0_Perc > 0.10 && LPG_Ev2_Perc > 0.10 && LPG_EvTime3 > LGstop_next
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T"; %for cases where there are more than one burst within the current cycle - first burst starts before current cycle, secodn burst ends after the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    end
                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstart_curr && LPG_Event2 == 0 && LPG_EvTime2 <LGstop_curr && LPG_Event3 == 1 && LPG_EvTime3 < LGstop_curr && LPG_Event4 == 0 && LPG_EvTime4 < LGstop_curr
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "U"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstart_curr && LPG_Event2 == 0 && LPG_EvTime2 <LGstop_curr && LPG_Event3 == 1 && LPG_EvTime3 < LGstop_curr && LPG_Event4 == 0 && LPG_EvTime4 < LGstop_curr && LPG_EvTime4 < LGstop_next
                    LPG_EV3_Perc = abs((LGstop_curr - LPG_EvTime3) / (LGstop_curr - LGstart_curr));
                    if LPG_EV3_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "U"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    elseif LPG_EV3_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %for cases where a burst starts before the current cycle and a second burst starts and ends within the current cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                    end


                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstop_curr && LPG_Event0 == 0 && LPG_EvTime0 < LGstart_curr
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S"; %if the previous burst ended before the current LG cycle and the next burst starts after the current LG cycle then "S" for silent (there is no burst during LG cycle)
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstart_curr && LPG_EvTime1 < LGstop_curr && LPG_Event2 == 1 && LPG_EvTime2 > LGstop_curr  %for cases when a burst from the previous cycle ends in the current cycle and no new burst begins in the current cycle
                    LPG_Ev1_Perc = abs((LGstart_curr - LPG_EvTime0)/ (LGstart_curr-LGstart_prev)); %determine the percent of time that the neuron starts before LGstart_curr
                    if LPG_Ev1_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime0 LPG_EvTime1];
                    end
                elseif LPG_Event0 == 0 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 1 && LPG_EvTime1 < LGstop_curr && LPG_Event2 == 0 && LPG_EvTime2 > LGstop_curr && LPG_EvTime2 < LGstop_next
                    LPG_Ev1_Perc = abs((LGstop_curr - LPG_EvTime1)/ (LGstop_curr-LGstart_curr)); %determine the percent of time that the neuron starts before LGstop_curr
                    if LPG_Ev1_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                    end

                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstop_curr && LPG_Dur_ExtCycle > LG_Dur_Longest
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T"; %if the burst starts before LGstart_curr and ends after LGstop_curr and it is longer than 2 LG cycles, then this burst is tonic
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstart_curr && LPG_EvTime1 < LGstop_curr && LPG_Event2 == 0 && LPG_EvTime2 > LGstop_next && LPG_Dur_ExtCycle > LG_Dur_Longest
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T"; %if the burst starts after LGstart_curr and ends beyond LGstop_next such that the duration is longer than LG_Dur_Longest
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_prev && LPG_Event1 == 0 && LPG_EvTime1 > LGstop_next
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T"; %if the burst starts before the previous cycle and ends after the next cycle
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstop_next
                    LPG_Ev0_Perc = abs((LGstart_curr - LPG_EvTime0) / LGstart_curr - LGstart_prev);
                    if LPG_Ev0_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T"; %if the burst starts before the current cycle and ends after the next cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %if the burst starts before the current cycle and ends after the next cycle
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                    end

                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstart_curr && LPG_EvTime1 < LGstop_curr && LPG_Event2 == 0 && LPG_EvTime2 > LGstart_curr && LPG_EvTime2 < LGstop_curr
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C"; %if start and stop are within LG cycle, then coordinated
                    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 < LGstop_curr %condition when burst starts before current LG cycle
                    LPG_Ev0_Perc = abs((LGstart_curr - LPG_EvTime0)/ (LGstart_curr-LGstart_prev));
                    if LPG_Ev0_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                    end
                elseif LPG_Event1 == 1 && LPG_EvTime1 > LGstart_curr && LPG_EvTime1 < LGstop_curr && LPG_Event2 == 0 && LPG_EvTime2 > LGstop_curr && LPG_EvTime2 < LGstop_next %for cases when burst starts within current cycle and ends in the next cycle
                    LPG_Ev1_Perc = abs((LGstop_curr - LPG_EvTime1) / (LGstop_curr-LGstart_curr));
                    LPG_Ev2_Perc = abs((LGstop_curr - LPG_EvTime2)/ (LGstop_curr-LGstart_curr));
                    if LPG_Ev1_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime1 LPG_EvTime2];
                    elseif LPG_Ev1_Perc < 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "S";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    end
                elseif LPG_Event0 == 1 && LPG_EvTime0 < LGstart_curr && LPG_Event1 == 0 && LPG_EvTime1 > LGstop_curr && LPG_Dur_ExtCycle < LG_Dur_Longest %condition when IC starts before and ends after current cycle, and IC burst duration is less than LG cycle period
                    LPG_Ev0_Perc = abs((LGstart_curr - LPG_EvTime0) / (LGstop_curr - LGstart_curr));
                    LPG_Ev1_Perc = abs((LGstop_curr - LPG_EvTime1) / (LGstop_next - LGstop_curr));
                    if LPG_Ev0_Perc > 0.10 && LPG_Ev1_Perc > 0.10
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "C";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; LPG_EvTime0 LPG_EvTime1];
                    else
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "T";
                        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
                    end

                end
            else
                GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "F";
                GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
            end
        else
            GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(listnum,1) = "LPG missing";
            GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times; 0 0];
        end


        i_LG = i_LG - 3; %need to reset i_LG so that LGstart_curr is determined for the next LG cycle in the time window
        listnum = listnum + 1;
    end


    %% Put the categories from each neuron into a struct, so you can read across the pattern to determine the overall pattern (for "uncoordinated" ID, as above)
    GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,1) = GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat;
    GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,2) = GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat;
    GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,3) = GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat;
    %GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern = join(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern);



    GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [];
    [r, c] = size(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern);
    for i_row = 1:r
        C = 0; U = 0; T = 0; S = 0; LPG_Miss = 0;
        for i_col = 1:c
            if GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(i_row, i_col) == "C"
                C = C + 1;
            elseif GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(i_row, i_col) == "U"
                U = U + 1;
            elseif GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(i_row, i_col) == "T"
                T = T + 1;
            elseif GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(i_row, i_col) == "S"
                S = S + 1;
            elseif GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(i_row, i_col) == "LPG missing"
                LPG_Miss = LPG_Miss + 1;
            end
        end
        if C == 3 || C == 2 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "All Coordinated"];
        elseif U == 3 || U == 2 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "All Uncoordinated"];
        elseif U == 1 && C == 2 || U == 1 && C == 1 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "One Neuron Uncoordinated"];
        elseif T == 1 && C == 2 || T == 1 && C == 1 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "One Neuron Tonic"];
        elseif S == 1 && C == 2 || S == 1 && C == 1 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "One Neuron Silent"];
        elseif T == 3 || T == 2 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "All Tonic"];
        elseif S == 3 || S == 2 && LPG_Miss == 1
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "All Silent"];
        else
            GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category = [GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category; "All Uncoordinated"]; %Other combinations of silent, tonic, uncoordinated, and coordinated will get lumped into here
        end

        C = 0; U = 0; T = 0; S = 0; LPG_Miss = 0; %reset the counters to look at the next spots


        %Count Number of each category per neuron per experiment
        GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Coor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,1) == "C");
        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Coor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,2) == "C");
        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Coor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,3) == "C");

        GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Uncoor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,1) == "U");
        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Uncoor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,2) == "U");
        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Uncoor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,3) == "U");

        GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Silent = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,1) == "S");
        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Silent = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,2) == "S");
        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Silent = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,3) == "S");

        GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Tonic = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,1) == "T");
        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Tonic = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,2) == "T");
        GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Tonic = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).OverallPattern(:,3) == "T");

        %Count the number of cycles that present each category
        GMR_Categories.(GMR_Categories.exps{i_exp}).All_Coor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "All Coordinated");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).All_UnCoor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "All Uncoordinated");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).One_UnCoor = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "One Neuron Uncoordinated");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).One_Tonic = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "One Neuron Tonic");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).One_Silent = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "One Neuron Silent");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).All_Tonic = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "All Tonic");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;
        GMR_Categories.(GMR_Categories.exps{i_exp}).All_Silent = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).GMR_Category == "All Silent");% / length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time) * 100;

        ac(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).All_Coor;
        auc(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).All_UnCoor;
        ouc(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).One_UnCoor;
        ot(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).One_Tonic;
        os(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).One_Silent;
        at(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).All_Tonic;
        as(i_exp) = GMR_Categories.(GMR_Categories.exps{i_exp}).All_Silent;

        LGcycles(i_exp) = length(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr);

    end
    AllCoordinated = ac.';
    AllUnCoordinated = auc.';
    OneUncoordinated = ouc.';
    OneTonic = ot.';
    OneSilent = os.';
    AllTonic = at.';
    AllSilent = as.';

    GMR_Categories.AllCoordinated = [AllCoordinated];
    GMR_Categories.AllUnCoordinated = [AllUnCoordinated];
    GMR_Categories.OneUncoordinated = [OneUncoordinated];
    GMR_Categories.OneTonic = [OneTonic];
    GMR_Categories.OneSilent = [OneSilent];
    GMR_Categories.AllTonic = [AllTonic];
    GMR_Categories.AllSilent = [AllSilent];

    GMR_Categories.NumLGCycles = sum(LGcycles);

    %disp(LGcycles)

    %% Determine which LG cycles have coordinated GMR activity within the current experiment

    GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern = [];
    for i_pat = 1:length(GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat)
        if GMR_Categories.(GMR_Categories.exps{i_exp}).ICcat(i_pat) == "C" && GMR_Categories.(GMR_Categories.exps{i_exp}).DGcat(i_pat) == "C" && GMR_Categories.(GMR_Categories.exps{i_exp}).LPGcat(i_pat) == "C"
            Pattern = "C";
        else
            Pattern = "U"; %NOTE: this includes the end cycles that were labeled "F" for skipped (only 2 cycles)
        end
        GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern = [GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern; Pattern];
    end

    % HMMMMMM MAYBE I NEED TO ONLY WRITE UP THE CMOBOS THAT I CARE ABOUT
    % FOR EACH CATEGORY... BASED ON THE LIKELIHOOD THAT IT HAS BEEN
    % OBSERVED IN THE EXPERIMENTS THAT I WANT TO ANALYZE (FOR EXAMPLE, IT
    % IS A VERY LOW CHANCE THAT IC WOULD BE TONIC... SO I WOULD NOT INCLUDE
    % THAT AS A POSSIBLE COMBINATION FOR THE GMR PATTERN

    %Calculate the percent of all coordinated activity per LG cycle
    Total_Patterns = length(GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern);
    Num_Coordinated = sum(GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern == "C");
    GMR_Categories.(GMR_Categories.exps{i_exp}).Percent_Coordinated = Num_Coordinated/Total_Patterns; %percent of "C" out of the total within the experiment

    % bar(Percent_Coordinated);

    %Calculate phase for cycles that are coordinated
    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_AvgPhase = [];

    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_AvgPhase = [];

    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_AvgPhase = [];

    GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle = [];
    GMR_Categories.(GMR_Categories.exps{i_exp}).LG_AvgDutyCycle = [];

    %DON'T FORGET ABOUT ANNA'S PHLOTTER SCRIPT! (TO PLOT PHASE)
    for i_pat2 = 1:length(GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern)
        if GMR_Categories.(GMR_Categories.exps{i_exp}).Pattern(i_pat2) == "C"
            %calculate phase on and off for each LG cycle of "C"
            %IC Phase On and Off
    %        IC_On = (GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times(i_pat2, 1) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
     %       IC_Off = (GMR_Categories.(GMR_Categories.exps{i_exp}).IC_times(i_pat2, 2) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
%            GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase; IC_On IC_Off];
            %DG Phase On and Off
%            DG_On = (GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times(i_pat2, 1) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
 %           DG_Off = (GMR_Categories.(GMR_Categories.exps{i_exp}).DG_times(i_pat2, 2) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
    %        GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase; DG_On DG_Off];
            %LPG Phase On and Off
     %       LPG_On = (GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times(i_pat2, 1) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
      %      LPG_Off = (GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_times(i_pat2, 2) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2)) / GMR_Categories.(GMR_Categories.exps{i_exp}).LG_CP_curr(i_pat2);
     %       GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase; LPG_On LPG_Off];
            %LG Duty Cycle
            LG_Duty = GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time2(i_pat2) - GMR_Categories.(GMR_Categories.exps{i_exp}).LG_time(i_pat2);
            GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle = [GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle; LG_Duty];
        else
            GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase; 0 0];
            GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase; 0 0];
            GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase; 0 0];
            GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle = [GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle; 0];
        end
    end

    %Calculate Mean Phase On/Off and LG Duty Cycle
    IC_MeanPhaseOn = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase(:,[1])));%calculate mean phase on and off and asve those values in a field
    IC_MeanPhaseOff = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).IC_Phase(:,[2])));
    GMR_Categories.(GMR_Categories.exps{i_exp}).IC_AvgPhase = [GMR_Categories.(GMR_Categories.exps{i_exp}).IC_AvgPhase; IC_MeanPhaseOn IC_MeanPhaseOff];

    DG_MeanPhaseOn = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase(:,[1])));%calculate mean phase on and off and asve those values in a field
    DG_MeanPhaseOff = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).DG_Phase(:,[2])));
    GMR_Categories.(GMR_Categories.exps{i_exp}).DG_AvgPhase = [GMR_Categories.(GMR_Categories.exps{i_exp}).DG_AvgPhase; DG_MeanPhaseOn DG_MeanPhaseOff];

    LPG_MeanPhaseOn = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase(:,[1])));%calculate mean phase on and off and asve those values in a field
    LPG_MeanPhaseOff = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_Phase(:,[2])));
    GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_AvgPhase = [GMR_Categories.(GMR_Categories.exps{i_exp}).LPG_AvgPhase; LPG_MeanPhaseOn LPG_MeanPhaseOff];

    LG_MeanDuty = mean(nonzeros(GMR_Categories.(GMR_Categories.exps{i_exp}).LG_DutyCycle));
    GMR_Categories.(GMR_Categories.exps{i_exp}).LG_AvgDutyCycle = [GMR_Categories.(GMR_Categories.exps{i_exp}).LG_AvgDutyCycle; LG_MeanDuty];


    %Calculate total percent of each category from all exps
    %AllCoor = sum(GMR_Categories.AllCoordinated) / GMR_Categories.NumLGCycles * 100;
    %AllUncoor = sum(GMR_Categories.AllUnCoordinated) / GMR_Categories.NumLGCycles * 100;
    %OneUncoor = sum(GMR_Categories.OneUncoordinated) / GMR_Categories.NumLGCycles * 100;
    %OneTon = sum(GMR_Categories.OneTonic) / GMR_Categories.NumLGCycles * 100;
    %OneSil = sum(GMR_Categories.OneSilent) / GMR_Categories.NumLGCycles * 100;
    %AllTon = sum(GMR_Categories.AllTonic) / GMR_Categories.NumLGCycles * 100;
    %AllSil = sum(GMR_Categories.AllSilent) / GMR_Categories.NumLGCycles * 100;

    %stackthese = [AllCoor AllUncoor OneUncoor OneTon OneSil AllTon AllSil];

    %bar(1, stackthese.', 0.5, 'stack');
    %legend("All Coordinated", "All Uncoordinated", "One Neuron Uncoordinated", "One Neuron Tonic", "One Neuron Silent", "All Tonic", "All Silent")
    %ylabel("% Categories Expressed")












    %STUFF TO WORK ON IN THIS SCRIPT STILL:

    %CALCULATE AVG PHASE FOR ALL EXPS?? DO YOU WANT INDIVIDUAL PHASE PLOTS?
    %OR ONE CUMULATIVE PHASE PLOT?


    %EVENTUALLY, YOU WILL WANT TO COLLECT WHO IS SILENT/TONIC/COORDINATED
    %FREQUENCY OF OCCURRENCE TO DETERMINE WHO IS AFFECTED MORE BY LPG KILL

end


