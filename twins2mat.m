function varargout=twins2mat(file)
% [t,d]=TWINS2MAT(file)
%
% Reads, and converts CSV file from InSight's TWINS data to a MATLAB file
% including proper date-time variables for EARTH UTC time.
%
% INPUT:
%
% file     Filename string, full path included
%
% OUTPUT:
%
% t        Timestap as a DATETIME array (UTC 'YYYY-MM-DD HH:MM:SS' format)
% d        Data as a STRUCTURE
% 
%
% Last modified by pdabney@princeton.edu, 01/19/2022

% Prepare to save CSV as a MAT file
[path, filename, ftype]=fileparts(file);
matname=sprintf('%s.mat',filename);


if exist(fullfile(path,matname))~=2
    % Open CSV file
    fid=fopen(file);

    % Read "header" line
    hdr=fgetl(fid);
    % Convert header string line into a cell array
    h = strsplit(hdr, ',');

    % Number of TWINS variables - currently 25
    N = 25;
    fmt=['%d%d%s%s%s',repmat('%.4f',[1, N-5])];
    % Read in the 'data'
    data=textscan(fid, fmt, 'Delimiter',',');
         
    % Close file
    fclose(fid);

    % Start data structure -- excluding string values 
    % Also excluded data{7,17} because is all NaN
    dx = setdiff([1:N],[5 7 17]);
    for index=dx
            d.(h{index})=data{index};
    end
    
    % Convert UTC-Julian day to DATETIME format -- not exactly the same some times are off by ~1
    convt = @(x) str2num(x(6:8))-1 + juliandate(sprintf('%s-01-01 %s',x(1:4),x(10:21)));
    t=datetime(cellfun(convt, data{5}),'ConvertFrom','juliandate');


    % Store DATETIME format in MAT structure
    d.(h{5})=t;

    % Convert LTST string to DATETIME 'HH:mm:ss' -- per sol
    %convm = @(y) datetime(y(7:end), 'InputFormat','HH:mm:ss','Format','HH:mm:ss')
    %mt=cellfun(convm,data{4});

    % Save
    save(fullfile(path,filename),'t','d')
else
    disp(sprintf('%s already exists', matname))
    load(fullfile(path,matname))
end


% Optional output
varns={t,d};
varargout=varns(1:nargout);

end