function getPopCentroid(INFILE, MIN_POP_THRESHOLD)

% GETPOPCENTROID computes the geographic mean location of a given
%   gridded population file.
%
% Usage:
%   getPopCentroid(INFILE, MIN_POP_THRESHOLD) computes the mean
%     geographic location, using Matlab's built-in MEANM function
%     based on the grided lon,lat,count INFILE, using the lower
%     population threshold cuttoff MIN_POP_THRESHOLD.
%
% Note:
%   The lower pop threshold, MIN_POP_THRESHOLD also determines the
%   granularity of the calculation. Each location count is first replicated
%   by the count divided by the MIN_POP_THRESHOLD number. e.g.
%   if the threshold is 100, and a grid location has 543 at it, then
%   5 replicates of the location will be created to represent this
%   information. This is to handle weighting by population as MEANM
%   does not afford weighting natively.
%
% Example:
% >> getPopCentroid('population_0p5deg-grid_2020.csv', 1000);
%
% By: SD Angus, K Atalay, J Newton, D Ubilava (2020) for the
%     Geographic Diversity Project; @geodiverse
%
%     Code written by: SD Angus (Monash University)
%
% See also MEANM ROWFUN REPMAT

% -- ingest
db = readtable(INFILE);
n0   = height(db);
pop0 = sum(db.count);

% -- Drop readings less than threshold
fprintf(' --> applying grid threshold ... ')
db = db(db.count >= MIN_POP_THRESHOLD,:);
n   = height(db);
pop = sum(db.count);
fprintf(' done. (now %.0f rows, was %.0f rows)\n', n, n0)
fprintf('     total pop: %.0f or %.4f%% of initial (%.0f)\n', pop, 100*(pop./pop0), pop0);

% -- Now, replicate rows in proportion to given coarse graining to support meanm
fprintf(' --> replicating geo information in relation to pop there ... ')
db.idx = [1:height(db)]';
T = rowfun(@(x,y,z) my_replicate(x,y,z,MIN_POP_THRESHOLD), db, ...
	'InputVariables', {'lon' 'lat' 'count'}, ...
	'GroupingVariables', {'idx'}, ...
	'OutputVariableNames', {'lon', 'lat'});
fprintf('done. (now %.0f rows)\n', height(T))

% -- Get geographic mean of pop representative points
[LAT,LON] = meanm(T.lat, T.lon);
fprintf(' --> geographic mean: LAT=%.6f, LON=%.6f \n', LAT, LON)

% --------------------------------------------------
function [lon,lat] = my_replicate(lon0,lat0,count,M)

r = round(count/M);
lon = repmat(lon0, r, 1);
lat = repmat(lat0, r, 1);