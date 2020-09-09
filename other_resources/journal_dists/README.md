```
function compute_stdist(INFILE, OUTFILE)

% COMPUTE_STDIST computes the average standard distance of editorial
%   affiliation data in km and outputs the result.
%
% The average standard distance is the average distance, from the
% geographic centre, of a group of points distributed on a sphere.
% All measures are thus great-circle distances.
%
% Usage:
%   COMPUTE_STDIST(INFILE, OUTFILE) computes STDIST for all lat-lon
%     points associated with a given unique Journal name, given
%     in the tab-delimited file INFILE, and produces a summary, by
%     journal in the file OUTFILE.
%
% Example:
% >> compute_stdist('journals.csv', 'journals_stdist.csv')
%
% By: SD Angus, K Atalay, J Newton, D Ubilava (2020) for the
%     Geographic Diversity Project; @geodiverse
%
%     Code written by: SD Angus (Monash University)
%
% See also STDIST DEG2KM ROWFUN
```