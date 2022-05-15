function varargout=getmarsdate(startdate, direc)
% [starttime, endtime, sol, start_mean_solar, end_mean_solar]=getmarsdate(startdate,direc)
%
% Retrieves the UTC start time for the beginning of the Mars day based on InSight's APSS calibrated.
% The script reads a data table provided by the Pressure Sensor. If the table does not exist, the code
% will retreieve it from 
% https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT/insight.html.
%
% Input:
%
% direc                                Directory where data table file is stored, full path included
% startdate                            Date of interest. Input must be numeric to find date time based on
%                                      Sol (e.g. 1086) or it must be a string to find date time based on
%                                      UTC date (format: yyyy-mm-dd, e.g. '2021-12-16').
%
% Output:
%
% starttime, endtime                   String of UTC start and end time for Mar's sol for date of interest
%                                      (format: 'yyyy-mm-ddTHH:MM:SS.sssZ')
% sol                                  Mars day (based on Sol 0 of InSight Mission, 11-26-2018)
% start_mean_solar, end_mean_solar     Local solar time computed by counting mean martian seconds since
%                                      a reference epoch corresponding to the LMST midnight on the day 
%                                      of landing. See https://atmos.nmsu.edu/. 
%                                      (format: 'solM:HH:MM:SS.sss')
%
% Note:
%
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 05/15/22

defval('direc','~/Documents/MATLAB/gitrepo/scripts/seismograms');

% Set filename from the website
filename = 'insight_ps_bundle_calibrated_d12_log.csv';

% if index data has not been downloaded
if exist(fullfile(direc,filename), 'file') == 0
    
    % print to terminal
    disp('Retreiving data from https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT')
    % url for index data - PS (pressure sensor) calibrated
    APSS_url='https://atmos.nmsu.edu/data_and_services/atmospheres_data/INSIGHT/logs/insight_ps_bundle_calibrated_d12_log.csv';
    % Save and store the data as a csv file
    websave(fullfile(direc,filename), APSS_url);
    
end

% load table
T = readtable(fullfile(direc,filename),'Format','%s%s%s%s%f%s%s%s%s%f%f%f%f%f','Delimiter',',');

% Remove events
k = find(contains(T.FileName,'event') == 1);
T(k,:)=[];


% Find corresponding UTC start time for Mars
if isnumeric(startdate) == 1
    % If searching by sol
    index = find(T.sol_number == startdate);
else
    % If search by UTC date
    index = find(contains(T.StartTime,startdate) == 1, 1, 'last');
end

% Extract datetime information
starttime = T.StartTime{index};
endtime = T.StopTime{index};
sol = T.sol_number(index);
start_mean_solar = T.start_mean_solar_time{index};
end_mean_solar = T.stop_mean_solar_time{index};


% Optional output
varns={starttime, endtime, sol, start_mean_solar, end_mean_solar};
varargout=varns(1:nargout);


end

