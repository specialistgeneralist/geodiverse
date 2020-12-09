function vis_polar(INFILE)

%% VIS_POLAR obtain the direction from ED -> AU geomean locations for each journal.

% -- read
db = readtable(INFILE);

% -- get angle ("az is measured clockwise from north.") (we already have arc_len)
[db.arc_len,db.az_deg_N] = distance(db.journal_geomean_lat_editors, db.journal_geomean_lon_editors, db.journal_geomean_lat_authors, db.journal_geomean_lon_authors);

% note we need to transform the az_ measurements into the standard polar coordinates to ensure "N" is at the top and we have a compass type setup.
db.az_deg = 360 - db.az_deg_N + 90;
db.az_rad = deg2rad(db.az_deg);

% -- plot
figure(1),clf
h = polarplot(db.az_rad, db.arc_len, '.');
	set(h, 'MarkerSize', 5)

	% .. label for user id
	% (comment out if not desired)
	text(db.az_rad, db.arc_len, db.abbr)

% .. label
pax = gca;
angles = 0:45:360;
pax.ThetaTick = angles;
labels = {'E','NE','N','NW','W','SW','S','SE'};
pax.ThetaTickLabel = labels;

