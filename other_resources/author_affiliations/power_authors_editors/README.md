# GeoDiverse / Editorial v Authorial GeoDiversity
_An exploration of the relationship between Editorial and Authorial power._

## Summary
With a complete geo-located database of author-output-affiliations we compute authorial power at a coarse-grained grid of locations on the planet.

## Details
See `example_method` for details of use (below).
1. With `calc_authorPower()` the (lat,lon) pairs for each author--output--affiliation row are coarse grained to some number of decimal points (e.g. integers), and then a count is conducted for the number of authore--output--affilitions accruing to this location. For integers (rounding to 0 dec points), grid point lengths are around 111km anywhere for longitude, and 111km for latitude at the equator and then down to 0 in latitude at the poles due to the spherical geometry at play.
2. With `check_authorPowerCorrelation()` a check is possible between the all-point and `_refined.csv` variant of the output database. The latter being cleaned of any `GEOMETRIC_CENTER` type outputs from the Google API query. A scatter plot is shown and a correlation coefficient and p-value is computed.

#### Example:
```

% -- all
% Author power from author lat-lon, with coarse-graining
>> calc_authorPower('scopus_authors_papers_affiliations_geo.csv', 'author_power_1p0deg.csv', 0)
 --> wrote author_power_1p0deg.csv (1348 rows).

% -- refined variant
>> calc_authorPower('../scopus/step5-join_affiliation_geos_to_journal_outputs/scopus_authors_papers_affiliations_geo_refined.csv', 'author_power_1p0deg_refined.csv', 0)
 --> wrote author_power_1p0deg_refined.csv (1081 rows).

% -- check impact of geo refinement on geo power
>> check_authorPowerCorrelation('author_power_1p0deg.csv', 'author_power_1p0deg_refined.csv')

```

