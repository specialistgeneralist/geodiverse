# GeoDiverse / Author Affiliations 2019-2020
_An exploration of the relationship between Editorial and Authorial power._

## Summary
In five discrete steps, the pipeline provided here obtains all authors, and their respective affiliations, for works from the top Econ journals list, over 2019-2020, and proceeds to geo-locate (lat-lon) the affiliations for further geo-spatial analysis.

## Details
Each step carries its own `example_method` note which shows the users which actions constitute the given step, and in what order.

### Step 1: Scopus API query of journal outputs
*Purpose:* In this step, an input journal name file, `journals_list_test.csv`, is used to send query information to the Scopus content search API (https://api.elsevier.com/content/search/), to obtain `json` data information on all outputs (authored papers) in a given journal.

*Notes on the method:*
1. Typically, the query returns only a certain number of results per page. To handle this, the query first works out the total number of results, and then consequetively sends queries to the API to get the next result page, until all result pages have been obtained.

*Requirements:*
1. You will need a valid Scopus API *access TOKEN* to run the query. Place this in line 5 in the `ACCESS_TOKEN` variable, in the file `scopus_query.sh`.
2. The query asks for a `COMPLETE` view from the API. This view is necessary, as without it, only the first-author information is returned. The `COMPLETE` view is only avaiable with Elsevier Insitutional access. For example, ensuring the IP address of originiating query is white-listed with the publisher of an institution with the required access.
3. The query runs in Linux, and assumes the `json` reader, `jq` is installed. Use of `xargs` and `awk` is also made.

*Example:*
```
$ ./run 'journals_list_test.csv'
```

### Step 2: Parse journal outputs
*Purpose:* Read all `json` files from Step 1 and parse into a table.

*Notes on the method:*
1. The main work of the method, `make_TableFromJournalJSONs()` is conducted in `parse_journal_json.m`. The main challenge is to handle the missing or non-symmetric data structures that are provided in the `json` files. In addition, it is important to note that the method focuses attention on three `subtypeDescription` fields from Scopus: `{'Article' 'Chapter' 'Review'}`. This is to avoid e.g. Editorials, or Financial updates from learned societies. Where key information is found to be missing, `null` is entered.
2. Given that the Scopus query is not implemented as an _exact_ match, the output table needs to be cleaned from by-catch. This is achieved with `clean_ToFocusJournals()`.
3. Finally, to reduce the number of `null` *afid* fields, the final method, `find_or_drop_afidNulls()`, attempts to find a plausible *afid* for a given *authid* from other outputs in the database. If more than one is found with the same *city* as the target output, then the most frequent use of *afid* by the *authid* is used.

*Requirements:*
1. The method runs in _Matlab_, and makes extensive use of the `jsondecode()` method.

*Example:*
```
>> make_TableFromJournalJSONs('../step1-Scopus_query_journal_outputs/outputs_json/', 'test_authors_unclean.csv')
 --> found 4 files to parse --> parsing: Journal_of_Monetary_Economics_25 ...omics_25 ...
 --> wrote test_authors_unclean.csv (261 rows)

>> clean_ToFocusJournals('test_authors_unclean.csv', '../step1-Scopus_query_journal_outputs/journals_list_test.csv')
 --> cleaned to journal list. (was 261 rows, now 261 rows)
 --> new unique journal count: 2.
 --> wrote test_authors_cleaned.csv (261 rows)

>> find_or_drop_afidNulls('test_authors_cleaned.csv')
 --> found 260 unique author--affiliation--paper rows ...
 --> found 0 nulls. No further processing.
 --> wrote _nulls.csv (0 rows) and _nonulls.csv (260 rows).
 ```

### Step 3: Scopus API query of unique affiliations IDs
*Purpose:* Having parsed all of the author--output--affiliation information from the first query, Step 3 obtains a unique listing of Scopus *afid*s (affiliation IDs) and uses a second Scopus API (https://api.elsevier.com/content/affiliation/affiliation_id/) to get additional location information (street,city,state,country) about the *afid*, to enrich the geo-location search in the next step.

*Notes on the method:*
1. First, a unique set of *afid*s is obtained with `get_UniqueAffiliations()`.
2. Then, the main API query is conducted by `run.sh`. For this to work, you will need a valid Scopus API *access TOKEN* to run the query. Place this in line 5 in the `ACCESS_TOKEN` variable, in the file `scopus_query.sh`. Though the query asks for the `STANDARD` view from the API it will still only be avaiable with Elsevier Insitutional access. For example, ensuring the IP address of originiating query is white-listed with the publisher of an institution with the required access.
3. Finally, `join_afidInfo()` joins the `json` output files just created into a single table for the next step.

*Requirements:*
1. Parts 1 and 3 run in _Matlab_, with part 3 making extensive use of the `jsondecode()` method.
2. Part 2 runs in Linux, and requires a valid Scopus access token (see above).

*Example:*
```
>> get_UniqueAffiliations('../step2-parse_journal_outputs/test_authors_cleaned_nonulls.csv', 'test_scopus_unique_affiliations.csv')

[on Institutional IP WHITE-LIST computer,
% ./run.sh 'test_scopus_unique_affiliations.csv'
]

>> join_afidInfo('outputs_json/id_*', 'test_scopus_unique_affiliations.csv', 'test_scopus_unique_affiliations_wInfo.csv')
```

### Step 4: Google API query of enriched affiliation information

*Purpose:* With enriched search information for each *afid*, we pass all this information to a Google API geocode query to obtain a precise, or approximate *lat* and *lon* for the affiliation location.

*Notes on the method:*
1. The method `run_GoogleAPIquery()` handles the API interaction. Importantly, we store the field *geometry.location_type* from the output which is useful to understand how accurately the API was able to geo-locate the address.

*Requirements:*
1. The method is orchestrated in _Matlab_, and makes extensive use of the `jsondecode()` method.
1. You will need a valid Google  API *access TOKEN* to run the query. Place this in line 5 in the `ACCESS_TOKEN` variable, in the file `scopus_query.sh`. You will also need to set up a billing account, create a project, and enable Geocode API for the project (see https://developers.google.com/maps/gmp-get-started#enable-api-sdk).

*Example:*
```
>> run_GoogleAPIquery('../step3-Scopus_query_affiliation_IDs/test_scopus_unique_affiliations_wInfo.csv', 'test_scopus_unique_affiliations_wInfo_wLatLon.csv')
```

### Step 5: Join affiliation geo-locations to author--output--affiliations

*Purpose:* The final step brings the geo-located affiliation information to the author--output--affiliation database, using *afid* as the join key.

*Notes on the method:*
1. Two outputs are produced by `join_GeoToJournal()`, one which includes all geo-location information from the previous step, and another which includes only author--output--affiliation rows where the geo-location was not `GEOMETRIC_CENTER`. The latter output is indicated by the file suffix, `_refined.csv`. This is used for down-stream comparison as some use cases may require a very precise geo-location (e.g. `ROOFTOP`).

*Requirements:*
1. The method is run in _Matlab_.

*Example:*
```
>> join_GeoToJournal('../step2-parse_journal_outputs/test_authors_cleaned_nonulls.csv', '../step4-GoogleAPI_query_affiliation_geolocations/test_scopus_unique_affiliations_wInfo_wLatLon.csv', 'test_authors_outputs_affiliations_geo.csv')
 --> found 260 author-affiliation rows ...
 --> found 159 geo--affiliation rows ...
 --> reduced geo--affiliation table to 143 unique afid rows ...
 --> have 250 author-affiliation-geo rows after join ...
 --> main table: 250 rows; refined (drop bad Google Types): 190 rows.
 --> wrote test_authors_outputs_affiliations_geo.csv (250 rows), and test_authors_outputs_affiliations_geo_refined.csv (190 rows).
```

## Thanks
