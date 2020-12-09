function get_UniqueAffiliations(INFILE, OUTFILE)

% Obtain unique list of affiliations from Scopus data for matching with
% geo-diverse project affiliations

db = readtable(INFILE);

A = unique(db(:, {'afid' 'affilname' 'affiliation_city' 'affiliation_country'}));

writetable(A, OUTFILE,...
	'Delimiter','\t');
