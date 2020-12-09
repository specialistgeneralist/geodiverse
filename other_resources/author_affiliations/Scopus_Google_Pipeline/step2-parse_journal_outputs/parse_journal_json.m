function TA = parse_journal_json(INFILE)

%% PARSE_JOURNAL_JSON takes a journal JSON file, output from a SCOPUS API
%    call, and builds a table of article--author row information for
%    downstream processing.

% -- Ingest
c = fileread(INFILE);

% -- Convert to structured array
S = jsondecode(c);

% -- build table
n = numel(S.search_results.entry);
have_TA = false;
for i = 1:n

	clear t T a A
	s = S.search_results.entry(i);
	if iscell(s)
		s = s{1};
	end

	if ~isfield(s, 'subtypeDescription') | ...
		 ((isfield(s, 'dc_creator') & ~isempty(s.subtypeDescription)) & ...
		 ismember(s.subtypeDescription, {'Article' 'Chapter' 'Review'}))		% avoid Editorials, Finance updates etc.

		% . meta; due to inconsistent json, we fall back on DOI as unique ID as --(always)-- mostly present
		t = struct2table(s, 'AsArray', true);
		T = t(:, {'dc_identifier' 'dc_title' 'prism_publicationName' 'prism_coverDate' });

		% . affiliations						% key :: affid
		if isfield(s, 'affiliation')
			A = struct2table(s.affiliation, 'AsArray', true);
			A.dc_identifier = repmat(T.dc_identifier, height(A), 1);	% add key
			A.x__fa = [];				% drop
			A.affiliation_url = [];
			A = my_check_fields(A, {'afid' 'affilname' 'affiliation_city' 'affiliation_country' 'dc_identifier'});
			% -- add a null row for later handling
			A = [A; my_null_entry(T.dc_identifier)];
		else
			A = my_null_entry(T.dc_identifier);
		end

		% . make authid -- affid map
		if isfield(s, 'author')

			% -- since .afid occassionally missing, fall back on sequential tools
			clear AU
			t = s.author;
			if isstruct(t)
				AU = struct2table(t, 'AsArray', true);	% key :: authid
				AU.author_url = [];
				if ismember('afid', AU.Properties.VariableNames)
					AU.afid = [];
				end
			elseif iscell(t)
				% -- reconstruct manually from cell
				c1 = 1;
				n_au = numel(t);
				for j = 1:n_au
					do_fields = {'x__fa' 'x_seq' 'authid' 'authname' 'surname' 'given_name' 'initials'};
					for k = 1:numel(do_fields)
						this_field = do_fields{k};
						AU(c1).(this_field)	= {t{j}.(this_field)};
					end
					c1 = c1+1;
				end
				AU = struct2table(AU);
			end
			% .. ensure unique rows (occassional we see duplicates)
			try
				AU = unique(AU);
			end

			% -- now build map :: afid, authid
			clear map
			n_au = numel(t);
			for j = 1:n_au
				if isstruct(t)
					tt = t(j);
				elseif iscell(t)
					tt = t{j};
				end
				this_authid = tt.authid;
				if isfield(tt, 'afid')
					Tafid = struct2table(tt.afid);
					n_afids = height(Tafid);
					this_authid = repmat({tt.authid}, n_afids, 1);
					this_afid   = Tafid.x_;
				else
					this_afid = 'null';
				end
				if ~iscell(this_afid)
					this_afid = {this_afid};
				end
				if ~iscell(this_authid)
					this_authid = {this_authid};
				end
				if j==1
					authid = this_authid;
					afid   = this_afid;
				else
					authid = [authid; this_authid];
					afid   = [afid; this_afid];
				end
			end

			map = table(afid, authid);

			% . join Author and Affiliation data together (with paper Identifier)
			try
			B = join(map, AU, 'Keys', 'authid');
			B = join(B, A, 'Keys', 'afid');
		catch, keyboard, end

			% . combine to title--affiliation rows
			if have_TA
				TA = [TA; join(B, T, 'Keys', 'dc_identifier')];
			else
				TA = join(B, T, 'Keys', 'dc_identifier');
				have_TA = true;
			end

		end
	end
end

%-------------------------
function T = my_null_entry(ID)

my_fields = {'afid' 'affilname' 'affiliation_city' 'affiliation_country' 'dc_identifier'};
for i = 1:numel(my_fields)
	t.(my_fields{i}) = {'null'};
end
T = struct2table(t);
T.dc_identifier = ID;


%-------------------------------------
function T = my_check_fields(T, FIELDS);

for i = 1:numel(FIELDS)
	this_field = FIELDS{i};
	if ~iscell(T.(this_field))
		T.(this_field) = {T.(this_field)};
	end
end
