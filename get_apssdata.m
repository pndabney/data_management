function varargout=get_apssdata(direc, type, folder, filename)
% [url_request] = get_apssdata(direc, type, folder, filename)
%
% Request calibrated APSS (Auxiliary Sensor Suite) data, TWINS (Temperature and Wind for
% InSight) or PS (Pressure  Sensor) and save as a csv data table.
%
% Input:
% 
% direc              Directory to store csv data, full path included
% type               0 TWIN data
%                    1 PS data
% folder             Directory name where the data file is stored, organized by Sol
% filename           CSV filename
%
% Output:
%
% url_request        String of the URL request
%
% Notes:
%
% See https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT/insight.html for more
% details about the APSS data format and content.
%
% Last modified by pdabney@princeton.edu, 01/24/2022

% Default values
defval('folder', 'sol_0211_0300')
defval('filename', 'twins_calib_0211_02.csv')

% Pick type of data
if type == 0
    datatype = 'twins_bundle';
elseif type == 1
    datatype = 'ps_bundle';
end

% Base url
web_directory = sprintf('https://atmos.nmsu.edu/PDS/data/PDS4/InSight/%s/data_calibrated', datatype);
url_request = strjoin({web_directory, folder, filename}, '/');

% Retrieve and save the data as a csv file
websave(fullfile(direc,filename), url_request);

% Optional output
varns={url_request};
varargout=varns(1:nargout);

end

