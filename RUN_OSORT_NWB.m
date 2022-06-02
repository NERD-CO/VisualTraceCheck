%% TO RUN OSORT-NWB


%% Step 1a Make sure matnwb is ON YOUR PATH (all sub-folders)

%% Step 1b Make sure OSort_NWB is ON YOUR PATH (Top Folder)

%% Step 1c Make sure OSort_NWB/osort-v4-rel is ON YOUR PATH (all sub-folders)

%% Step 2 Create a new folder for spike sorting a session
% i.e., C:/Documents/Data/Study1/SpikeSorting/Session1

%% Step 3 Inside NEW folder create an 'nwb' folder
% i.e., C:/Documents/Dat/Study1/SpikeSorting/Session1/nwb

%% Step 4 Copy and past the NWB file of interest and '+types' folder from NWB repo folder
% ONLY copy over the RAW version of the NWB 
% For example:
% In your new folder you should have the following:
% -- /+types
% -- /MW1_Session_2_raw.nwb

%% Step 5 Change the following input arguments:
% basepath 
% -- This should be the outer folder you created in STEP 2
basepath = 'C:/Documents/Data/Study1/SpikeSorting/Session1\';
patientID = 'MW_1';
nwbFname = 'MW1_Session_2_raw.nwb';

%% Step 6 Run the main Function

OSort_RunFun_css("basePath",basepath,"patientID",patientID,"nwbFILE",nwbFname)