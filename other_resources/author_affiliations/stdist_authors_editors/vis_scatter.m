function vis_scatter(INFILE, ABBFILE)

%% VIS_SCATTER scatter plot, and stats (linear model, correlation coefficients), of relationship between Editorial and Authorial stdist.

db = readtable(INFILE);

figure(1),clf
	x = db.journal_stdist_linear_deg_editors;
	y = db.journal_stdist_linear_deg_authors;
	scatter(x,y,'filled')
	set(gca,'FontSize',16)
	xlabel('STDIST EDITORS (deg)')
	ylabel('STDIST AUTHORS (deg)')
	grid on
	hold on
	text(x+0.5,y,db.abbr)

	% .. model, plot conf intervals etc.
	lm = fitlm(x,y, 'RobustOpts', 'on');
	xnew = [linspace(min(x),max(x))]';
	[pred,yci] = predict(lm, xnew);
	plot(xnew,pred, 'b-', 'linewidth', 2)
	plot(xnew,yci, 'r--', 'linewidth', 0.5)
	disp(lm)

	% .. Correlation stats
	[Prho,Ppval] = corr(x,y, 'type', 'Pearson');
	[Srho,Spval] = corr(x,y, 'type', 'Spearman');
	fprintf(' --> Pearsons (linear) rho (p-val): %.3f (%.04f).\n', Prho, Ppval)
	fprintf(' --> Spearman (rank) rho (p-val): %.3f (%.04f).\n', Srho, Spval)
