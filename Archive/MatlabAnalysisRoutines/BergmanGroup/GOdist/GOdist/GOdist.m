function varargout = GOdist(varargin)
% GODIST M-file for GOdist.fig
%      GODIST, by itself, creates a new GODIST or raises the existing
%      singleton*.
%
%      H = GODIST returns the handle to a new GODIST or the handle to
%      the existing singleton*.
%
%      GODIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GODIST.M with the given input arguments.
%
%      GODIST('Property','Value',...) creates a new GODIST or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before GOdist_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GOdist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GOdist

% Last Modified by GUIDE v2.5 24-May-2005 01:58:09
% YBS - 13 aug 04: Improved error catching and reporting



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GOdist_OpeningFcn, ...
    'gui_OutputFcn',  @GOdist_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GOdist is made visible.
function GOdist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GOdist (see VARARGIN)

% Choose default command line output for GOdist
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Look for the GOdist params mat in the directory of GOdist
A = which('GOdist');
[P F E] = fileparts(A);
paramsfile = [P filesep 'godist_params.mat'];
if exist(paramsfile) == 2
    D = load(paramsfile);
end
if isfield(D,'datadir')
    datadir = D.datadir;
    if exist(datadir) == 7
        set(handles.datadir_edit,'string',datadir);
    end
end
if isfield(D,'expname')
    expname = D.expname;
    set(handles.expname_edit,'string',expname);
end




% find which data files are there, we need:
% Make a flag for the files, mark in the appropriate data box the status
% If files are there, activate the relevant controls, including
% Analyze specific term
% Check GO dists


return
% UIWAIT makes GOdist wait for user response (see UIRESUME)
% uiwait(handles.main_win);


% --- Outputs from this function are returned to the command line.
function varargout = GOdist_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over
% pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes on button press in bp_button.
function bp_button_Callback(hObject, eventdata, handles)
% hObject    handle to bp_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bp_button
% Hint: get(hObject,'Value') returns toggle state of sel_minscore_button
if get(hObject,'Value')
    set(handles.mf_button,'Value',0);
    %set(handles.bp_button,'Value',0);
    set(handles.cc_button,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in mf_button.
function mf_button_Callback(hObject, eventdata, handles)
% hObject    handle to mf_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mf_button
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.bp_button,'Value',0);
    set(handles.cc_button,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in cc_button.
function cc_button_Callback(hObject, eventdata, handles)
% hObject    handle to cc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cc_button
if get(hObject,'Value')
    set(handles.mf_button,'Value',0);
    set(handles.bp_button,'Value',0);
    %set(handles.cc_button,'Value',0);
else
    set(hObject,'Value',1)
end



return


% --- Executes during object creation, after setting all properties.
function datadir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datadir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function datadir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to datadir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of datadir_edit as text
%        str2double(get(hObject,'String')) returns contents of datadir_edit as a double


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


currentdir = get(handles.datadir_edit,'string');
DN = uigetdir('c:\', 'Select main data directory');
if ~DN
    DN = currentdir;
end
set(handles.datadir_edit,'string',DN);

return


% --- Executes when user attempts to close main_win.
function main_win_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to main_win (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


A = which('GOdist');
[P F E] = fileparts(A);
paramsfile = [P filesep 'godist_params.mat'];
datadir = get(handles.datadir_edit,'string');
expname = get(handles.expname_edit,'string');


save(paramsfile,'datadir','expname');

% Hint: delete(hObject) closes the figure
delete(hObject);


return


% --- Executes during object creation, after setting all properties.
function expname_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function expname_edit_Callback(hObject, eventdata, handles)
% hObject    handle to expname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expname_edit as text
%        str2double(get(hObject,'String')) returns contents of expname_edit as a double

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in preprocess_button.
function preprocess_button_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get directory and experiment name 
datadir = get(handles.datadir_edit,'string');
expname = get(handles.expname_edit,'string');


% See if we have this directory and if not, let the user know about it
if ~(exist(datadir) == 7)
    er_str{1} = 'Invalid data directory specified';
    er_str{2} = 'Plase specify a valid path so GOdist can prepare the data';
    eh = errordlg(er_str,'GOdist');
    return
end

if isempty(expname)
    er_str{1} = 'No experiment name specified';
    er_str{2} = 'Plase specify an experiment name';
    eh = errordlg(er_str,'GOdist');
    return
end

% Construct names for the user supplied data files and check for existence
datafile = [datadir filesep expname '_data.xls'];  
ex(1) = (exist(datafile) == 2); exfile{1} = datafile;
scorefile = [datadir filesep expname '_scores.xls'];
ex(2) = (exist(scorefile) == 2); exfile{2} = scorefile;
UGfile = [datadir filesep expname '_UG.txt'];
ex(3) = (exist(UGfile) == 2); exfile{3} = UGfile;
IDfile = [datadir filesep expname '_ID.txt'];
ex(4) = (exist(IDfile) == 2); exfile{4} = IDfile;
CCfile = [datadir filesep 'component.ontology']; 
ex(5) = (exist(CCfile) == 2); exfile{5} = CCfile;
MFfile = [datadir filesep 'function.ontology']; 
ex(6) = (exist(MFfile) == 2); exfile{6} = MFfile;
BPfile = [datadir filesep 'process.ontology'];


ex(7) = (exist(BPfile) == 2); exfile{7} = BPfile;
CC_annot_file = [datadir filesep expname '_annot_CC.txt'];  
ex(8) = (exist(CC_annot_file) == 2); exfile{8} = CC_annot_file;
MF_annot_file = [datadir filesep expname '_annot_MF.txt'];  
ex(9) = (exist(MF_annot_file) == 2); exfile{9} = MF_annot_file;
BP_annot_file = [datadir filesep expname '_annot_BP.txt'];  
ex(10) = (exist(BP_annot_file) == 2); exfile{10} = BP_annot_file;

ex(2) = 1; % So that the non-obligatory scores file will not prevent data pre-processing

notex = ~ex;
% If we have any missing files
if sum(notex) 
    if sum(notex) == 1
        er_str{1} = ['The following user-supplied data file is missing:']; 
    else
        er_str{1} = ['The following user-supplied data files are missing:']; 
    end
    k = 2;
    for j = 1:length(notex)
        if ~ex(j)
            er_str{k} = exfile{j};
            k = k+ 1;
        end
        if sum(notex)== 1
            er_str{k} =  ['Please include this component so GOdist can prepare the data'];
        else
            er_str{k} =  ['Please include these components so GOdist can prepare the data'];
        end
    end
    eh = errordlg(er_str,'GOdist');
    return
end

DONT_ASK = 0;

% If the files are all there, prepare the data

%%% CC child parent matrix
outfile = [datadir filesep 'GO_CC_child_parent_mtx.mat'];
infile = [datadir filesep 'component.ontology'];
ErrorString{1} = ['Error during conversion of '];
ErrorString{2} = [infile ' to: '];
ErrorString{3} = [outfile];
ErrorString{4} = ['Please check that file is valid and try again'];
try
    if exist(outfile) == 2
        qstr{1} = [outfile];
        qstr{2} = ['already exists. Since creating it again may take a while,'];
        qstr{3} = ['what would you like to do?'];
        ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
        switch ButtonName
            case 'overwrite'
                wbH = waitbar(0,'');    
                set(wbH,'WindowStyle','modal');
                GOdist_make_relative_list(infile,outfile,'cc',wbH);   
                if exist('wbH');  close(wbH); end;
            case 'skip'
            case 'skip all existing files'
                DONT_ASK = 1;
            end
        elseif ~(exist(outfile) == 2)
            wbH = waitbar(0,'');
            set(wbH,'WindowStyle','modal');  
            GOdist_make_relative_list(infile,outfile,'cc',wbH);   
            if exist('wbH');  close(wbH); end;
        end
    catch
        ErrorString{5} = ['Failed with error: ' lasterr];
        eh = errordlg(ErrorString,'Error during preprocessing');
        if exist('wbH');  close(wbH); end;
        return
    end
    
    
    
    %%% BP child parent matrix
    outfile = [datadir filesep 'GO_BP_child_parent_mtx.mat'];
    infile = [datadir filesep 'process.ontology'];
    ErrorString{1} = ['Error during conversion of '];
    ErrorString{2} = [infile ' to: '];
    ErrorString{3} = [outfile];
    ErrorString{4} = ['Please check that file is valid and try again'];
    try
        if exist(outfile) == 2 & ~DONT_ASK
            qstr{1} = [outfile];
            qstr{2} = ['already exists. Since creating it again may take a while,'];
            qstr{3} = ['what would you like to do?'];
            ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
            switch ButtonName
                case 'overwrite'
                    wbH = waitbar(0,'');    
                    set(wbH,'WindowStyle','modal');
                    GOdist_make_relative_list(infile,outfile,'bp',wbH);   
                    if exist('wbH');  close(wbH); end;
                case 'skip'
                case 'skip all existing files'
                    DONT_ASK = 1;
                end        
            elseif ~(exist(outfile) == 2)
                wbH = waitbar(0,'');
                set(wbH,'WindowStyle','modal');
                GOdist_make_relative_list(infile,outfile,'bp',wbH);   
                if exist('wbH');  close(wbH); end;
            end
        catch
            ErrorString{5} = ['Failed with error: ' lasterr];
            eh = errordlg(ErrorString,'Error during preprocessing');
            if exist('wbH');  close(wbH); end;
            return
        end
        
        %%% MF child parent matrix
        outfile = [datadir filesep 'GO_MF_child_parent_mtx.mat'];
        infile = [datadir filesep 'function.ontology'];
        ErrorString{1} = ['Error during conversion of '];
        ErrorString{2} = [infile ' to: '];
        ErrorString{3} = [outfile];
        ErrorString{4} = ['Please check that file is valid and try again'];
        try
            if exist(outfile) == 2 & ~DONT_ASK
                qstr{1} = [outfile];
                qstr{2} = ['already exists. Since creating it again may take a while,'];
                qstr{3} = ['what would you like to do?'];
                ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                switch ButtonName
                    case 'overwrite'
                        wbH = waitbar(0,'');    
                        set(wbH,'WindowStyle','modal');
                        GOdist_make_relative_list(infile,outfile,'mf',wbH);   
                        if exist('wbH');  close(wbH); end;
                    case 'skip'
                    case 'skip all existing files'
                        DONT_ASK = 1;
                    end
                elseif ~(exist(outfile) == 2)
                    wbH = waitbar(0,'');
                    set(wbH,'WindowStyle','modal');
                    GOdist_make_relative_list(infile,outfile,'mf',wbH);   
                    if exist('wbH');  close(wbH); end;
                end
            catch
                ErrorString{5} = ['Failed with error: ' lasterr];
                eh = errordlg(ErrorString,'Error during preprocessing');
                if exist('wbH');  close(wbH); end;
                return
            end
            
            
            %%% CC annotation file
            outfile = [datadir filesep expname '_annot_cc.mat'];
            infile  = [datadir filesep expname '_annot_cc.txt'];
            ErrorString{1} = ['Error during conversion of '];
            ErrorString{2} = [infile ' to: '];
            ErrorString{3} = [outfile];
            ErrorString{4} = ['Please check that file is valid and try again'];
            try
                if exist(outfile) == 2 & ~DONT_ASK
                    qstr{1} = [outfile];
                    qstr{2} = ['already exists. Since creating it again may take a while,'];
                    qstr{3} = ['what would you like to do?'];
                    ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                    switch ButtonName
                        case 'overwrite'  
                            wbH = waitbar(0,'');    
                            set(wbH,'WindowStyle','modal');
                            GODIST_parse_annotation_file('cc',infile,outfile,wbH);
                            if exist('wbH');  close(wbH); end;
                        case 'skip'
                        case 'skip all existing files'
                            DONT_ASK = 1;
                        end
                    elseif ~(exist(outfile) == 2)
                        wbH = waitbar(0,'');
                        set(wbH,'WindowStyle','modal');
                        GODIST_parse_annotation_file('cc',infile,outfile,wbH);
                        if exist('wbH');  close(wbH); end;
                    end
                catch
                    ErrorString{5} = ['Failed with error: ' lasterr];
                    eh = errordlg(ErrorString,'Error during preprocessing');
                    if exist('wbH');  close(wbH); end;
                    return
                end
                
                
                %%% MF annotation file
                outfile = [datadir filesep expname '_annot_mf.mat'];
                infile  = [datadir filesep expname '_annot_mf.txt'];
                ErrorString{1} = ['Error during conversion of '];
                ErrorString{2} = [infile ' to: '];
                ErrorString{3} = [outfile];
                ErrorString{4} = ['Please check that file is valid and try again'];
                try
                    if exist(outfile) == 2 & ~DONT_ASK
                        qstr{1} = [outfile];
                        qstr{2} = ['already exists. Since creating it again may take a while,'];
                        qstr{3} = ['what would you like to do?'];
                        ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                        switch ButtonName
                            case 'overwrite'
                                wbH = waitbar(0,'');    
                                set(wbH,'WindowStyle','modal');
                                GODIST_parse_annotation_file('mf',infile,outfile,wbH);
                                if exist('wbH');  close(wbH); end;
                            case 'skip'
                            case 'skip all existing files'
                                DONT_ASK = 1;
                            end
                        elseif ~(exist(outfile) == 2)
                            wbH = waitbar(0,'');
                            set(wbH,'WindowStyle','modal');
                            GODIST_parse_annotation_file('mf',infile,outfile,wbH);
                            if exist('wbH');  close(wbH); end;
                        end
                    catch
                        ErrorString{5} = ['Failed with error: ' lasterr];
                        eh = errordlg(ErrorString,'Error during preprocessing');
                        if exist('wbH');  close(wbH); end;
                        return
                    end
                    
                    %%% BP annotation file
                    outfile = [datadir filesep expname '_annot_bp.mat'];
                    infile  = [datadir filesep expname '_annot_bp.txt'];
                    ErrorString{1} = ['Error during conversion of '];
                    ErrorString{2} = [infile ' to: '];
                    ErrorString{3} = [outfile];
                    ErrorString{4} = ['Please check that file is valid and try again'];
                    try
                        if exist(outfile) == 2 & ~DONT_ASK
                            qstr{1} = [outfile];
                            qstr{2} = ['already exists. Since creating it again may take a while,'];
                            qstr{3} = ['what would you like to do?'];
                            ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                            switch ButtonName
                                case 'overwrite'           
                                    wbH = waitbar(0,'');    
                                    set(wbH,'WindowStyle','modal');
                                    GODIST_parse_annotation_file('bp',infile,outfile,wbH);
                                    if exist('wbH');  close(wbH); end;
                                case 'skip'
                                case 'skip all existing files'
                                    DONT_ASK = 1;                
                                end
                            elseif ~(exist(outfile) == 2)
                                wbH = waitbar(0,'');
                                set(wbH,'WindowStyle','modal');                   
                                GODIST_parse_annotation_file('bp',infile,outfile,wbH);
                                if exist('wbH');  close(wbH); end;
                            end
                        catch
                            ErrorString{5} = ['Failed with error: ' lasterr];
                            eh = errordlg(ErrorString,'Error during preprocessing');
                            if exist('wbH');  close(wbH); end;
                            return
                        end
                        
                        
                        
                        %%% CC terms file
                        outfile = [datadir filesep 'GO_cc_terms.mat'];
                        infile = [datadir filesep 'component.ontology'];
                        ErrorString{1} = ['Error during conversion of '];
                        ErrorString{2} = [infile ' to: '];
                        ErrorString{3} = [outfile];
                        ErrorString{4} = ['Please check that file is valid and try again'];
                        try
                            if exist(outfile) == 2 & ~DONT_ASK
                                qstr{1} = [outfile];
                                qstr{2} = ['already exists. Since creating it again may take a while,'];
                                qstr{3} = ['what would you like to do?'];
                                ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                                switch ButtonName
                                    case 'overwrite'
                                        wbH = waitbar(0,'');    
                                        set(wbH,'WindowStyle','modal');
                                        GOdist_make_terms_file(infile,outfile,'cc',wbH);
                                        if exist('wbH');  close(wbH); end;
                                    case 'skip'
                                    case 'skip all existing files'
                                        DONT_ASK = 1;
                                    end
                                elseif ~(exist(outfile) == 2)
                                    wbH = waitbar(0,'');
                                    set(wbH,'WindowStyle','modal');
                                    GOdist_make_terms_file(infile,outfile,'cc',wbH);
                                    if exist('wbH');  close(wbH); end;
                                end
                            catch
                                ErrorString{5} = ['Failed with error: ' lasterr];
                                eh = errordlg(ErrorString,'Error during preprocessing');
                                if exist('wbH');  close(wbH); end;
                                return
                            end
                            
                            
                            %%% MF terms file
                            outfile = [datadir filesep 'GO_mf_terms.mat'];
                            infile = [datadir filesep 'function.ontology'];
                            ErrorString{1} = ['Error during conversion of '];
                            ErrorString{2} = [infile ' to: '];
                            ErrorString{3} = [outfile];
                            ErrorString{4} = ['Please check that file is valid and try again'];
                            try
                                if exist(outfile) == 2 & ~DONT_ASK
                                    qstr{1} = [outfile];
                                    qstr{2} = ['already exists. Since creating it again may take a while,'];
                                    qstr{3} = ['what would you like to do?'];
                                    ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                                    switch ButtonName
                                        case 'overwrite'   
                                            wbH = waitbar(0,'');    
                                            set(wbH,'WindowStyle','modal');
                                            GOdist_make_terms_file(infile,outfile,'mf',wbH);
                                            if exist('wbH');  close(wbH); end;
                                        case 'skip'
                                        case 'skip all existing files'
                                            DONT_ASK = 1;
                                        end
                                    elseif ~(exist(outfile) == 2)
                                        wbH = waitbar(0,'');
                                        set(wbH,'WindowStyle','modal');
                                        GOdist_make_terms_file(infile,outfile,'mf',wbH);
                                        if exist('wbH');  close(wbH); end;
                                    end    
                                catch
                                    ErrorString{5} = ['Failed with error: ' lasterr];
                                    eh = errordlg(ErrorString,'Error during preprocessing');
                                    if exist('wbH');  close(wbH); end;
                                    return
                                end
                                
                                %%% BP terms file
                                outfile = [datadir filesep 'GO_bp_terms.mat'];
                                infile = [datadir filesep 'process.ontology'];
                                ErrorString{1} = ['Error during conversion of '];
                                ErrorString{2} = [infile ' to: '];
                                ErrorString{3} = [outfile];
                                ErrorString{4} = ['Please check that file is valid and try again'];
                                try
                                    if exist(outfile) == 2 & ~DONT_ASK
                                        qstr{1} = [outfile];
                                        qstr{2} = ['already exists. Since creating it again may take a while,'];
                                        qstr{3} = ['what would you like to do?'];
                                        ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip all existing files','skip');
                                        switch ButtonName
                                            case 'overwrite'   
                                                wbH = waitbar(0,'');    
                                                set(wbH,'WindowStyle','modal');
                                                GOdist_make_terms_file(infile,outfile,'bp',wbH);
                                                if exist('wbH');  close(wbH); end;
                                            case 'skip'
                                            case 'skip all existing files'
                                                DONT_ASK = 1;
                                            end
                                        elseif ~(exist(outfile) == 2)
                                            wbH = waitbar(0,'');
                                            set(wbH,'WindowStyle','modal');
                                            GOdist_make_terms_file(infile,outfile,'bp',wbH);
                                            if exist('wbH');  close(wbH); end;
                                        end    
                                    catch
                                        ErrorString{5} = ['Failed with error: ' lasterr];
                                        eh = errordlg(ErrorString,'Error during preprocessing');
                                        if exist('wbH');  close(wbH); end;
                                        return
                                    end
                                    
                                    
                                    % % Make expression data for analysis
                                    outfile = [datadir filesep expname '_array_data.mat'];     % File with all information
                                    ErrorString{1} = ['Error while reading array input data '];
                                    ErrorString{2} = ['please check the validity of the following files:'];
                                    ErrorString{3} = [datafile];
                                    ErrorString{4} = [scorefile];
                                    ErrorString{5} = [UGfile];
                                    ErrorString{6} = [IDfile];
                                    try
                                        if exist(outfile) == 2 & ~DONT_ASK
                                            qstr{1} = [outfile];
                                            qstr{2} = ['already exists. Since creating it again may take a while,'];
                                            qstr{3} = ['what would you like to do?'];
                                            ButtonName=questdlg(qstr,'GOdist file exists','overwrite','skip','skip');
                                            switch ButtonName
                                                case 'overwrite'   
                                                    wbH = waitbar(0,'');    
                                                    set(wbH,'WindowStyle','modal');
                                                    GOdist_get_expression_data(expname,datadir,outfile,wbH);
                                                    if exist('wbH');  close(wbH); end;
                                                case 'skip'
                                                case 'skip all existing files'
                                                    DONT_ASK = 1;
                                                end
                                            elseif ~(exist(outfile) == 2)
                                                wbH = waitbar(0,'');
                                                set(wbH,'WindowStyle','modal');
                                                GOdist_get_expression_data(expname,datadir,outfile,wbH);
                                                if exist('wbH');  close(wbH); end;
                                            end    
                                        catch
                                            ErrorString{7} = ['Failed with error: ' lasterr];
                                            eh = errordlg(ErrorString,'Error during preprocessing');
                                            if exist('wbH');  close(wbH); end;
                                            return
                                        end
                                        
                                        
                                        
                                        return
                                        
                                        
                                        
                                        
                                        % --- Executes on button press in sel_mean_button.
                                        function sel_mean_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_mean_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value') returns toggle state of sel_mean_button
                                        
                                        if get(hObject,'Value')
                                            set(handles.sel_maxscore_button,'Value',0);
                                            set(handles.sel_minscore_button,'Value',0);
                                            set(handles.sel_lowest_button,'Value',0);
                                            set(handles.sel_highest_button,'Value',0);
                                            set(handles.sel_median_button,'Value',0);
                                            %set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        return
                                        
                                        
                                        % --- Executes on button press in sel_median_button.
                                        function sel_median_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_median_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value') returns toggle state of sel_median_button
                                        if get(hObject,'Value')
                                            set(handles.sel_maxscore_button,'Value',0);
                                            set(handles.sel_minscore_button,'Value',0);
                                            set(handles.sel_lowest_button,'Value',0);
                                            set(handles.sel_highest_button,'Value',0);
                                            %set(handles.sel_median_button,'Value',0);
                                            set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        
                                        % --- Executes on button press in sel_all_button.
                                        function sel_all_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_all_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        
                                        
                                        % --- Executes on button press in sel_highest_button.
                                        function sel_highest_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_highest_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value')
                                        % returns toggle state of sel_highest_button
                                        if get(hObject,'Value')
                                            set(handles.sel_maxscore_button,'Value',0);
                                            set(handles.sel_minscore_button,'Value',0);
                                            set(handles.sel_lowest_button,'Value',0);
                                            %set(handles.sel_highest_button,'Value',0);
                                            set(handles.sel_median_button,'Value',0);
                                            set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        
                                        % --- Executes on button press in sel_lowest_button.
                                        function sel_lowest_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_lowest_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value') returns toggle state of sel_lowest_button
                                        if get(hObject,'Value')
                                            set(handles.sel_maxscore_button,'Value',0);
                                            set(handles.sel_minscore_button,'Value',0);
                                            %set(handles.sel_lowest_button,'Value',0);
                                            set(handles.sel_highest_button,'Value',0);
                                            set(handles.sel_median_button,'Value',0);
                                            set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        
                                        % --- Executes on button press in sel_minscore_button.
                                        function sel_minscore_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_minscore_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value') returns toggle state of sel_minscore_button
                                        if get(hObject,'Value')
                                            set(handles.sel_maxscore_button,'Value',0);
                                            %set(handles.sel_minscore_button,'Value',0);
                                            set(handles.sel_lowest_button,'Value',0);
                                            set(handles.sel_highest_button,'Value',0);
                                            set(handles.sel_median_button,'Value',0);
                                            set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        
                                        % --- Executes on button press in sel_maxscore_button.
                                        function sel_maxscore_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to sel_maxscore_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Hint: get(hObject,'Value') returns toggle state of sel_maxscore_button
                                        
                                        if get(hObject,'Value')
                                            %set(handles.sel_maxscore_button,'Value',0);
                                            set(handles.sel_minscore_button,'Value',0);
                                            set(handles.sel_lowest_button,'Value',0);
                                            set(handles.sel_highest_button,'Value',0);
                                            set(handles.sel_median_button,'Value',0);
                                            set(handles.sel_mean_button,'Value',0);    
                                            set(handles.apply_selection_button,'Enable','on');
                                        else
                                            set(hObject,'Value',1)
                                        end
                                        
                                        
                                        % --- Executes on button press in quit_button.
                                        function quit_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to quit_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        
                                        
                                        % --- Executes on button press in help_button.
                                        function help_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to help_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        A = which('GOdist');
                                        [P F E] = fileparts(A);
                                        
                                        %winopen([P filesep 'godist instructions.htm'])
                                        %lilach 
                                        winopen([P filesep 'godist new instructions.htm'])
                                        
                                        % --- Executes on button press in about.
                                        function about_Callback(hObject, eventdata, handles)
                                        % hObject    handle to help_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        A = which('GOdist');
                                        [P F E] = fileparts(A);
                                        
                                        %winopen([P filesep 'godist instructions.htm'])
                                        %lilach 
                                        winopen([P filesep 'GOdist about.htm'])
                                        
                                        % --- Executes on button press in run_button.
                                        function run_button_Callback(hObject, eventdata, handles)
                                        % hObject    handle to run_button (see GCBO)
                                        % eventdata  reserved - to be defined in a future version of MATLAB
                                        % handles    structure with handles and user data (see GUIDATA)
                                        
                                        % Get directory and experiment name 
                                        datadir = get(handles.datadir_edit,'string');
                                        expname = get(handles.expname_edit,'string');
                                        
                                        
                                        infile = [datadir filesep expname '_selected_data.mat'];
                                        % Get ontology
                                        if get(handles.mf_button,'Value');
                                            ontology = 'mf';
                                            outfile = [datadir filesep expname '_MF_GO_analysis.xls'];
                                        elseif get(handles.bp_button,'Value');
                                            ontology = 'bp';
                                            outfile = [datadir filesep expname '_BP_GO_analysis.xls'];
                                        elseif get(handles.cc_button,'Value');
                                            ontology = 'cc';
                                            outfile = [datadir filesep expname '_CC_GO_analysis.xls'];
                                        end
                                        
                                        % Get threshold method
                                        if get(handles.fixed_thresh_button,'Value');
                                            thresh_method = 'fixed';
                                            thresh_value  = str2num(get(handles.fold_thresh_edit,'string'));
                                        else 
                                            thresh_method = 'percent';
                                            thresh_value  = str2num(get(handles.percent_changed_edit,'string'));
                                        end
                                       
                                            p_value  = str2num(get(handles.P_value_edit,'string'));
                                       
                                        infile = [datadir filesep expname '_selected_data.mat'];     % File with all information
                                        ErrorString{1} = ['Error while comparing GO distributions '];
                                        ErrorString{2} = ['Make sure that:'];
                                        ErrorString{3} = ['All required data files exist and are valid'];
                                        ErrorString{4} = ['Preprocessing has been succesfully performed'];
                                        ErrorString{5} = ['A data selection method has been applied'];
                                        try
                                            if exist(outfile) == 2 
                                                qstr{1} = [ontology ' GO analysis output file already exists'];
                                                qstr{2} = ['what would you like to do?'];
                                                ButtonName=questdlg(qstr,'Output file exists','overwrite','cancel','cancel');
                                                switch ButtonName
                                                    case 'overwrite'   
                                                        wbH = waitbar(0,'');    
                                                        set(wbH,'WindowStyle','modal');
                                                        GOdist_run_both_methods(infile,outfile,expname,datadir,ontology,thresh_method,thresh_value,wbH,p_value);
                                                        if exist('wbH');  close(wbH); end;
                                                    end
                                                elseif ~(exist(outfile) == 2)
                                                    wbH = waitbar(0,'');
                                                    set(wbH,'WindowStyle','modal');
                                                    GOdist_run_both_methods(infile,outfile,expname,datadir,ontology,thresh_method,thresh_value,wbH,p_value);
                                                    if exist('wbH');  close(wbH); end;
                                                end
                                            catch
                                                ErrorString{6} = ['Failed with error: ' lasterr];
                                                eh = errordlg(ErrorString,'GOdist error');
                                                if exist('wbH');  close(wbH); end;
                                                return
                                            end
                                            
                                            
                                            return
                                            
                                            % --- Executes on button press in make_list_button.
                                            function make_list_button_Callback(hObject, eventdata, handles)
                                            % hObject    handle to make_list_button (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    structure with handles and user data (see GUIDATA)
                                            
                                            
                                            % --- Executes on button press in compare_transcripts_button_button.
                                            function compare_transcripts_button_Callback(hObject, eventdata, handles)
                                            % hObject    handle to compare_transcripts_button_button (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    structure with handles and user data (see GUIDATA)
                                            
                                            
                                            % Get directory and experiment
                                            % name 
                                            datadir = get(handles.datadir_edit,'string');
                                            expname = get(handles.expname_edit,'string');
                                            
                                            
                                            % Get go ID
                                            GOterm = str2num(get(handles.GO_id_data_edit,'string'));
                                            
                                            % Get ontology
                                            if get(handles.mf_button_1,'Value');
                                                ontology = 'mf';
                                                outfile = [datadir filesep expname '_MF_GO_analysis.xls'];
                                            elseif get(handles.bp_button_1,'Value');
                                                ontology = 'bp';
                                                outfile = [datadir filesep expname '_BP_GO_analysis.xls'];
                                            elseif get(handles.cc_button_1,'Value');
                                                ontology = 'cc';
                                                outfile = [datadir filesep expname '_CC_GO_analysis.xls'];
                                            end
                                            
                                            % Get threshold method
                                            if get(handles.fixed_thresh_button,'Value');
                                                thresh_method = 'fixed';
                                                thresh_value  = str2num(get(handles.fold_thresh_edit,'string'));
                                            else 
                                                thresh_method = 'percent';
                                                thresh_value  = str2num(get(handles.percent_changed_edit,'string'));
                                            end
                                            
                                            infile = [datadir filesep expname '_selected_data.mat'];     % File with all information
                                            ErrorString{1} = ['Error while comparing a specific GO term '];
                                            ErrorString{2} = ['Make sure that:'];
                                            ErrorString{3} = ['All required data files exist and are valid'];
                                            ErrorString{4} = ['Preprocessing has been succesfully performed'];
                                            ErrorString{5} = ['A data selection method has been applied'];
                                            try
                                                GOdist_analyze_specific_go_term(infile,expname,datadir,ontology,GOterm,thresh_method,thresh_value);
                                            catch
                                                ErrorString{6} = ['Failed with error: ' lasterr];
                                                eh = errordlg(ErrorString,'GOdist error');
                                                return
                                            end
                                            
                                            
                                            return
                                            
                                            
                                            
                                            % --- Executes during object creation, after setting all properties.
                                            function ID_edit_CreateFcn(hObject, eventdata, handles)
                                            % hObject    handle to ID_edit (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    empty - handles not created until after all CreateFcns called
                                            
                                            % Hint: edit controls usually have a white background on Windows.
                                            %       See ISPC and COMPUTER.
                                            if ispc
                                                set(hObject,'BackgroundColor','white');
                                            else
                                                set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                            end
                                            
                                            
                                            
                                            
                                            
                                            function ID_edit_Callback(hObject, eventdata, handles)
                                            % hObject    handle to ID_edit (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    structure with handles and user data (see GUIDATA)
                                            
                                            % Hints: get(hObject,'String') returns contents of ID_edit as text
                                            %        str2double(get(hObject,'String')) returns contents of ID_edit as a double
                                            
                                            val = get(hObject,'string');
                                            num = str2num(val);
                                            if isempty(num)
                                                errordlg('Threshold value must be numerical');
                                                set(hObject,'string','1706');
                                            elseif (rem(num,1) > 0)
                                                errordlg('GO ID must be an integer');
                                                set(hObject,'string','1706');
                                            end
                                            % Update handles structure
                                            guidata(hObject, handles);
                                            
                                            
                                            
                                            % --- Executes on button press in apply_selection_button.
                                            function apply_selection_button_Callback(hObject, eventdata, handles)
                                            % hObject    handle to apply_selection_button (see GCBO)
                                            % eventdata  reserved - to be defined in a future version of MATLAB
                                            % handles    structure with handles and user data (see GUIDATA)
                                            
                                            % Get directory and experiment name 
                                            datadir = get(handles.datadir_edit,'string');
                                            expname = get(handles.expname_edit,'string');
                                            
                                            % Check for existence of processed data files
                                            infile = [datadir filesep expname '_array_data.mat'];
                                            if ~(exist(infile)==2)
                                                ErrorString{1} = ['GOdist cannot select transcripts because the file '];
                                                ErrorString{2} = [infile];
                                                ErrorString{3} = ['does not exist'];
                                                eh = errordlg(ErrorString,'GOdist error');
                                                return
                                            end
                                            
                                            % get selection method
                                            if get(handles.sel_maxscore_button,'Value');
                                                selection_method = 'max_score';
                                            elseif get(handles.sel_minscore_button,'Value');
                                                selection_method = 'min_score';
                                            elseif get(handles.sel_lowest_button,'Value');
                                                selection_method = 'min_data';
                                            elseif get(handles.sel_highest_button,'Value');
                                                selection_method = 'max_data';
                                            elseif get(handles.sel_median_button,'Value');
                                                selection_method = 'median';
                                            elseif get(handles.sel_mean_button,'Value');    
                                                selection_method = 'mean';
                                            end
                                            
                                            infile = [datadir filesep expname '_array_data.mat'];     % File with all information
                                            outfile = [datadir filesep expname '_selected_data.mat'];     % File with all information
                                            ErrorString{1} = ['Error while applying selection rule '];
                                            ErrorString{2} = ['please check the validity of all array specific data files'];
                                            try
                                                if exist(outfile) == 2 
                                                    qstr{1} = ['Selected data already exists'];
                                                    qstr{2} = ['what would you like to do?'];
                                                    ButtonName=questdlg(qstr,'Selected data exists','overwrite','cancel','cancel');
                                                    switch ButtonName
                                                        case 'overwrite'   
                                                            wbH = waitbar(0,'');    
                                                            set(wbH,'WindowStyle','modal');
                                                            GOdist_select_transcripts(infile,outfile,selection_method,wbH);
                                                            if exist('wbH');  close(wbH); end;
                                                        end
                                                    elseif ~(exist(outfile) == 2) 
                                                        wbH = waitbar(0,'');
                                                        set(wbH,'WindowStyle','modal');
                                                        GOdist_select_transcripts(infile,outfile,selection_method,wbH);
                                                        if exist('wbH');  close(wbH); end;
                                                    end
                                                    % Inactivate selection rule button
                                                    set(handles.apply_selection_button,'Enable','off');
                                                catch
                                                    ErrorString{3} = ['Failed with error: ' lasterr];
                                                    eh = errordlg(ErrorString,'GOdist error');
                                                    if exist('wbH');  close(wbH); end;
                                                    return
                                                end
                                                
                                                
                                                return
                                                
                                                
                                                % --- Executes on button press in fixed_thresh_button.
                                                function fixed_thresh_button_Callback(hObject, eventdata, handles)
                                                % hObject    handle to fixed_thresh_button (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    structure with handles and user data (see GUIDATA)
                                                
                                                % Hint: get(hObject,'Value') returns toggle state of fixed_thresh_button
                                                if get(hObject,'Value')
                                                    %    set(handles.fixed_thresh_button,'Value',0);
                                                    set(handles.frac_thresh_button,'Value',0);
                                                else
                                                    set(hObject,'Value',1)
                                                end
                                                % Update handles structure
                                                guidata(hObject, handles);
                                                
                                                
                                                % --- Executes on button press in frac_thresh_button.
                                                function frac_thresh_button_Callback(hObject, eventdata, handles)
                                                % hObject    handle to frac_thresh_button (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    structure with handles and user data (see GUIDATA)
                                                
                                                % Hint: get(hObject,'Value') returns toggle state of frac_thresh_button
                                                if get(hObject,'Value')
                                                    set(handles.fixed_thresh_button,'Value',0);
                                                    %    set(handles.frac_thresh_button,'Value',0);
                                                else
                                                    set(hObject,'Value',1)
                                                end
                                                % Update handles structure
                                                guidata(hObject, handles);
                                                
                                                
                                                % --- Executes during object creation, after setting all properties.
                                                function fold_thresh_edit_CreateFcn(hObject, eventdata, handles)
                                                % hObject    handle to fold_thresh_edit (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    empty - handles not created until after all CreateFcns called
                                                
                                                % Hint: edit controls usually have a white background on Windows.
                                                %       See ISPC and COMPUTER.
                                                if ispc
                                                    set(hObject,'BackgroundColor','white');
                                                else
                                                    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                end
                                                
                                                
                                                
                                                function fold_thresh_edit_Callback(hObject, eventdata, handles)
                                                % hObject    handle to fold_thresh_edit (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    structure with handles and user data (see GUIDATA)
                                                
                                                % Hints: get(hObject,'String') returns contents of fold_thresh_edit as text
                                                %        str2double(get(hObject,'String')) returns contents of fold_thresh_edit as a double
                                                
                                                val = get(hObject,'string');
                                                num = str2num(val);
                                                if isempty(num)
                                                    errordlg('Threshold value must be numerical');
                                                    set(hObject,'string','1');
                                                elseif ~(num > 0)
                                                    errordlg('Threshold value must be larger than 0');
                                                    set(hObject,'string','1');
                                                end
                                                % Update handles structure
                                                guidata(hObject, handles);
                                                
                                                
                                                
                                                % --- Executes during object creation, after setting all properties.
                                                function percent_changed_edit_CreateFcn(hObject, eventdata, handles)
                                                % hObject    handle to percent_changed_edit (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    empty - handles not created until after all CreateFcns called
                                                
                                                % Hint: edit controls usually have a white background on Windows.
                                                %       See ISPC and COMPUTER.
                                                if ispc
                                                    set(hObject,'BackgroundColor','white');
                                                else
                                                    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
                                                end
                                                
                                                
                                                
                                                function percent_changed_edit_Callback(hObject, eventdata, handles)
                                                % hObject    handle to percent_changed_edit (see GCBO)
                                                % eventdata  reserved - to be defined in a future version of MATLAB
                                                % handles    structure with handles and user data (see GUIDATA)
                                                
                                                % Hints: get(hObject,'String') returns contents of percent_changed_edit as text
                                                %        str2double(get(hObject,'String')) returns contents of percent_changed_edit as a double
                                                
                                                val = get(hObject,'string');
                                                num = str2num(val);
                                                if isempty(num)
                                                    errordlg('Threshold value must be numerical');
                                                    set(hObject,'string','5');
                                                elseif ~(num <= 15& num > 0)
                                                    errordlg('Threshold value must be between 0 and 15%');
                                                    set(hObject,'string','5');
                                                end
                                                % Update handles structure
                                                guidata(hObject, handles);
                                                
                                                
                                                
                                                
                                                
                                                
                                                


% --- Executes on button press in create_hist_button_button.
function create_hist_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_hist_button_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 % Get directory and experiment name 

      
        datadir = get(handles.datadir_edit,'string');
        expname = get(handles.expname_edit,'string');
                                            
        % Get go ID
        GOterm = str2num(get(handles.GO_id_data_edit,'string'));
                                            
        % get (handles.buttonX,'value') returns 1 (true) if the button is marked
        % and 0 (false) otherwise
        
        % Get ontology
        if get(handles.mf_button_1,'Value');
          ontology = 'mf';
        elseif get(handles.bp_button_1,'Value');
            ontology = 'bp';
        elseif get(handles.cc_button_1,'Value');
            ontology = 'cc';
        end
        
        if get(handles.log_2_button,'Value');
            log_value = 2;
        elseif get(handles.log_10_button,'Value');
            log_value = 10;
        end
            
         %if get(handles.sel_N_button,'Value');
           %  Y_indicator = 'N';
            % elseif (get(handles.sel_percent_button,'Value'));
              %    Y_indicator = 'percent';    
        % end;
 
       try
           GOdist_create_hist(expname,datadir,ontology,GOterm,log_value);
       catch
           %ErrorString{7} = ['Failed with error: ' lasterr];
           ErrorString1{1} = ['Failed with error: ' lasterr];
           eh = errordlg(ErrorString1,'GOdist error');
           return
       end
      

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in sel_N_button.
function sel_N_button_Callback(hObject, eventdata, handles)
% hObject    handle to sel_N_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_N_button
 
 if get(hObject,'Value')
    set(handles.sel_percent_button,'Value',0);
 else
      set(handles.sel_percent_button,'Value',1);
 
 end; 


% --- Executes on button press in sel_N_button.
function sel_percent_button_Callback(hObject, eventdata, handles)
% hObject    handle to sel_N_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_N_button

if get(hObject,'Value')
    set(handles.sel_N_button,'Value',0);
else
      set(handles.sel_N_button,'Value',1);
end




% --- Executes on button press in get_list_of_genes_button.
function get_list_of_genes_button_Callback(hObject, eventdata, handles)
    
     % Get directory and experiment name 
     datadir = get(handles.datadir_edit,'string');
     expname = get(handles.expname_edit,'string');
      GOtermSTR = get(handles.GO_id_genes_list_edit,'string');                                       
      % Get go ID
      GOterm = str2num(get(handles.GO_id_genes_list_edit,'string'));
                                            
      % Get ontology
      if get(handles.mf_button_1,'Value');
           ontology = 'mf';
           %outfile = [datadir filesep expname '_MF_' GOterm '_GO_analysis.xls'];
      elseif get(handles.bp_button_1,'Value');
           ontology = 'bp';
           %outfile = [datadir filesep expname '_BP_' GOterm '_GO_analysis.xls'];
      elseif get(handles.cc_button_1,'Value');
           ontology = 'cc';
           %outfile = [datadir filesep expname '_CC_' GOterm '_GO_analysis.xls'];
      end
        outfile = [datadir filesep expname '_' GOtermSTR  '_list_of_genes.xls'];                                
       infile = [datadir filesep expname '_selected_data.mat'];     % File with all information
       ErrorString{1} = ['Error while getting list of genes of term '];
       ErrorString{2} = ['Make sure that:'];
       ErrorString{3} = ['All required data files exist and are valid'];
       ErrorString{4} = ['Preprocessing has been succesfully performed'];
       ErrorString{5} = ['A data selection method has been applied'];
       try
             GOdist_get_all_genes_with_term_button(expname,outfile,datadir,ontology,GOterm);
       catch
               ErrorString{6} = ['Failed with error: ' lasterr];
                eh = errordlg(ErrorString,'GOdist error');
        return
    end
% hObject    handle to get_list_of_genes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function hist_ID_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to hist_ID_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hist_ID_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of hist_ID_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function hist_ID_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hist_ID_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function term_id_edit_2_Callback(hObject, eventdata, handles)
% hObject    handle to term_id_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of term_id_edit_2 as text
%        str2double(get(hObject,'String')) returns contents of term_id_edit_2 as a double


% --- Executes during object creation, after setting all properties.
function term_id_edit_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to term_id_edit_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function GO_id_p_val_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_p_val as text
%        str2double(get(hObject,'String')) returns contents of GO_id_p_val as a double


% --- Executes during object creation, after setting all properties.
function GO_id_p_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in create_hist_button.
function create_hist_Callback(hObject, eventdata, handles)
% hObject    handle to create_hist_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sel_N_button.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to sel_N_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_N_button


% --- Executes on button press in sel_percent_button.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to sel_percent_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_percent_button


% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18


% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20


% --- Executes on button press in get_list_of_genes_button.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to get_list_of_genes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in get_significant_button_terms.
function get_significant_button_Callback(hObject, eventdata, handles)
% hObject    handle to get_significant_button_terms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

  % Get directory and experiment name 
     datadir = get(handles.datadir_edit,'string');
     expname = get(handles.expname_edit,'string');
                                            
      % Get P-value
      p_val = str2num(get(handles.P_value_edit,'string'));
                                            
      % Get ontology
      if get(handles.mf_button_2,'Value');
          
           ontology = 'MF';
           outfile = [datadir filesep expname '_MF_GO_analysis.xls'];
      elseif get(handles.bp_button_2,'Value');
           
           ontology = 'BP';
           outfile = [datadir filesep expname '_BP_GO_analysis.xls'];
      elseif get(handles.cc_button_2,'Value');
           
           ontology = 'CC';
           outfile = [datadir filesep expname '_CC_GO_analysis.xls'];
      end
       infile = [datadir filesep expname '_' ontology '_GO_analysis.xls'];     % File with all information
       ErrorString{1} = ['Error while creating significant terms list '];
       ErrorString{2} = ['Make sure that:'];
       ErrorString{3} = ['analysis file exist and is valid'];
       ErrorString{4} = ['A data selection method has been applied'];
       try
             GOdist_get_significant_terms(ontology,expname,datadir,p_val);
       catch
               ErrorString{5} = ['Failed with error: ' lasterr];
                eh = errordlg(ErrorString,'GOdist error');
        return
       end

function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sel_larger_p.
function sel_larger_p_Callback(hObject, eventdata, handles)
% hObject    handle to sel_larger_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_larger_p


% --- Executes on button press in sel_smaller_p.
function sel_smaller_p_Callback(hObject, eventdata, handles)
% hObject    handle to sel_smaller_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_smaller_p


% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23


% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24


% --- Executes on button press in radiobutton25.
function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton25



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function GO_id_p_val_term_parent_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_term_parent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_p_val_term_parent as text
%        str2double(get(hObject,'String')) returns contents of GO_id_p_val_term_parent as a double


% --- Executes during object creation, after setting all properties.
function GO_id_p_val_term_parent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_term_parent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GO_id_p_val_hist_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_p_val_hist as text
%        str2double(get(hObject,'String')) returns contents of GO_id_p_val_hist as a double


% --- Executes during object creation, after setting all properties.
function GO_id_p_val_hist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GO_id_p_val_genes_list_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_genes_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_p_val_genes_list as text
%        str2double(get(hObject,'String')) returns contents of GO_id_p_val_genes_list as a double


% --- Executes during object creation, after setting all properties.
function GO_id_p_val_genes_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_p_val_genes_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mf_button_1.
function mf_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to mf_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mf_button_1

if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.bp_button_1,'Value',0);
    set(handles.cc_button_1,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in bp_button_1.
function bp_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to bp_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bp_button_1
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.mf_button_1,'Value',0);
    set(handles.cc_button_1,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in cc_button_1.
function cc_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to cc_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cc_button_1
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.bp_button_1,'Value',0);
    set(handles.mf_button_1,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in mf_button_2.
function mf_button_2_Callback(hObject, eventdata, handles)
% hObject    handle to mf_button_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mf_button_2
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.bp_button_2,'Value',0);
    set(handles.cc_button_2,'Value',0);
else
    set(hObject,'Value',1)
end

% --- Executes on button press in bp_button_2.
function bp_button_2_Callback(hObject, eventdata, handles)
% hObject    handle to bp_button_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bp_button_2
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.mf_button_2,'Value',0);
    set(handles.cc_button_2,'Value',0);
else
    set(hObject,'Value',1)
end


% --- Executes on button press in cc_button_2.
function cc_button_2_Callback(hObject, eventdata, handles)
% hObject    handle to cc_button_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cc_button_2
if get(hObject,'Value')
    %set(handles.mf_button,'Value',0);
    set(handles.bp_button_2,'Value',0);
    set(handles.mf_button_2,'Value',0);
else
    set(hObject,'Value',1)
end

function GO_id_data_edit_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_data_edit as text
%        str2double(get(hObject,'String')) returns contents of GO_id_data_edit as a double


% --- Executes during object creation, after setting all properties.
function GO_id_data_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GO_id_hist_edit_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_hist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_hist_edit as text
%        str2double(get(hObject,'String')) returns contents of GO_id_hist_edit as a double


% --- Executes during object creation, after setting all properties.
function GO_id_hist_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_hist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GO_id_genes_list_edit_Callback(hObject, eventdata, handles)
% hObject    handle to GO_id_genes_list_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GO_id_genes_list_edit as text
%        str2double(get(hObject,'String')) returns contents of GO_id_genes_list_edit as a double


% --- Executes during object creation, after setting all properties.
function GO_id_genes_list_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GO_id_genes_list_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function P_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to P_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_value_edit as text
%        str2double(get(hObject,'String')) returns contents of P_value_edit as a double


% --- Executes during object creation, after setting all properties.
function P_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in log_10_button.
function log_10_button_Callback(hObject, eventdata, handles)
% hObject    handle to log_10_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of log_10_button
 if get(hObject,'Value')
       set(handles.log_2_button,'Value',0);    
       set(handles.apply_selection_button,'Enable','on');
 else
       set(hObject,'Value',1)
 end

% --- Executes on button press in log_2_button.
function log_2_button_Callback(hObject, eventdata, handles)
% hObject    handle to log_2_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of log_2_button
if get(hObject,'Value')
       set(handles.log_10_button,'Value',0);    
       set(handles.apply_selection_button,'Enable','on');
 else
       set(hObject,'Value',1)
 end

% --------------------------------------------------------------------
%function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in about.
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


