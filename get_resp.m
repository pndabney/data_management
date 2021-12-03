function varargout= get_resp(network,station,location,channel,startdate,enddate,direc)
% [web_query] = get_resp(network,station,location,channel,startdate,enddate,direc)
%
% Requests instrument response data from IRIS and saves the data in a directory.
% Instrument response data is in the format of a RESP file. 
%
% INPUT:
% 
% network          Network name [e.g. 'IU']
% station          Station name [e.g. 'ANMO']
% location         Location code [e.g. '00']
% channel          Component of interest [e.g. 'BHZ']
% startdate        Start date [format: 'yyyy-mm-ddThh:mm:ss']
% enddate          End Date [format: 'yyyy-mm-ddThh:mm:ss']
% direc            Directory to put data
%
% OUTPUT:
%
% resp_query       URL query used (can entered in search bar)
%
% Last modified by pdabney@princeton.edu, 12/03/21



% Format url request
ini_inresp = 'http://service.iris.edu/irisws/resp/1/query?';
param_inresp = sprintf('net=%s&sta=%s&loc=%s&cha=%s&starttime=%s&endtime=%s',network,station,location,channel,...
                       starttime,endtime);
resp_query = strcat(ini_inresp,param_inresp);

% Obtain web content
web_cont = webread(resp_query);

% Create RESP file
filename = sprintf('RESP.%s.%s.%s.%s',network,station,location,channel);
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID,web_cont);
fclose(fileID);


vars = {resp_query};
varargout = vars(1:nargout);

end

