function varargout=getAmpPhase(network,station,location,channel,time,units,direc,fname)
% [evalresp_query]=getAmpPhase(network,station,location,channel,time,units,direc,fname)
%
% Requests the amplitude and phase data of a station from irisws-evalresp
% and stores as a text file.
%
% Inputs:
%
% network          Network name [e.g. 'IU']
% station          Station name [e.g. 'ANMO']
% location         Location code [e.g. '00']
% channel          Component of interest [e.g. 'BHZ']
% time             Time to evaluate the response [format: 'yyyy-mm-ddThh:mm:]
% direc            Directory to put data
% fname            Option to specify the output filename 
%                  (default: FAP_network.station.location.channel.time)
%
% Last modified by pdabney@princeton.edu, 02/10/22

% Format url request
initial = 'http://service.iris.edu/irisws/evalresp/1/query?';
params = sprintf('net=%s&sta=%s&loc=%s&cha=%s&time=%s&units=%s&output=fap',network,station,location,channel,time,units);
evalresp_query = strcat(initial,params);

% Obtain web content
web_cont = webread(evalresp_query);

% Store data in a text file
switch nargin
    case 8
        filename = fname;
    case 7       
      % Change time to date for file naming
        t = datevec(strrep(time, 'T',' '));
        jday=dat2jul(t(2),t(3),t(1));
        filename = sprintf('FAP.%s.%s.%s.%s.%d.%d',network,station,location,channel,t(1),jday);
end
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID,web_cont);
fclose(fileID);

% Optional Output
vars = {evalresp_query};
varargout = vars(1:nargout);

end