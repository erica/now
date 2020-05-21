# Now

I wrote this first for sample code, then for myself, then for friends.

I didn't intend to push this out but darn if it isn't useful.

## Usage

```
% now
OVERVIEW:
Check the time at a given location, "now Sao Paolo".

Locations are diacritical and case insensitive.  Use postcodes, cities,
states, countries, even place names like "now Lincoln Memorial"

Set a reference time with `at`: "now --at 5P Bath UK"
Retrieve the reference time with `when`: "now --when 5P Bath UK"

Valid time styles: 5PM, 5P, 5:30PM, 5:30P, 17:30, 1730. (No spaces.)

USAGE: now [--time <time>] [--when <when>] [<location-info> ...]

ARGUMENTS:
  <location-info>

OPTIONS:
  -@, -t, --at, --time <time>
                          At this local time 
  --when <when>           When it's this time at that location 
  -h, --help              Show help information.

% now sao paolo
São Paulo 10:09:43 PM (GMT-3 Brasilia Standard Time)
% now --at 4:30P sao paolo
São Paulo 7:30:00 PM (GMT-3 Brasilia Standard Time)
% now --when 4:30P sao paolo
Local 1:30:00 PM (MDT Mountain Time)
```

## Dependencies

* [Swift-Argument-Parser](https://github.com/apple/Swift-Argument-Parser)

## Building

* Build from Xcode (there's a custom build phase that installs to /usr/local/bin, so make sure you have write access)
* Build from SPM: `swift build` in the top level directory. The built utility can be found in `.build/debug/now`. Run with `swift run`

