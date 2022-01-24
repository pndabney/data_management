function getmetadata(direc,network,station,startdate,enddate,format)
% getmetadata(direc,network,station,startdate,enddate,format)
% 
% Retrieves metadata for the InSight data from fdsnws/station service and
% stores results in specified direcotry.
%
% Input:
%
% direc          Directory to store metadata file
% network        Network name (default: 'XB')
% station        Station name (default: 'ELYSE')
% startdate      Start date (format: 'yyyy-MM-ddTHH:mm:ss')
% enddate        End date (format: 'yyyy-MM-ddTHH:mm:ss')
% format         Data format: 'xml' or 'text'
%
% Note:
%
% Requires repository slepian_alpha and slepian_oscar. See defval and dat2ul.
% For more details see https://www.seis-insight.eu/en/science/seis-data/seis-metadata-access.
%
% Last modified by pdabney@princeton.edu, 01/24/22


% Default values
defval('startdate','2019-02-15T00:00:00')
defval('enddate','2022-12-31T00:00:00')
defval('network','XB')
defval('station','ELYSE')
defval('format','xml')

% Format url request
base_request = 'http://ws.ipgp.fr/fdsnws/station/1/query?';
params = sprintf('network=%s&station=%s&startTime=%s&endTime=%s&level=reponse&format=%s',...
                       network,station,startdate,enddate,format);
metadata_query = [base_request, params];

content = webread(metadata_query);

% Create metadata file
date = datevec(startdate,'yyyy-mm-ddTHH:MM:SS');
jdate = dat2jul(date(2), date(3), date(1));
filename = sprintf('%s.%s.%.f.%s.metadata.%s',network,station,jdate,level,format);
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID, content);
fclose(fileID);

end

