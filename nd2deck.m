function nd2deck(filename)
% nd2deck(filename)
%
% Converts nd formated files to deck. Note this code fills in attentuation values specific to Mars.
% See IRIS (https://ds.iris.edu/ds/products/synginem/) for more details.
%
% Input:
%
% filename  String .nd file, full path included
%
% Last modfied by pdabney@princeton.edu, 07/07/2022


% Read in file
[path, fname, ext]=fileparts(filename);
fileID = fopen(filename,'r');

% Ignore columns and read in as a whole
S = textscan(fileID,'%s','delimiter','\n');
S=S{1}; 

fclose(fileID);

% Remove all words (mantle,outer-core,inner-core)
idx = contains(S,'mantle') | contains(S,'core');
S(idx)=[];

% Write to file
fileID = fopen(fullfile(path,[fname,'.deck']),'wt');
fprintf(fileID, '%s\n',S{:});
fclose(fileID);

% Extract data from file
% File format should be radius(m), density (kg/m^3), Vp(m/s), Vs(m/s), Qkappa, Qmu, V1(m/s), V2(m/s), 
% iso/aniso. V1 and V2 are other velocities which we do not use; therefore, we duplicate the values 
% of Vp and Vs. See Summary of the Green's functions databases from Ceylan et al. (2017) for more details. 
fileID = fopen(fullfile(path,[fname,'.deck']),'r');
d = textscan(fileID,'%.3f %.4f %.4f %.4f');
fclose(fileID);

% Extract radius, Vp, Vs, and density
depth=d{1}; Vp=d{2}; Vs=d{3}; density=d{4};
radius = depth(end) - depth;

% Need to reverse all the values (start values ==> inner core)
% And convert units from km/s to m/s and g/cm^3 to kg/m^3
ucon = 1e3;
radius=flip(radius)*ucon; density=flip(density)*ucon;
Vp=flip(Vp)*ucon; Vs=flip(Vs)*ucon;
iso = 1; % Assumes isotropy

% Find the liquid core boundary 
index=find(Vs == 0);
[C,K]=isincreasing(index);
if K == length(index)
    ics=index(1)-1; % inner core starting index
    ocs=index(end); % inner core ending index
else
    newin=C{1};
    ics=newin(1)-1; % inner core starting index
    ocs=newin(end); % inner core ending index
end

% Add Attentuation
% Qmu= 100 in the upper crustal layer 0-10 km (to suppress reverberations above the strong inner crustal
% boundary); Qmu=300 between 10 km and 180 km; Qmu=600 in the mantle below 180 km; Qkappa=1e5 at reference 
% period of 1 second
Qkappa = 1e5;
Qmu = zeros(length(radius),1); % initialize
cidx = find(radius <= 10e3); % Upper crustal layer
Qmu(cidx)=100;
midx = find(radius > 10e3 & radius <= 180e3); % lower crust/upper mantle region
Qmu(midx)=300;
mcdx = find(radius > 180e3); % mantle below 180 km
Qmu(mcdx)=600;

% Modify file
fileID = fopen(fullfile(path,[fname,'.deck']),'w+');
% Add header lines
fprintf(fileID,'%s\n',[fname,'.deck']);
fprintf(fileID,'%.f %.1f %.f\n',1, 1, 1);
fprintf(fileID,'%.f %.f %.f\n',length(radius),ics,ocs);

format='%7.f. %7.2f %7.2f %7.2f %8.1f %5.1f %7.2f %7.2f %7.5f\n';
for i = 1:length(radius)
    fprintf(fileID,format,radius(i),density(i),Vp(i),Vs(i),Qkappa,Qmu(i),Vp(i),Vs(i),iso);
end
fclose(fileID);

    
end

