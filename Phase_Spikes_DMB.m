function Phase_Spikes_DMB(Condition,subcondition)
%this will plot the  # of spikes per bin (100 bins hard coded as
%binsize) as a function of the phase of a reference neuron
%it sums the # of bins across all cycles of the reference neuron

%the reference neuron is the first one in neurons array below

%this uses matlab files exported from spike2, with spk and level
%channels, ie spikes and bursts already made in spike2

%it currently needs to load a struct that has a list of the matlab file
%names (the spk/lvl channels) for each condition; it loads each matlab file
%into the data struct to work on it, all spk/lvl channels for all neurons
%are contained within 1 file for each condition per experiment

%based on the organization when i wrote this, there is a condition and then
%subconditions, it could be combined to "condition" to simplify things at
%some point; it just means that the list of experiments is in the
%subcondition at this point.

%there are two examples below to use in command window, but use all_phasespikes_graphs function
% to run all 7 conditions

%Phase_Spikes_DMB("SIFvsSIFKill","SIF")
%Phase_Spikes_DMB("SIFvsSIFKill","SIFKill")
%

%by Dawn Blitz 8/31/23
%added in normalizing to the total number of spikes per neuron, per prep


load('N:\My Drive\GoogleDriveDocuments(10-9-17)\MATLAB\PhaseSpikes\Phase_Spikes_Data.mat');

filepath=append("N:\My Drive\GoogleDriveDocuments(10-9-17)\MATLAB\PhaseSpikes\", Condition, "\", subcondition, "\");
%filepath=append("N:\Shared drives\Blitz Lab\SavannaFahoum\SRHF_DMB_Manuscripts\Data Analysis\Degeneracy_Data\SPKvPhase_Data_and_Code\FFvsPhase_SpkBurChannels copy\", Condition, "\", subcondition, "\");

%Phase_Spikes_Data.SIFvSIFkill.SIF
label = [];
neurons=["LG", "IC", "DG", "LPG"]; %NOTE: first neuron in list=ref neuron
Phase_Spikes_Output=[];



for i_file=1: length(Phase_Spikes_Data.(Condition).(subcondition))
    data=[]; % this clears the struct
    filename=append(filepath, (Phase_Spikes_Data.(Condition).(subcondition)(i_file)));
    data=load(filename);

    refneuron = append(Phase_Spikes_Data.(Condition).(subcondition)(i_file), "_",neurons(1), "lvl");  %first neuron is the reference neuron


    startfile=find(data.(refneuron).level==1,1,'first');
    endfile=find(data.(refneuron).level==1,1,'last');

    i_cycle=startfile;

    while i_cycle<endfile

        next=i_cycle + 1;
        endcycle=find(data.(refneuron).level(next:end)==1,1, 'first'); %find next burst start after current one to identify burst end
        endcycle=endcycle + i_cycle; %above returns how rows after, so need to add to i_cycle to get the correct row number
        cycletime=(data.(refneuron).times(endcycle)-data.(refneuron).times(i_cycle));%determine duration of a burst
        binsize=cycletime/100; %determine bin size for this cycle

        for i_neurons=1:length(neurons) %neuron1=reference neuron but include its spikes in analysis
            spkneuron= append(Phase_Spikes_Data.(Condition).(subcondition)(i_file), "_", neurons(i_neurons), "spk");

            is=isfield(data, spkneuron); %does this file have this neuron with spks
            if is==1;
                binstart=data.(refneuron).times(i_cycle);

                for i_bin=1:99
                    binstop=binstart+binsize;
                    %count how many spk times starting at binstart and ending before binstop
                    num=find(data.(spkneuron).times>=binstart & data.(spkneuron).times<binstop); %the first time higher/equalt to start of this bin
                    %numb=find(data.(spkneuron).times<binstop,1,'last')%the last time lower than the end of this bin
                    %numspks=numb-num
                    spkcount=length(num);
                    data.(spkneuron).bincount(i_bin,1)=spkcount; %put this information in the correct location
                    binstart=binstop;
                end

                if i_cycle==startfile; %on first cycle, place the numbers in there
                    Phase_Spikes_Output.(neurons{i_neurons}).bins(:,i_file)=data.(spkneuron).bincount;
                else %on subsequent cycles, add the new numbers to the old numbers
                    Phase_Spikes_Output.(neurons{i_neurons}).bins(:,i_file) = Phase_Spikes_Output.(neurons{i_neurons}).bins(:,i_file) + data.(spkneuron).bincount(:,1);
                end
            end

        end

        i_cycle=i_cycle+1;
        if data.(refneuron).level(i_cycle)==0
            i_cycle=i_cycle+1;
        end

    end

    endfile=find(data.(refneuron).level(next:end)==1,1); %check if there are more bursts or not
    t=isempty(endfile);

end



x=[1:99];
FigX = figure;

for i_neurons=1:length(neurons)
    subplot(4,1,i_neurons);

    %First, normalize to the total # of spikes for that neuron for that prep
    for i_plot=1:length(Phase_Spikes_Data.(Condition).(subcondition))
        check=isfield(Phase_Spikes_Output, (neurons{i_neurons})); %make sure the neuron field exists (missing LPG in kills)
        if check==1
            tempsum=sum(Phase_Spikes_Output.(neurons{i_neurons}).bins(1:end,i_plot)); %add up all the spikes for this neuron/this exp
            Phase_Spikes_Output.(neurons{i_neurons}).Norm(:,i_plot)=(Phase_Spikes_Output.(neurons{i_neurons}).bins(1:end,i_plot)/tempsum)*100; %normalize to total # spks
        end
    end
        %Then, plot each exp (normalized)
        for i_plot=1:length(Phase_Spikes_Data.(Condition).(subcondition))
            check=isfield(Phase_Spikes_Output, (neurons{i_neurons})); %make sure the neuron field exists (missing LPG in kills)
            if check==1
                y=Phase_Spikes_Output.(neurons{i_neurons}).Norm(:,i_plot);
                plot(x,y);
                hold on
                %divide each set of bins for each exp into thirds to do
                %stats on
                colstart=1;
                colend=33;
               for i_third=1:3
                Phase_Spikes_Output.(neurons{i_neurons}).Stats(i_plot,i_third)=sum(Phase_Spikes_Output.(neurons{i_neurons}).Norm(colstart:colend,i_plot));
                colstart=colend+1;
                colend=colstart+32;
               end               
            end
        end


        ylabel(neurons(i_neurons));

    %end
    xlabel('Bins');

    graphtitle=append((Condition), "  ",(subcondition));
    sgtitle(graphtitle); %sgtitle = title at top of several subplots

    %Size it and save it
    fig = gcf;  %gets the current figure
    fig.Units='inches';
    fig.Position(3:4)= [1.9,3.8];  %fig.position returns left/right top/bottom width and height so fig.Position(3:4) lets me set the width and height
    figfile=append(graphtitle,".pdf");    
    figx=gca; %get current axes
    set(figx, 'TickDir','out');
    check=isfield(Phase_Spikes_Output, (neurons{i_neurons})); %make sure the neuron field exists (missing LPG in kills)
    if check==1
        Phase_Spikes_Output.(neurons{i_neurons}).Norm(:,i_plot+1)=mean(Phase_Spikes_Output.(neurons{i_neurons}).Norm, 2,'omitnan'); %average across rows , that's what the 2 is for, 'omitnan' removes the NaN if there were 0 spks (0/total=NaN)
        y2=Phase_Spikes_Output.(neurons{i_neurons}).Norm(:,i_plot+1);
        plot(x,y2, 'k','LineWidth', 2); %plot the mean
    end

    exportgraphics(FigX, figfile, 'ContentType', 'vector');
end

savename=append("Phase_Spikes_Output",Condition, subcondition);
save(savename, "Phase_Spikes_Output");