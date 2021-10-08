function varargout=ttquery(direc, model,phases,staloc,evloc,edepth)
% [tt_query]=ttquery(direc,model,phases,staloc,evloc,edepth)
%
% Creates a text file with traveltime data from IRIS.
%
% INPUT:
%
% direc         Directory where the output file will be stored
% model         1-D velocity model: 'prem', 'ak135','iasp91'
% phases        Comma separated string list of phases (e.g. 'P,S,SKS,PKP')
% staloc        [lat, lon] of the station(s)
% evloc         [lat, lon] of the event
% edepth        Event depth
%
% OUTPUT:
%
% tt_query      URL query (can entered in search bar)
%
% Note:
%
% Requires repository slepian_alpha. See defval.
%
% Last modified by pdabney@princeton.edu, 10/07/21

% Define default values
defval('model', 'prem')
defval('phases','P,S')

% To get traveltime data from IRIS Web Services
tturl = 'http://service.iris.edu/irisws/traveltime/1/query?';

% Format event and station location input format
eloc = sprintf('[%.4f,%.4f]',elat,elon);

% Reformat staloc 
% If there is more than one station inputed
sz = size(staloc);
if sz(1) == 1
    rloc = sprintf('[%g,%g]',staloc(1),staloc(2);
elseif sz(1) > 1
    for i = 1:sz(1)
        loc{i} = sprintf('[%g,%g]',staloc(i,1),staloc(i,2));
    end
    rloc = strjoin(loc,',');
end

% Format url event query 
paramform = 'model=%s&phase=%s&evdepth=%g&evloc=%s&staloc=%s';
myparam = sprintf(paramform, model, phase, edepth, eloc, rloc);

% Join all the substrings
tt_query = strcat(tturl,myparam);

% Get travel time data from IRIS
query_output = webread(tt_query);

% Create text file to store traveltime info
filename = 'TRAVELTIMES.txt';
fileID = fopen(fullfile(direc,filename),'w');
fprintf(fileID, query_output);
fclose(fileID)

% Option output
varns={tt_query};
varargout=varns(1:nargout);

end

