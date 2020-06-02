# JSON Output

## Version 1

The `now` utility uses `CLGeocoder` to geocode place descriptions. Placemark information is limited to the scope and standards inherited from Core Location.

These fields should not vary by the locale of utility's invocation:

`version`: the JSON output format version, increased incrementally. The current version is 1.
`time`: an [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) formatted date.

These fields *will* vary by the locale of invocation:

`place`: a human-readable localized place name.
`zone_name`: a human-readable localized time zone name.
`time_zone`: a time zone designation. The time zone is not guaranteed to be uniform, for example either `MDT` or `GMT+6` may be produced for Mountain Daylight Time.

### Example

```
% now -j uk
{
  "place" : "United Kingdom",
  "zone_name" : "United Kingdom Time",
  "time_zone" : "GMT+1",
  "time" : "2020-06-04T20:53:58Z",
  "version" : "1"
}
```