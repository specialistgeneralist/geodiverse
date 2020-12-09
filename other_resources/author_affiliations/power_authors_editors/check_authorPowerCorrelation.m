function check_authorPowerCorrelation(AP, AP_REFINED)

% lat,lon,GroupCount,author_power

% -- Ingest
Tall = readtable(AP);
Trefined = readtable(AP_REFINED);

% -- join
C = innerjoin(Tall, Trefined, 'Keys', {'lat' 'lon'});

% -- plot
figure(1),clf
scatter(C.author_power_Tall, C.author_power_Trefined,'filled',...
	'MarkerFaceAlpha', 0.5)
set(gca,...
	'XScale', 'log',...
	'YScale', 'log',...
	'FontSize', 14), grid on
xlabel('AUTHOR POWER (ALL POINTS)')
ylabel('AUTHOR POWER (REFINED)')

[Rho, p] = corr(C.author_power_Tall, C.author_power_Trefined)
