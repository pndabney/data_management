function varargout = readstation(filename)
% [net, sta, staloc, sitename, tstart]=READSTATION(filename)
%
% Reads and extracts station information from a text file.
%
% Input:
%
% filename             Text file containing earthquake information, full path included
%
% Output:
%
% d                    Data structure containing network, station, stationt location
%                      [lat lon elevation], start date, and sitename.
%
% Last modified by pdabney@princeton.edu, 01/24/2022

% -----------------------------------------------------------------------------------------------
% ACCESS DATA FROM TEXT FILE
% Open file
fileID = fopen(filename);

% Read header line
formatSpec = '%s';
N = 8; % number of columns
Fhdr = textscan(fileID,formatSpec, N, 'Delimiter','|');

% Read the data (skipping the header line)
Fdata = textscan(fileID,'%s %s %f %f %f %s %s %s','HeaderLines',1,'Delimiter','|');

% Close file
fclose(fileID);

% If the station has an end time, then it is not continuously recording during the time frame 
% of interest.
% Remove stations that have an end time
idx = find(~cellfun(@isempty, Fdata{8}));
for i = 1:N
    for k = 1:length(idx)
        Fdata{i}(idx(k)) = [];
    end
end

% -----------------------------------------------------------------------------------------------
% EXTRACT DATA 
% Store data as a struct
d.Network = Fdata{1};
d.Station = Fdata{2};
d.Station_Location = [Fdata{3} Fdata{4} Fdata{5}]; % [lat lon elev]
d.Sitename = Fdata{6};
convdate = @(x) datetime(x, 'InputFormat','yyyy-MM-dd''T''HH:mm:ss');
d.StartTime = cellfun(convdate,Fdata{7});

% -----------------------------------------------------------------------------------------------
% OPTIONAL OUTPUT
varns = {d};
varargout = varns(1:nargout);


end

