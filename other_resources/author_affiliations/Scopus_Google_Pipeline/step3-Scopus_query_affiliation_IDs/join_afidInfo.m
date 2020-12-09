function join_afidInfo(JSON_MASK, INFILE, OUTFILE)

%% JOIN_AFIDINFO for each JSON affiliation info file, extract address details
%  and join to main affiliation db (skip if empty)

% .. join to affiliation db
db = readtable(INFILE);

% .. get matching json files
d = dir(JSON_MASK);
n = numel(d);

% .. unpack from json
c1 = 1;
for i = 1:n
	this_fname = [d(i).folder '/' d(i).name];
	c = fileread(this_fname);
	if ~isempty(c)
		try
			j = jsondecode(c);
			a = j.affiliation_retrieval_response.institution_profile.address;
			ex_afid = j.affiliation_retrieval_response.institution_profile.x_affiliation_id;
			out(c1).afid    = str2num(ex_afid);
			out(c1).street  = safe_extract(a, 'address_part');
			out(c1).city    = safe_extract(a, 'city');
			out(c1).state   = safe_extract(a, 'state');
			out(c1).country = safe_extract(a, 'country');
			c1 = c1+1;
		end
	end
end

% .. convert to table
T = struct2table(out);

% .. join
J = innerjoin(db, T, 'keys', 'afid');

% .. outfile
writetable(J, OUTFILE)


% -------------------
function s = init_out

s.afid    = [];
s.street  = '';
s.city    = '';
s.state   = '';
s.country = '';

% ---------------------------------
function y = safe_extract(s, FIELD)

if isfield(s, FIELD)
	y = s.(FIELD);
else
	y = '';
end
