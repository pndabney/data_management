function cmt2seis(direc,Mw,Quakes,cmtcode,xmin,xmax,net,sta,loc,cha,t_after,total_len)
% cmt2seis(direc,fname,path,sdate,edate,xmin,xmax,len)
%
% Requests SAC and  RESP files from IRIS using a cmt catalog a single station for multiple events
%
% INPUTS:
%
% direc             Directory to store the SAC and RESP files
% Mw                Scalar seismic moment
% Quakes            [time depth lat lon Mtensor]
% cmtcode           CMT codes
% xmin              Minimum seismic moment
% xmax              Maximum seismic moment
% net               Network name 
% sta               Station name
% loc               Location code
% cha               Channel code
% t_after           Length of time after event start time, in hours
% total_len         Total length for time series, in hours
%
% Last modified by pdabney@princeton.edu, 12/3/21


% Default values
defval('direc', '~/Documents/Esacfiles/sacfiles/CTAO');
defval('network','IU');
defval('station','CTAO');
defval('channel','BHZ');
defval('location', '00');
defval('t_after', 20);
defval('T_len', 206);


% Only keep events within a specific range
index = find(Mw > xmin && Mw < xmax);
Quakes(index,:)=[];
cmt(index)=[];
Mw(index)=[];

% Assumes you want a single long time series
starttime = datetime(Quakes(:,1),'ConvertFrom', 'datenum');
sstart = starttime + hours(t_after);
send = sstart + hours(len);

% For overall time for the Resp file
resp_snum = min(datenum(sstart));
resp_enum = max(datenum(send));
resp_sdate = datetime(resp_snum, 'ConvertFrom', 'datenum', 'Format','yyyy-MM-dd''T''HH:mm:ss');
resp_edate = datetime(resp_enum, 'ConvertFrom', 'datenum', 'Format','yyyy-MM-dd''T''HH:mm:ss');

% First obtain RESP file
get_resp(network,station,location,channel,string(resp_sdate),string(resp_edate),direc);

% Loop through all the events
for i = 1:length(Mw)
    % Request SACfiles from IRIS
    irisFetch.SACfiles(network,station,location,channel,sstart(i),send(i),direc);      
end





end

