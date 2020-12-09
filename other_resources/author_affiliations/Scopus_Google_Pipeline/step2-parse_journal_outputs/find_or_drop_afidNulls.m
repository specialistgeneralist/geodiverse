function find_or_drop_afidNulls(AUTHFILE)

%% Where AFID is 'null', see if we have at least one afid for the authid. If so, fill the afid.
%% if more than one afid found, use the most frequent.

%% Drop 'null' in AFID

% -- ingest
Taut = readtable(AUTHFILE);
Taut = unique(Taut);		% ensure unique
fprintf(' --> found %.0f unique author--affiliation--paper rows ...\n', height(Taut))

% .. find 'null' afid
ix = ~ismember(Taut.afid, 'null');
Tno_null = Taut(ix, :);
Tnull    = Taut(~ix, :);
if height(Tnull)==0
	fprintf(' --> found 0 nulls. No further processing.\n')
else
	fprintf(' --> found %.0f afid (affiliation-ID) nulls, attempting to restore from authid (author-ID) ...\n', height(Tnull))
	% .. try to match
	M = unique(Tno_null(:, {'afid' 'authid' 'affiliation_city'}));
	Tnull.afid_likely = rowfun(@(x,y) my_match(x, y, M), Tnull, ...
		'InputVariables', {'authid' 'affiliation_city'},...
		'OutputFormat', 'cell');
	Tnull.afid = Tnull.afid_likely;		% replace with finds
	Tnull.afid_likely = [];				% drop

	% .. now re-cast null/no-null
	ix_null = ismember(Tnull.afid, 'null');
	Tno_null = [Tno_null; Tnull(~ix_null,:)];
	Tnull = Tnull(ix_null,:);
	fprintf(' --> now %.0f afid (affiliation-ID) nulls ...\n', height(Tnull))
end

% .. write
NULL_FNAME   = replace(AUTHFILE, '.csv', '_nulls.csv');
NONULL_FNAME = replace(AUTHFILE, '.csv', '_nonulls.csv');
writetable(Tnull, NULL_FNAME, 'Delimiter', '\t')
writetable(Tno_null, NONULL_FNAME, 'Delimiter', '\t')
fprintf(' --> wrote _nulls.csv (%.0f rows) and _nonulls.csv (%.0f rows).\n',...
	height(Tnull), height(Tno_null))

% -------------------------
function y = my_match(x, city, M)

% for a given authid(x), first try to find a matching afid from same city as null, if not, then get most frequent.

ix = find(ismember(M.authid, x));
if isempty(ix)
	y = 'null';
else
	t = M(ix,:);	% afid, authid
	% .. try for city match
	a = t(ismember(t.affiliation_city, city),:);
	if height(a) > 0
		y = a.afid{1};		% choose the first row
	else
		[G, groups] = findgroups(t.afid);
		n = splitapply(@numel, G, G);
		[~,ix] = sort(n, 'descend');
		y = groups{ix(1)};
	end
end


