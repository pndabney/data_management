function varargout = getevents(direc, tstart, tend, minmag, maxmag, fileout)
% [event_query]=GETEVENTS(direc, tstart, tend, minmag, maxmag, fileout)
%
% Obtains a list of events and event data (e.g. EventID, Time, Latitude, Longitude,  
% Depth, Magnitude, etc) and stores information in an EVENTS text file.
%
% Input:
%
% direc              Directory where the output file will be stored
% tstart             Start data (format: 'yyyy-MM-ddTHH:mm:ss')
% tend               End date (format: 'yyyy-MM-ddTHH:mm:ss')
% minmag             Minimum Magnitude (0-10)
% maxmag             Maximum Magnitude (0-10)
% fileout            Optional output filename (default: EVENTS.date.txt)
%
% Ouput:
% 
% event_query        URL query (can entered in search bar)       
%
% Note:
%
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 01/24/22


% To get data from IRIS Web Services
eventurl = 'http://service.iris.edu/fdsnws/event/1/';
outputf = 'text';

datetime.setDefaultFormats('defaultdate', 'yyyy-MM-dd')
% Define default values
defval('tstart', strcat(string(datetime('yesterday')),'T00:00:00'))
defval('tend', strcat(string(datetime('today')), 'T00:00:00'))
defval('minmag', 3)
defval('maxmag', 10);
% Set default magnitude to be estimates of the seismic moment
defval('magtype', 'mw')


% Check minimum magnitude is less than maximum magnitude
if minmag > maxmag 
    error('Error: Minimum magnitude must be less than the maximum magnitude')
end

% Format url event query 
paramform='query?starttime=%s&endtime=%s&minmagnitude=%f&maxmagnitude=%f&magtype=%s&orderby=magnitude&format=%s';
myparams = sprintf(paramform, tstart, tend, minmag, maxmag, magtype, outputf);
event_query = strcat(eventurl, myparams);

% Obtain query output contents
query_output = webread(event_query);

% Check request
opt = weboptions('Timeout', 60);
if isempty(query_output) == 1
    error('Error 404 NOT_FOUND: No data found');
end

% Create to store event info
switch nargin
  case 6
    filename = sprintf('%s.txt',fileout);
  case 5
    tdate = string(datetime('today'), 'yyyy.MM.dd');
    filename = sprintf('EVENT.%s.txt',tdate);
end
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID, query_output);
fclose(fileID);

% Optional Output
varns = {event_query};
varargout = varns(1:nargout);
end

