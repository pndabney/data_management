% Script to download multiple seismic traces from IRIS
%
% Last modified by pdabney@princeton.edu, 12/2/21
%% ======================================================================================================         
% To request data using a cmt catalog a single station for multiple events

direc = '~/Documents/Esacfiles/sacfiles/CTAO_range04_21';

% Event information
% Does not include max and min mblo and mbhi (error message: Undefined function or variable 'cmtcode'. 
% Error in readCMT (line 153)
[Quakes, Mw, cmt]=readCMT('apr21.ndk', '/home/pdabney/Documents/infiles/CMT/',datenum('2021-04-01 00:00:01'),...
datenum('2021-04-15 00:00:01'));


% Only keep events within a specific range
index = find(Mw > xmin && Mw < xmax);
Quakes(index,:)=[];
cmt(index)=[];
Mw(index)=[];


% Assumes you want a single long time series
starttime = datetime(Quakes(:,1),'ConvertFrom', 'datenum');
sstart = starttime + hours(20);
send = sstart + hours(206);


% For overall time for the Resp file
resp_snum = min(datenum(sstart));
resp_enum = max(datenum(send));
resp_sdate = datetime(resp_snum, 'ConvertFrom', 'datenum', 'Format','yyyy-MM-dd''T''HH:mm:ss');
resp_edate = datetime(resp_enum, 'ConvertFrom', 'datenum', 'Format','yyyy-MM-dd''T''HH:mm:ss');


% Station Info
network = 'IU';
station = 'CTAO';
channel = 'BHZ';
location = '00';


% First obtain RESP file
get_resp(network,station,location,channel,startdate,enddate,direc);

% Loop through all the events
for i = 1:length(Mw)
    % Request SACfiles from IRIS
    irisFetch.SACfiles(network,station,location,channel,sstart(i),send(i),direc);      
end




