function all_phasespikes_graphs
close all;
Phase_Spikes_DMB("SIFvsSIFKill","SIF");
Phase_Spikes_DMB("SIFvsSIFKill","SIFKill");
Phase_Spikes_DMB("SIFvsSIFPTX","SIF4SPTX");
Phase_Spikes_DMB("SIFvsSIFPTX","SIFPTX");
Phase_Spikes_DMB("SIFvsSIFPTXvsSIFPTXKill","SIF4SPKill");
Phase_Spikes_DMB("SIFvsSIFPTXvsSIFPTXKill","SIFPTX4SPKill");
Phase_Spikes_DMB("SIFvsSIFPTXvsSIFPTXKill","SPKill");

end