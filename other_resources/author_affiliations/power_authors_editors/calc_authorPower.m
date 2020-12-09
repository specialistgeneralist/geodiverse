function calc_authorPower(AUTHINFILE, OUTFILE, GEO_ROUNDING_DEC_POINTS)

%% Calculate Author 'power' by location, by summing up the number of authore--paper--affiliations
% accruing to a location on the map. Locations are defined by a course-graining of 
% lat-lon in degrees, with rounding by GEO_ROUNDING_DEC_POINTS.

% -- ingest
T = readtable(AUTHINFILE,...
	'Delimiter', '\t');

% -- round locations
% note: pay attention to round() definition (e.g. use of -ves)
T.lat = round(T.lat, GEO_ROUNDING_DEC_POINTS);
T.lon = round(T.lon, GEO_ROUNDING_DEC_POINTS);

% -- sum/group
S = rowfun(@numel, T, ...
	'InputVariables', 'lat', ...
	'GroupingVariables', {'lat' 'lon'}, ...
	'OutputVariableNames', 'author_power');

S.author_power_log10 = log10(S.author_power);

% -- write
writetable(S, OUTFILE)
fprintf(' --> wrote %s (%.0f rows).\n',...
	OUTFILE, height(S))