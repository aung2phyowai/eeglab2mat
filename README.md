# eeglab2mat
### Convert EEGlab dataset to SignalPlant

This function takes current [EEGlab](http://sccn.ucsd.edu/eeglab/) dataset and converts it into a `*.mat` file that [SignalPlant](https://signalplant.codeplex.com/) can read.

It reads in the 'EEG' variable directly from workspace. This means that EEGlab needs to be running and have some dataset loaded. [Matlab](http://www.mathworks.com/products/matlab/) needs to be installed in order for the `*.mat` import by SignalPlant to work (the import calls Matlab's command line).

It also exports the markers in a `*.sel` file, readable by SignalPlant.
