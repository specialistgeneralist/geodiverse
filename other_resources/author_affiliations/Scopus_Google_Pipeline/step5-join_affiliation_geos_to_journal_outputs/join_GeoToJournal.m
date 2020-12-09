function join_GeoToJournal(AUTHFILE, GEOFILE, OUTFILE)

% geo: afid	affilname	affiliation_city	affiliation_country	street	city	state	country	lat	lon	loc_type	ggl_add	ggl_place_id

DROP_GGL_TYPE = {'GEOMETRIC_CENTER'};

% -- ingest
Taut = readtable(AUTHFILE, ...
	'Delimiter', '\t');
fprintf(' --> found %.0f author-affiliation rows ...\n', height(Taut))

Tgeo = readtable(GEOFILE, ...
	'Delimiter', '\t');
fprintf(' --> found %.0f geo--affiliation rows ...\n', height(Tgeo))

% -- clean duplicates in geo file before join
[~,ix] = unique(Tgeo.afid);
Tgeo = Tgeo(ix,:);
fprintf(' --> reduced geo--affiliation table to %.0f unique afid rows ...\n', height(Tgeo))

% -- join
T = innerjoin(Taut, Tgeo, 'Keys', 'afid', ...
	'RightVariables', {'lat' 'lon' 'loc_type' 'ggl_add' 'ggl_place_id'});
fprintf(' --> have %.0f author-affiliation-geo rows after join ...\n', height(T))

% -- drop poor quality rows
T_refined = T(~ismember(T.loc_type, DROP_GGL_TYPE),:);
fprintf(' --> main table: %.0f rows; refined (drop bad Google Types): %.0f rows.\n',...
	height(T), height(T_refined))

% -- output
OUTFILE_REF = replace(OUTFILE, '.csv', '_refined.csv');
writetable(T, OUTFILE, ...
	'Delimiter', '\t')
writetable(T_refined, OUTFILE_REF, ...
	'Delimiter', '\t')
fprintf(' --> wrote %s (%.0f rows), and %s (%.0f rows).\n',...
	OUTFILE, height(T), OUTFILE_REF, height(T_refined))


