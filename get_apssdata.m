function varargout=get_apssdata(direc, type, folder, filename)
% [content] = get_apssdata(direc, type, folder, filename)
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
% content            Table of TWINS data (N x 25)
%
% Notes:
%
% See https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT/insight.html for more
% details about the TWINS data format and content.
%
% Last modified by pdabney@princeton.edu, 01/07/2022

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

% Retrieve data and store as a table
content = webread(url_request);

% Save the data as a csv file
writetable(content, [direc, filename])


% Option output
varns={content};
varargout=varns(1:nargout);


end

