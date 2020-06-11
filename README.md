# Now

I wrote this first for sample code, then for myself, then for friends.

I didn't intend to push this out but darn if it isn't useful.

## Usage

```
OVERVIEW: 

Check the time at a given location, "now Sao Paolo Brazil". Locations
are diacritical and case insensitive.  Use postcodes, cities, states,
countries, even place names like "now Lincoln Memorial"

When it's this time here: "now --local 5PM Bath UK"
When it's that time there: "now --remote 5PM Bath UK"

Valid time styles: 5PM, 5:30PM, 17:30, 1730. (No spaces.)

USAGE: now [--local <local>] [--remote <remote>] [<location-info> ...]

ARGUMENTS:
  <location-info>

OPTIONS:
  -@, -l, --at, --here, --local <local>
                          When it's this local time 
  -r, --when, --there, --remote <remote>
                          When it's this remote time 
  -h, --help              Show help information.

% now sao paolo brazil
São Paulo 3:50:58 PM (GMT-3 Brasilia Standard Time)
% now --local 4PM sao paolo brazil
São Paulo 9:00:00 PM (GMT-3 Brasilia Standard Time)
% now --remote 4PM sao paolo brazil
Local 1:00:00 PM (GMT-3 Brasilia Standard Time)
```

*Note: Bug filed because help is showing `when` and not `remote` as the value for the remote time.*

## Known issues

* This can break at the edges of daylight time changes.
* Casting times (local and remote) will break when VPNs change your "location"

## Installation

* Install [homebrew](https://brew.sh).
* Install [mint](https://github.com/yonaskolb/Mint) with homebrew (`brew install mint`).
* From command line: `mint install erica/now`

## Dependencies

* [Swift-Argument-Parser](https://github.com/apple/Swift-Argument-Parser)

## Building

* Build from Xcode (there's a custom build phase that installs to /usr/local/bin, so make sure you have write access)
* Build from SPM: `swift build` in the top level directory. The built utility can be found in `.build/debug/now`. Run with `swift run`

## Thanks

*I just started this section so if you pitched in and I forgot to mention you, please let me know so I can update this!*

Darren Ford (code review), Ryan Booker ([code review and improvements](https://github.com/ryanbooker/now/blob/master/Sources/now/main.swift), and not least Paul Hudson (for living in the wrong time zone)

## Help Request

I want to add tests that will work regardless of where the utility is built and tested. (I do all tests outside of Xcode right now.) 

If you have suggestions or pointers, please let me know. Thanks!
