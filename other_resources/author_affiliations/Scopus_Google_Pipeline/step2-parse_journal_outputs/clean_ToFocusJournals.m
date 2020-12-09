function clean_ToFocusJournals(DBFILE, JFILE)

% -- ingest
db = readtable(DBFILE);
J = readtable(JFILE, 'FileType', 'text', 'Delimiter', '\t', 'ReadVariableNames', false);
J.Properties.VariableNames = {'pub_nam_geodiverse' 'prism_publicationName'};
n = height(db);

% -- clean
db = innerjoin(db, J, 'Keys', 'prism_publicationName');
fprintf(' --> cleaned to journal list. (was %.0f rows, now %.0f rows)\n',...
	n, height(db))
fprintf(' --> new unique journal count: %.0f.\n', numel(unique(db.prism_publicationName)));

% -- out
OUTFILE = replace(DBFILE, '_unclean.csv', '_cleaned.csv');
writetable(db, OUTFILE)
fprintf(' --> wrote %s (%.0f rows)\n', OUTFILE, height(db))

