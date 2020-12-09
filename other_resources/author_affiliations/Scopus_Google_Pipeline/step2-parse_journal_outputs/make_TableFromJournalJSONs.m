function make_TableFromJournalJSONs(DIRNAME, OUTFILE)

%% MAKE_TABLEFROMJOURNALJSONS Run over a directory of JSONS output by some API
%    and extract relevant data, shaping into useful table for downstream
%    processing.

d = dir(DIRNAME);
n = numel(d);
fprintf(' --> found %.0f files to parse', n-2)
len_update = 0;

% -- run over each file found
have_T = false;
for i = 1:n

	if ~d(i).isdir

		this_file = [d(i).folder '/' d(i).name];
		disp_update(sprintf(' --> parsing: %s ...', d(i).name))
		t = parse_journal_json(this_file);
		if have_T
			T = [T; t];
		else
			T = t;
			have_T = true;
		end

	end

end

% -- output
writetable(T, OUTFILE)
fprintf('\n --> wrote %s (%.0f rows)\n', OUTFILE, height(T))
