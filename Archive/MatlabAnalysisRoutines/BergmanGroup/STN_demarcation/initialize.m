clear;

%ALL
nucleus = ['S'];        % 'S'=STN, 'V'=Vim, 'G'=Gpi
CALCULATE=1;            % do matlab calculations and save results to file
PLOT=1;                 % if =1, each trajectory is plotted
DO_ALL=0;               % PSD.RMS.GON - do all TRAJECTORIES despite XLS configuration.
global SUMMARY; SUMMARY=0;                      % plot STN / goniometer summary (!!!if SUMMARY, CALCULATE=0)
global PLOT_forpub; PLOT_forpub=1;              % prepares figures for publication
global f_resolution; f_resolution = 3;          % samples per Hz
global cutoff_freq; cutoff_freq = [2 200];      % Defines normalization range. cutoff_freq(2) included in filename (allows saving multiple runs). %f>[..] - not saved. f<[..] still saved.
global plot_freq; plot_freq = [3 200];          % for the post_STN plots (must be within cutoff_freq limits)
global WARNINGS; WARNINGS=1;
global VERBOSE; VERBOSE =0;
global USE_MAT; USE_MAT=0;              %use maT files (ONLY if done manual stab analysis!)/maP files. For HMM: use the RMS calculated with maP/maT.
global AUTO_STAB; AUTO_STAB=1;          %do automatic stability analysis if maP files selected

%For RMS and PSD
DO_BOTH_ELECs=0;                        % to use both ELECS despite XLS configuration
global ONLY_STN; ONLY_STN=0;            % means only calculate the PSD within the STN (o/w whole trajectory)
global Num_forNorm; Num_forNorm = 10;   % number of RMS values to use for normalization (if 0 - use RMS values till STN-entry)

%for PSD
global logscale; logscale =1;           %(0 or 1) plots PSD in logscale (freq. is always log)
global mean_PSD_resolution; mean_PSD_resolution=100;
global DO_GONIOM_PSD; DO_GONIOM_PSD=1;  % calculate PSD of the goniometer signal.

%for goniom
global goniom_cutoff; goniom_cutoff=[2 20];
global joints; joints=[1 2];            %1=wrist 2=elbow
