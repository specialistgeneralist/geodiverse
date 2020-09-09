function compute_stdist(INFILE, OUTFILE)

% COMPUTE_STDIST computes the average standard distance of editorial
%   affiliation data in km and outputs the result.
%
% The average standard distance is the average distance, from the
% geographic centre, of a group of points distributed on a sphere.
% All measures are thus great-circle distances.
%
% Usage:
%   COMPUTE_STDIST(INFILE, OUTFILE) computes STDIST for all lat-lon
%     points associated with a given unique Journal name, given
%     in the tab-delimited file INFILE, and produces a summary, by
%     journal in the file OUTFILE.
%
% Example:
% >> compute_stdist('journals.csv', 'journals_stdist.csv')
%
% By: SD Angus, K Atalay, J Newton, D Ubilava (2020) for the
%     Geographic Diversity Project; @geodiverse
%
%     Code written by: SD Angus (Monash University)
%
% See also STDIST DEG2KM ROWFUN

% -- ingest
db = readtable('journals.csv',...
	'FileType', 'text',...
	'Delimiter', '\t');

% -- build combined locations of 1st and 2nd affiliations
T1 = db(:, {'Journal' 'lat' 'lon'});
T2 = db(:, {'Journal' 'lat2' 'lon2'});
T2 = T2(~isnan(T2.lat2),:);
T2.Properties.VariableNames = {'Journal' 'lat' 'lon'};
% .. convert T2.lon to double (overcome import type issue)
T2.lon = rowfun(@str2num, T2,...
	'InputVariables', 'lon',...
	'ExtractCellContents', true,...
	'OutputFormat', 'uniform');
% .. finally, vertically concatenate
T12 = [T1; T2];

% -- message
fprintf(' --> final affiliation table has %.0f rows (%.0f 1st affiliation; %.0f 2nd affiliations).\n',...
	height(T12), height(T1), height(T2))

% -- compute for 1st affiliation, then both 1st and 2nd combined
% .. mean linear geographic distance, in deg
% .. 1st only
S  = rowfun(@(x,y) round(stdist(x,y),2), T1,...
	'InputVariables', {'lat' 'lon'},...
	'GroupingVariables', 'Journal',...
	'OutputVariableNames', 'journal_stdist_linear_1st_deg');
S.Properties.VariableNames = replace(S.Properties.VariableNames, 'GroupCount', 'n_1st_affiliations');
% .. combined 1st and 2nd
S12 = rowfun(@(x,y) round(stdist(x,y),2), T12,...
	'InputVariables', {'lat' 'lon'},...
	'GroupingVariables', 'Journal',...
	'OutputVariableNames', 'journal_stdist_linear_1st2nd_deg');
S12.Properties.VariableNames = replace(S12.Properties.VariableNames, 'GroupCount', 'n_1st2nd_affiliations');
% .. join together for all Journals
S = join(S, S12,...
	'Keys', 'Journal',...
	'RightVariables', {'journal_stdist_linear_1st2nd_deg' 'n_1st2nd_affiliations'});
% .. convert from deg to km; do some calcs
S.journal_stdist_linear_1st_km       = round(deg2km(S.journal_stdist_linear_1st_deg));
S.journal_stdist_linear_1st2nd_km    = round(deg2km(S.journal_stdist_linear_1st2nd_deg));
S.journal_stdist_km_diff_w_2nd_added = S.journal_stdist_linear_1st2nd_km - S.journal_stdist_linear_1st_km;
S.n_2nd_affiliations 				 = S.n_1st2nd_affiliations - S.n_1st_affiliations;

% -- sort by combined dist in km
S = sortrows(S, 'journal_stdist_linear_1st2nd_km', 'ascend');

% -- export; tab delim
S = S(:, {'Journal' 'n_1st_affiliations' 'n_2nd_affiliations' 'n_1st2nd_affiliations' 'journal_stdist_linear_1st_deg' 'journal_stdist_linear_1st2nd_deg' ...
	'journal_stdist_linear_1st_km' 'journal_stdist_linear_1st2nd_km' 'journal_stdist_km_diff_w_2nd_added'});
writetable(S, OUTFILE, 'Delimiter', '\t')

