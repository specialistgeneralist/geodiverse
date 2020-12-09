# GeoDiverse / Editorial v Authorial GeoDiversity
_An exploration of the relationship between Editorial and Authorial power._

## Summary
With a complete geo-located database of author-output-affiliations we compute the author-centric standard distance and centroid by journal and compare these with their editorial counterparts.

## Details
See `example_method` for details of use (below).

#### Example:
```
% // compute stdist of journals from authors
>> compute_stdist_authors('scopus_authors_papers_affiliations_geo.csv', 'authors_stdist.csv', 'pub_nam_geodiverse')

% // join to editors and tidy (also computes arc distance between geomean of editors and authors, by journal)
>> join_AuthorsEditors('authors_stdist.csv', 'editors_stdist.csv', 'geo_authors_editors.csv')

% // add journal abbreviations for downstream
>> add_JournalAbb('geo_authors_editors.csv', 'journal_abb_map.csv')
 --> wrote geo_authors_editors_abbr.csv (48 rows).

% //  vis scatter and statistics
>> vis_scatter('geo_authors_editors_abbr.csv')

Linear regression model (robust fit):
    y ~ 1 + x1

Estimated Coefficients:
                   Estimate       SE       tStat       pValue  
                   ________    ________    ______    __________

    (Intercept)     28.139       2.4875    11.312    6.9914e-15
    x1             0.37261     0.082941    4.4925    4.7177e-05


Number of observations: 48, Error degrees of freedom: 46
Root Mean Squared Error: 6.04
R-squared: 0.305,  Adjusted R-Squared 0.29
F-statistic vs. constant model: 20.2, p-value = 4.71e-05
 --> Pearsons (linear) rho (p-val): 0.574 (0.0000).
 --> Spearman (rank) rho (p-val): 0.589 (0.0000).

% // vis polar plot of movements, ED -> AU
>> vis_polar('geo_authors_editors_abbr.csv')

```

