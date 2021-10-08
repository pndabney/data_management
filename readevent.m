function varargout = readevent(filename)
% [eventID, eventname, datetim, evloc, mag]=READEVENT(filename)
%
% Reads and extracts event (earthquake) data from a text file.
%
% INPUT:
%
% filename             Text file containing earthquake information, full path included
%
% OUTPUT:
%
% eventID              Cell array of event based unique ID number assigned by IRIS DMC 
% eventname            Cell array of location names where event occurred
% datetim              Cell array of the start date and time of the event
% evloc                Matrix [lat lon depth] of events
% mag                  Vector containing the magnitudes of the events
%
% Last modified by pdabney@princeton.edu, 10/08/21

% -----------------------------------------------------------------------------------------------
% ACCESS DATA FROM TEXT FILE
% Open file
fileID = fopen(filename);

% Read header line
formatSpec = '%s';
N = 13; % number of columns
Fhdr = textscan(fileID,formatSpec, N, 'Delimiter','|');

% Read the data (skipping the header line)
Fdata = textscan(fileID,'%s %s %f %f %f %s %s %s %s %s %f %s %s','HeaderLines',1,'Delimiter','|');

% Close file
fclose(fileID);


% -----------------------------------------------------------------------------------------------
% EXTRACT DATA FROM STRUCTURES
eventID = Fdata{1}; % cell array
datetim = Fdata{2}; % cell array
evloc = [Fdata{3} Fdata{4} Fdata{5}]; % [lat lon depth]
mag = Fdata{11};
eventname = Fdata{13}; % cell array


% -----------------------------------------------------------------------------------------------
% Optional output
varns = {eventID, eventname, datetim, evloc, mag};
varargout = varns(1:nargout);


end

