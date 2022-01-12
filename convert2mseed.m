function convert2mseed(direc, filenames)
% convert2mseed(direc, filenames) 
%
% Converts all SAC files in a folder to mseed files.
%
% INPUT:
% 
% direc            Directory where SAC files are stored
% filenames        String array of filenames
%
% NOTE:
%
% Requires sac2mseed. See https://github.com/iris-edu/sac2mseed for more details.
%
% Last modified by pdabney@princeton.edu, 01/12/22

% Make command sequence -  Go to specified location where the SAC files are stored and convert to mseed files
switch nargin
  case 2
    files = sprintf(' %s',filenames);
    tcom=sprintf('cd %s ; sac2mseed%s', direc, files);
  case 1
    tcom=sprintf('cd %s ; sac2mseed *', direc);
end

% Execute the command sequence
system(sprintf('%s',tcom));


end

