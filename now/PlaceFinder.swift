//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import CoreLocation

/// A utility type to locate a place marker and print out a time with respect to that point.
enum PlaceFinder {
    /// Retrieve a placemark from a descriptive string.
    /// - Parameter hint: A free-form location indicator, such as a city name, zip code, place of interest.
    /// - Throws: geocoding errors from `CLGeocoder`
    /// - Returns: A `CLPlacemark` matching the text hint
    static func fetchPlaceMark(from hint: String) throws -> CLPlacemark {
        var result: Result<[CLPlacemark], Error> = Result([], nil)
        
        CLGeocoder().geocodeAddressString(hint) { placemarks, error in
            result = Result(placemarks, error)
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        CFRunLoopRun()
        
        let placemarks = try result.get()
        return placemarks[0]
    }
    
    /// Display a user-localized time (medium style) for a timezone described by freeform text
    /// - Parameters:
    ///   - hint: A free-form location indicator, such as a city name, zip code, place of interest.
    ///   - date: An absolute date that will be adjusted to a timezone, localized to the user, and printed.
    ///   - castLocal: Look up the remote time and cast it to the local zone
    /// - Throws: A `RuntimeError` if the target timezone cannot be interpreted.
    static func showTime(from hint: String, date: Date = Date(), castingTimeToLocal castLocal: Bool = false) throws {
        let placemark = try fetchPlaceMark(from: hint)
        guard
            let timeZone = placemark.timeZone
            else { throw RuntimeError.timezoneFetchFailure }
        
        var date = date
        if castLocal {
            let ourseconds = Locale.autoupdatingCurrent.calendar.timeZone.secondsFromGMT()
            guard
                let theirseconds = placemark.timeZone?.secondsFromGMT(),
                let reverseDate = Calendar.autoupdatingCurrent.date(byAdding: .second, value: ourseconds - theirseconds, to: date)
                else { throw RuntimeError.inexplicableFailure }
            date = reverseDate
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        if !castLocal { formatter.timeZone = timeZone }
        let stringDate = formatter.string(from: date)
        
        let timezoneFormatter = DateFormatter()
        timezoneFormatter.dateFormat = " (z vvvv)"
        if !castLocal { timezoneFormatter.timeZone = timeZone }

        if !castLocal, let name = placemark.name { print("\(name) ", terminator: "") }
        else { print("Local ", terminator: "") }
        
        print(stringDate, terminator: "")
        print(timezoneFormatter.string(from: Date()))
    }
}
