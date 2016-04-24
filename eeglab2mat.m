% =========================================================================
% Convert EEGlab dataset to SignalPlant
% =========================================================================
%
% This function takes current EEGlab dataset and converts it into a *.mat 
% file that SignalPlant can read.
%
% It reads in the 'EEG' variable directly from workspace. This means that
% EEGlab needs to be running and have some dataset loaded.
%
% It also exports the markers in a *.sel file, readable by SignalPlant.
%
% =========================================================================

function [] = eeglab2mat()

% ============================== STEP 1 ===================================
% Save EEGlab dataset as *.mat file (SignalPlant format)
% =========================================================================

% Check that the EEG variable is present
try
    eeg     = evalin('base', 'eval(''EEG'', ''defaultVar'')');
    fname   = eeg.filename(1:(end - 3));
    eegdata = eeg.data';
    sfreq   = eeg.srate;
catch
    error('There is no EEG variable in your workspace (probably because EEGlab is not running).')
end

% Check that there are channel names
if size(eeg.chanlocs, 1) == 0

    % With no channel names present, export just eeg data
    fprintf('No channel names present - exporting numbers instead.\n')
    save(strcat(fname, 'mat'), 'eegdata')

else
    
    % Get channel names and add units
    channelnames = {eeg.chanlocs.labels};
    units        = repmat({'mV'}, 1, size(channelnames, 2));
    
    % Save
    save(strcat(fname, 'mat'), 'eegdata', ...
        'sfreq', 'channelnames', 'units')
end

% =============================== STEP 2 ==================================
% Save markers into a *.sel file (SignalPlant format)
% =========================================================================

% Get variables
index = (1:size({eeg.event.type}, 2))';
left  = round(cell2mat({eeg.event.latency}'));
right = round(cell2mat({eeg.event.latency}'));
group = zeros(index(end), 1);
valid = zeros(index(end), 1);
chind = ones(index(end), 1);            % 1
chnam = repmat({'%'}, index(end), 1);   % pouze '%'
info  = {eeg.event.type}';

% Combine them into a table
marks = table(index, left, right, group, valid, chind, chnam, info);
marks = table2cell(marks);

% Get header
header = strcat('%%SignalPlant ver.:1.2.1.22\r\n', ...
    '%%Selection export from file:\r\n', ...
    '%%', strcat(fname, 'mat'), '\r\n', ...
    '%%SAMPLING_FREQ [Hz]:', sfreq, '\r\n', ...
    '%%----------------------------------------\r\n', ...
    '%%Structure:\r\n', ...
    '%%Index[-], Start[sample], End[sample], Group[-], Validity[-], Channel Index[-], Channel name[string], Info[string]\r\n', ...
    '%%Divided by: ASCII char no. 9\r\n', ...
    '%%DATA------------------------------------\r\n');

% Set output format for fprintf ('%s' for a string; '%d' for an integer)
format = '%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\r\n';

% Open file connection and write header and markers
fid = fopen(strcat(fname, 'sel'), 'w');
fprintf(fid, header);

[nrows, ncols] = size(marks);
for row = 1:nrows
    fprintf(fid, format, marks{row, :});
end

fclose(fid);

end