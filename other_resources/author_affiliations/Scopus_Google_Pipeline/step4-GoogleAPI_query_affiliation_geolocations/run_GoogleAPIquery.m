function run_GoogleAPIquery(INFILE, OUTFILE)

% thanks: https://developers.google.com/maps/documentation/geocoding/

% note: first need to set up a billing account, create a project, enable Geocode API for the project, and get API key:
% ala: https://developers.google.com/maps/gmp-get-started#enable-api-sdk

API_KEY='<TOKEN_GOES_HERE>';

% -- read
db = readtable(INFILE);

% -- loop, sending queries to Google API end-point
n = height(db);
c1 = 0;
for i = 1:n

	this_afid = db.afid(i);
	this_address = sprintf( '%s,%%20%s,%%20%s', ...
		tidy(db.affilname{i}), ...
		tidy(db.street{i}), ...
		tidy(db.city{i}), ...
		tidy(db.country{i}) );
	cmd = sprintf('curl ''https://maps.googleapis.com/maps/api/geocode/json?address=%s&key=%s'' > tmp', ...
		this_address, API_KEY);
	fprintf(' --> running %5.0f/%5.0f :: %s ...\n', i, n, db.affilname{i})
	[~,~] = system(cmd);
	c = fileread('tmp');
	js = jsondecode(c);
	if strcmp(js.status, 'OK')
		n_res = numel(js.results);
		for j = 1:n_res
			c1 = c1+1;
			if iscell(js.results)
				r = js.results{j};
			else
				r = js.results(j);
			end
			try
			out(c1).afid 		 = this_afid;
			out(c1).lat 		 = r.geometry.location.lat;
			out(c1).lon 		 = r.geometry.location.lng;
			out(c1).loc_type     = r.geometry.location_type;
			out(c1).ggl_add      = r.formatted_address;
			out(c1).ggl_place_id = r.place_id;
			catch
				keyboard
			end
		end
	end

end

% -- convert, join and write
T = struct2table(out);
J = innerjoin(db, T, 'keys', 'afid');

% -- write
writetable(J, OUTFILE, ...
	'Delimiter', '\t')



% ------------------
function s = tidy(s)

s = replace(s, ' ', '%20');
s = replace(s, ',', '');
