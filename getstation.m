function varargout = getstation(direc, tstart, tend, net, sta, loc, cha,ofile)
% [sta_query]=GETSTATION(direc, tstart, tend, net, sta, loc, cha, ofile)
%
% Obtains a list of stations and station data 
% and stores information in an STATIONS text file.
%
% Input:
%
% direc              Directory where the output file will be stored
% tstart             Start data (format: 'yyyy-MM-ddTHH:mm:ss')
% tend               End date (format: 'yyyy-MM-ddTHH:mm:ss')
% net                Network name (e.g. 'IU' or '*')
% sta                Station name (e.g. 'ANMO' or '*')
% loc                Location code (e.g. '00')
% cha                Channel name (e.g. 'BHZ', 'BH?' or '*')
% ofile              Optional output filename
%
% Ouput:
% 
% sta_query          URL query (can entered in search bar)       
%
% Note:
%
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 01/24/2022

% To get data from IRIS Web Services
staurl = 'http://service.iris.edu/fdsnws/station/1/';
outputf = 'text';

datetime.setDefaultFormats('defaultdate', 'yyyy-MM-dd')
% Define default values
defval('tstart', strcat(string(datetime('yesterday')),'T00:00:00'))
defval('tend', strcat(string(datetime('today')), 'T00:00:00'))
defval('network','IU')
defval('station','*')
defval('location','00')
defval('channel','BH?')

% Format url event query 
paramform='query?net=%s&sta=%s&loc=%s&cha=%s&starttime=%s&endtime=%s&level=station&format=%s&includecomments=true&nodata=404';
myparams = sprintf(paramform, net, sta, loc, cha, tstart, tend, outputf);
sta_query = strcat(staurl, myparams);

% Obtain query output contents
query_output = webread(sta_query);

% Check request
opt = weboptions('Timeout',60);
if isempty(query_output) 
    error('Error 404 NOT_FOUND: No data found')
end

% Create to store event info
switch nargin
  case 7
    filename = sprintf('%s.txt',ofile);
  case 8
    tdate = string(datetime('today'), 'yyyy.MM.dd');
    filename = sprintf('STATIONS.%s.txt',tdate);
end
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID, query_output);
fclose(fileID);

% Optional Output
varns = {sta_query};
varargout = varns(1:nargout);
end

