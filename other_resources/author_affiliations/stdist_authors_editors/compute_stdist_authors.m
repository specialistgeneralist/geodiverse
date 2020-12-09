function compute_stdist_authors(INFILE, OUTFILE, MY_JOURNAL_FIELD)

% COMPUTE_STDIST computes the average standard distance of author
%   affiliation data in km and outputs the result.
%
% The average standard distance is the average distance, from the
% geographic centre, of a group of points distributed on a sphere.
% All measures are thus great-circle distances.
%
% Usage:
%   COMPUTE_STDIST_AUTHORS(INFILE, OUTFILE, MY_JOURNAL_FIELD)
%     computes STDIST for all lat-lon points associated with a
%     given unique Journal name, given in the tab-delimited file
%     INFILE, grouping by MY_JOURNAL_FIELD, and produces a summary,
%     by journal in the file OUTFILE.
%
% Example:
% >> compute_stdist_authors('scopus_authors_papers_affiliations_geo.csv', 'authors_stdist.csv', 'pub_nam_geodiverse')
%
% By: SD Angus, K Atalay, J Newton, D Ubilava (2020) for the
%     Geographic Diversity Project; @geodiverse
%
%     Code written by: SD Angus (Monash University)
%
% See also STDIST DEG2KM ROWFUN

% -- ingest
db = readtable(INFILE,...
	'FileType', 'text',...
	'Delimiter', '\t');

% -- structure
T = db(:, {MY_JOURNAL_FIELD 'lat' 'lon'});

% -- compute for affiliation locations
% .. mean linear geographic distance, in deg
S  = rowfun(@(x,y) round(stdist(x,y),2), T,...
	'InputVariables', {'lat' 'lon'},...
	'GroupingVariables', MY_JOURNAL_FIELD,...
	'OutputVariableNames', 'journal_stdist_linear_deg');
S.Properties.VariableNames = replace(S.Properties.VariableNames, 'GroupCount', 'n_affiliations');

% .. convert from deg to km
S.journal_stdist_linear_km = round(deg2km(S.journal_stdist_linear_deg));

% -- also return the geographic mean of each journal
G  = rowfun(@(x,y) meanm(x,y), T,...
	'InputVariables', {'lat' 'lon'},...
	'GroupingVariables', MY_JOURNAL_FIELD,...
	'OutputVariableNames', {'journal_geomean_lat' 'journal_geomean_lon'});

% -- join in
S = join(S, G,...
	'Keys', MY_JOURNAL_FIELD,...
	'RightVariables', {'journal_geomean_lat' 'journal_geomean_lon'});

% -- sort by combined dist in km
S = sortrows(S, 'journal_stdist_linear_km', 'ascend');

% -- for plotting ease, add standard distance in m also
S.journal_stdist_linear_m = S.journal_stdist_linear_km * 1000;

% -- export; csv delim
S = S(:, {MY_JOURNAL_FIELD 'n_affiliations' ...
	'journal_geomean_lat' 'journal_geomean_lon' ...
	'journal_stdist_linear_deg' 'journal_stdist_linear_km' 'journal_stdist_linear_m' });

% .. rename
S.Properties.VariableNames = replace(S.Properties.VariableNames, MY_JOURNAL_FIELD, 'Journal');
writetable(S, OUTFILE,...
	'Delimiter', 'comma',...
	'QuoteStrings', true)

