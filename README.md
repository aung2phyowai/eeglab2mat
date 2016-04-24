# eeglab2mat
### Convert EEGlab dataset to SignalPlant

This function takes an [EEGlab](http://sccn.ucsd.edu/eeglab/) dataset (`*.set` and `*.fdt` files) and converts it into a `*.mat` file that [SignalPlant](https://signalplant.codeplex.com/) can read.

It reads currently loaded dataset by reading the 'EEG' variable directly from workspace. This means that EEGlab needs to be running and have some dataset loaded. [Matlab](http://www.mathworks.com/products/matlab/) needs to be installed in order for the `*.mat` import by SignalPlant to work (the import calls Matlab's command line).

It also exports the markers in a `*.sel` file, readable by SignalPlant.
