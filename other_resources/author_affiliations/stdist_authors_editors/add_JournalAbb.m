function add_JournalAbb(INFILE, ABBFILE)

%% Add journal abbreviations to main data file from an abbreviation file.

A = readtable(INFILE);
B = readtable(ABBFILE);
A = join(A, B, 'Keys', 'Journal', 'RightVariables', 'abbr');

OUTFILE = replace(INFILE, '.csv', '_abbr.csv');
writetable(A, OUTFILE)
fprintf(' --> wrote %s (%.0f rows).\n', OUTFILE, height(A))