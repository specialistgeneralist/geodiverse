# The Geographic Diversity Project
_Providing the Economics community with information on the geographic diversity of journals._



By [Simon D. Angus](http://research.monash.edu/en/persons/simon-angus), [Kadir Atalay](http://sydney.edu.au/arts/about/our-people/academic-staff/kadir-atalay.html), [Jonathan Newton](http://jonathannewton.net), and [David Ubilava](http://davidubilava.com)

See
* **Working Paper**:  [Angus, SD, Atalay, K, Newton, J, and Ubilava, D; _Geographic Diversity in Economic Publishing_ (September 23, 2020). Available at SSRN: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3697906](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3697906)
* **Twitter**: [@geo_diverse](https://twitter.com/geo_diverse)

To cite code, data, v1.0.0:
* [Angus, SD, Atalay, K, Newton, J, and Ubilava, D, _Geographic Diversity in Economic Publishing_, code and data, v1.0.0 specialistgeneralist/geodiverse: Working paper first draft - accompanying release, DOI: 10.5281/zenodo.4052830.](https://zenodo.org/badge/latestdoi/290628503)
[![DOI](https://zenodo.org/badge/290628503.svg)](https://zenodo.org/badge/latestdoi/290628503)


## Summary
Data provided here contain the name, institutional affiliation and geographic location of editorial staff at journals ranked **A*** by the [2019 ABDC Journal Quality List](https://abdc.edu.au/research/abdc-journal-list/).

## Details
Data are taken from the official websites of the journals in question. The journals included are the complete set of **A*** journals in economics (codes 1401,1402,1403) according to the Australian Business Deans Council (ABDC) 2019 Journal Quality List.

Included in the data are people listed as having current editorial positions at the journals. We exclude positions clearly marked as honorary or no longer active (e.g. “Former editor”).

If person X is listed as performing an editorial function for journal Y, there will be a single line of data corresponding to this. If person X is listed by multiple journals, he or she will be included in multiple lines of data.

If a person’s affiliation or affiliations is listed on the journal website, these affiliations will be included in the relevant line of data. If a person’s affiliation or affiliations are not listed on the journal website, the affiliations listed were found by conducting an internet search.

## Data Descriptor
For ease of use, we provide raw data in MS Excel form (XLSX) and an institution-level summary in simple Comma-separated Value (CSV) form.

### Raw Data: geodiverse_data.xlsx

#### "Data" tab
The fields in the “Data” tab are as follows:
* _Journal_: The name of the journal.
* _is_Top5_: A dummy indicating whether the journal is one of the “Top 5” journals in academic economics (1="top 5"; 0 otherwise).
* _Date_: The date that data was taken from the journal’s website.
* _Role_: The role of the person listed as performing an editorial function for the journal.
* _FirstName_: The first name or initials of the person listed as performing an editorial function for the journal.
* _Surname_: The surname of the person listed as performing an editorial function for the journal.
* _Affiliation1_: The institution to which the named person is listed as having an affiliation.
* _Country1_: The country in which “Affiliation 1” is located.
* _Continent1_: The continent in which “Affiliation 1” is located. For this purpose, Western Turkey is taken as in Europe, Eastern Turkey as in Asia. “Australasia” includes Oceania.
* _Location1_: The latitude and longitude of “Affliation 1”, taken from GoogleMaps.
* _Affiliation2_: An additional institution (if any) to which the named person is listed as having an affiliation.
* _Country2_: The country in which “Affiliation 2” is located.
* _Continent2_: The continent in which “Affiliation 2” is located.
* _Location2_: The latitude and longitude of “Affliation 2”, taken from GoogleMaps.

Subsequent sheets in the file give statistics based on the data in the “Data” sheet.

#### "Powerful institutions" tab
“Powerful institutions” sums the number of times that the named institution appears in “Data”. “Power” gives this sum for all entries, whereas “Top 5 power” restricts attention to entries for “Top 5” journals.

#### "Powerful countries" tab
“Powerful countries” sums the number of times that the named country appears in “Data”. “Power” gives this sum for all entries, whereas “Top 5 power” restricts attention to entries for “Top 5” journals.

#### "Powerful continents" tab
“Powerful continents” sums the number of times that the named continent appears in “Data”. “Power” gives this sum for all entries, whereas “Top 5 power” restricts attention to entries for “Top 5” journals.

### Summary Data: geodiverse_institution_summary.csv
Fields are as follows:
* institution: the institution to which named persons in the raw data are affiliated.
* _country_: the country in which the institution is located.
* _continent_: the continent in which the institution is located.
* _lat_: the institution's latitude, taken from GoogleMaps.
* _lon_: the institution's longitude, taken from GoogleMaps.
* _power_: the sum of the number of times that the named institution appears in the raw data.
* _top5_power_: as per _power_ but restricts only to entries for "Top 5" journals.

## Other Resources
In `other_resources` is provided additional tools and examples for working with the data provided here:
* In `journal_dists/` is provided code and in/out tab-delimited files to compute standard geographic distance measures, by journal. See `compute_stdist.m` for details.
* In `kepler_visualisation/` is provided an `.html` file allowing exploration of an institutional visualisation of the editorial power dataset.
* In `R_plots/` is provided *R* code and data to produce bar charts, scatter plots and density plots of power and geographic diversity measures.
* In `author_affiliations/` is provided methods for:
  1. Extracting outputs by journal from the Scopus Content Search API, enriching affiliation information with the Scopus Affiliation API, geo-locating enriched locations with Google's Geocode API, and then combining all outputs to obtain a geo-located author-output-affiliation database.
  2. Computing stdist and centroids for authorial outputs of the top journals in Econ.
  3. Computing authorial power at a gridded set of points on the globe for comparison to maps of editorial power. 

# Disclaimer
_While the authors have made reasonable efforts to ensure the accuracy of the data provided here, the authors assume no responsibility or liability for any errors or omissions in the data, nor for the results obtained from the use of the data. The data is provided "as is", with no guarantee of completeness, accuracy, timeliness or of the results obtained from the use of this data._

