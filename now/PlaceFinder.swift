//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import CoreLocation

typealias PlaceFindingResult = Result<[CLPlacemark], Error>

/// A utility type to locate a place marker and print out a time with respect to that point.
enum PlaceFinder {
    /// Retrieve a placemark from a descriptive string.
    /// - Parameter hint: A free-form location indicator, such as a city name, zip code, place of interest.
    /// - Returns: A `PlaceFindingResult` of the geocoded place hint
    static func fetchPlaceMark(from hint: String) -> PlaceFindingResult {
        var result: Result<[CLPlacemark], Error> = Result(nil, RuntimeError.locationFetchFailure)
        CLGeocoder().geocodeAddressString(hint) { placemarks, error in
            result = Result(placemarks, error)
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        CFRunLoopRun()
        return result
    }
    
    /// Display a user-localized time (medium style) for a timezone described by freeform text
    ///
    /// This uses the current time to fetch the time zone abbreviation so there will be errors at the very
    /// edges of daylight changes.
    ///
    /// - Parameters:
    ///   - hint: A free-form location indicator, such as a city name, zip code, place of interest.
    ///   - date: An absolute date that will be adjusted to a timezone, localized to the user, and printed.
    ///   - localCast: Look up the remote time and cast it to the local zone
    /// - Throws: A `RuntimeError` if the target timezone cannot be interpreted.
    static func showTime(from hint: String, at timeSpecifier: String?, castingTimeToLocal localCast: Bool = false) throws {
        
        let placemarks = try fetchPlaceMark(from: hint).get()
        guard !placemarks.isEmpty
            else { throw RuntimeError.locationFetchFailure }
        let placemark = placemarks[0]
        
        guard
            let place = placemark.name,
            let timeZone = placemark.timeZone,
            let timeZoneAbbr = placemark.timeZone?.abbreviation(for: Date()),
            let timeZoneName = placemark.timeZone?.localizedName(for: .generic, locale: .current)
            else { throw RuntimeError.timeConversionFailure }
        
        func printOutput(time: String, zone: String, zoneName: String) {
            print(#"\#(localCast ? "Local" : "\(place)") \#(time) (\#(zone) \#(zoneName))"#)
        }
        
        let localTimeZone = Locale.autoupdatingCurrent.calendar.timeZone
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.timeZone = localCast ? localTimeZone : timeZone
        
        guard let timeSpecifier = timeSpecifier else {
            let time = formatter.string(from: Date())
            printOutput(time: time, zone: timeZoneAbbr, zoneName: timeZoneName)
            return
        }
        
        let date = try Date.date(from: timeSpecifier)

        guard localCast == true else {
            let time = formatter.string(from: date)
            printOutput(time: time, zone: timeZoneAbbr, zoneName: timeZoneName)
            return
        }

        guard
            let localAbbreviation = localTimeZone.abbreviation(),
            let localName = localTimeZone.localizedName(for: .generic, locale: Locale.autoupdatingCurrent)
            else { throw RuntimeError.timeConversionFailure }
        
        let localSeconds = localTimeZone.secondsFromGMT()
        let remoteSeconds = timeZone.secondsFromGMT()
        let calendar = Calendar.autoupdatingCurrent
        guard let newDate = calendar.date(byAdding: .second, value: localSeconds - remoteSeconds, to: date)
            else { throw RuntimeError.timeConversionFailure }
        let time = formatter.string(from: newDate)
        printOutput(time: time, zone: localAbbreviation, zoneName: localName)
    }
}
