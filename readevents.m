function varargout = readevents(filename)
% [d] = READEVENTS(filename)
%
% Reads and extracts event (earthquake) data from a text file.
%
% INPUT:
%
% filename             Text file containing earthquake information, full path included
%
% OUTPUT:
%
% d                    Data structure containing eventID, event name, event location [lat lon depth],
%                      event start date, and event magnitude.
%
% Last modified by pdabney@princeton.edu, 01/24/22
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
% EXTRACT DATA FROM CELL ARRAY
d.eventID = Fdata{1};
d.eventName = Fdata{13};
% Convert to datetime format
convdate = @(x) datetime(x, 'InputFormat','yyyy-MM-dd''T''HH:mm:ss');
d.datetime=cellfun(convdate,Fdata{2});
d.eventLocation = [Fdata{3} Fdata{4} Fdata{5}];
d.Magnitude = Fdata{11};

% -----------------------------------------------------------------------------------------------
% Optional output
varns = {d};
varargout = varns(1:nargout);


end

