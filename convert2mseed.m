function convert2mseed(direc)
% 
% Converts all SAC files in a folder to mseed files.
%
% INPUT:
% 
% direc            Directory where SAC files are stored
%
% NOTE:
%
% Requires sac2mseed. See https://github.com/iris-edu/sac2mseed for more details.
%
% Last modified by pdabney@princeton.edu, 1/5/22

% Make command sequence
% Go to specified location where the SAC files are stored and convert to mseed files
tcom=sprintf('cd %s ; sac2mseed *', direc);

% Execute the command sequence
system(sprintf('%s',tcom));


end

