# The Geographic Diversity Project
_Providing the Economics community with information on the geographic diversity of journals._

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

# Disclaimer
_While the authors have made reasonable efforts to ensure the accuracy of the data provided here, the authors assume no responsibility or liability for any errors or omissions in the data, nor for the results obtained from the use of the data. The data is provided "as is", with no guarantee of completeness, accuracy, timeliness or of the results obtained from the use of this data._

