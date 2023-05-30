function [out1 out2] = Phase_forValuestoPlotwSpike2(struct)

exps = struct.exps; %gather the experiments you want to sort data from

ind_phase = []; ind_degree = []; ind_radian = []; LG_CPs = []; phase = []; exp_mn_phase = []; exp_mn_deg = []; exp_mn_rad = []; %start empty arrays to store data
SEM_phase = []; NumCoor = []; phase1 = [];

for i_exps = 1:length(exps) %index through each experiment in the exps list
    LG_CP = struct.(struct.exps{i_exps}).LG_CP_curr;
    LG_ON = struct.(struct.exps{i_exps}).LG_time;
    LG_OFF = struct.(struct.exps{i_exps}).LG_time2;

    IC_time1 = struct.(struct.exps{i_exps}).IC_times(:,1);
    IC_time2 = struct.(struct.exps{i_exps}).IC_times(:,2);

    DG_time1 = struct.(struct.exps{i_exps}).DG_times(:,1);
    DG_time2 = struct.(struct.exps{i_exps}).DG_times(:,2);

    LPG_time1 = struct.(struct.exps{i_exps}).LPG_times(:,1);
    LPG_time2 = struct.(struct.exps{i_exps}).LPG_times(:,2);

    GMR_Cat = struct.(struct.exps{i_exps}).GMR_Category;


    for i = 1:length(GMR_Cat)

        if GMR_Cat(i) == "All Coordinated" %if the index is labeled as all coordinated...
            %... caluclate the values listed below and convert into
            %degrees...

            LG_CycPer = LG_CP(i);
            LG_PhaseOFF = (LG_OFF(i) - LG_ON(i)) / LG_CP(i);
            if LG_PhaseOFF > 2 || LG_PhaseOFF < 0
                 LG_PhaseOFF = NaN;
            end

            IC_PhaseON = (IC_time1(i) - LG_ON(i)) / LG_CP(i);
            if IC_PhaseON < -0.2
                IC_PhaseON = NaN;
            end

            IC_PhaseOFF = (IC_time2(i) - LG_ON(i)) / LG_CP(i);
            if IC_PhaseOFF > 2 || IC_PhaseOFF < 0
                IC_PhaseOFF = NaN;
            end

            DG_PhaseON = (DG_time1(i) - LG_ON(i)) / LG_CP(i);
           % if DG_PhaseON < -0.2
           %     DG_PhaseON = NaN;
           % end

            DG_PhaseOFF = (DG_time2(i) - LG_ON(i)) / LG_CP(i);
            if DG_PhaseOFF > 2 || DG_PhaseOFF < 0
                DG_PhaseOFF = NaN;
            end

            LPG_PhaseON = (LPG_time1(i) - LG_ON(i)) / LG_CP(i);
            if LPG_PhaseON < -0.2
                LPG_PhaseON = NaN;
            end

            LPG_PhaseOFF = (LPG_time2(i) - LG_ON(i)) / LG_CP(i);
            if LPG_PhaseOFF > 2 || LPG_PhaseOFF < 0
                LPG_PhaseOFF = NaN;
            end

            %...And place them into a table to access for plotting phase
            phase = [phase; LG_PhaseOFF IC_PhaseON IC_PhaseOFF DG_PhaseON DG_PhaseOFF LPG_PhaseON LPG_PhaseOFF];
            phase1 = [phase1; LG_PhaseOFF IC_PhaseON IC_PhaseOFF DG_PhaseON DG_PhaseOFF LPG_PhaseON LPG_PhaseOFF];

        end

        %struct.(struct.exps{i_exps}).PHASE = phase; %attempting to add a
        %new field to each exp field w/in the struct

        out1 = phase;

    end

    if isempty(phase1) %if there is no data in the phase1 array, continue to the next loop...
        ...for instances where there are no LG cycles with "All Coordinated" patterns
        continue
    else

        mnLG_PhaseOFF = mean(phase1(:,1), 'omitnan');
        mnIC_PhaseON = mean(phase1(:,2), 'omitnan');
        mnIC_PhaseOFF = mean(phase1(:,3), 'omitnan');
        mnDG_PhaseON = mean(phase1(:,4), 'omitnan');
        mnDG_PhaseOFF = mean(phase1(:,5), 'omitnan');
        mnLPG_PhaseON = mean(phase1(:,6), 'omitnan');
        mnLPG_PhaseOFF = mean(phase1(:,7), 'omitnan');

        exp_mn_phase = [exp_mn_phase; mnLG_PhaseOFF mnIC_PhaseON mnIC_PhaseOFF mnDG_PhaseON mnDG_PhaseOFF mnLPG_PhaseON mnLPG_PhaseOFF];

        out2 = exp_mn_phase;

        phase1 = [];
    end
end