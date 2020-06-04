//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import CoreLocation

typealias PlaceFindingResult = Result<[CLPlacemark], Error>

protocol DateToStringFormatter {
    func string(from date: Date) -> String
}

extension DateFormatter: DateToStringFormatter {}
extension ISO8601DateFormatter: DateToStringFormatter {}

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
    static func showTime(from hint: String, at timeSpecifier: String?, castingTimeToLocal localCast: Bool = false, outputJSON: Bool) throws {
        
        // Fetch placemark
        let placemarks = try fetchPlaceMark(from: hint).get()
        guard !placemarks.isEmpty
            else { throw RuntimeError.locationFetchFailure }
        let placemark = placemarks[0]
        
        // Extract place and zone information from placemark
        guard
            let place = placemark.name,
            let timeZone = placemark.timeZone,
            let timeZoneAbbr = placemark.timeZone?.abbreviation(for: Date()),
            let timeZoneName = placemark.timeZone?.localizedName(for: .generic, locale: .current)
            else { throw RuntimeError.timeConversionFailure }
        
        /// A pretty-printed JSON encoder
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.outputFormatting = .prettyPrinted
        
        /// The local time zone
        let localTimeZone = Locale.autoupdatingCurrent.calendar.timeZone

        /// The default formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = localCast ? localTimeZone : timeZone
        
        /// Flexible formatter
        let formatter: DateToStringFormatter = outputJSON ? ISO8601DateFormatter() : dateFormatter
                
        func printOutput(time: String, zone: String, zoneName: String) throws {
            switch outputJSON {
            case true:
                let located = LocatedTime(place: localCast ? "Local" : place, time: time,
                                          timeZone: zone, zoneName: zoneName)
                let json = try jsonEncoder.encode(located)
                if let jsonString = String(data: json, encoding: .utf8) {
                    print(jsonString)
                } else { throw RuntimeError.jsonError }
                
            case false:
                print(#"\#(localCast ? "Local" : "\(place)") \#(time) (\#(zone) \#(zoneName))"#)
            }
        }
        
        // Current time at remote location
        guard let timeSpecifier = timeSpecifier else {
            let time = formatter.string(from: Date())
            try printOutput(time: time, zone: timeZoneAbbr, zoneName: timeZoneName)
            return
        }
        
        // Specified time
        let date = try Date.date(from: timeSpecifier)

        // Specified time at remote location
        guard localCast == true else {
            let time = formatter.string(from: date)
            try printOutput(time: time, zone: timeZoneAbbr, zoneName: timeZoneName)
            return
        }

        // Specified remote time at local location
        guard
            let localAbbreviation = localTimeZone.abbreviation(),
            let localName = localTimeZone.localizedName(for: .generic, locale: Locale.autoupdatingCurrent)
            else { throw RuntimeError.timeConversionFailure }
        let localSeconds = localTimeZone.secondsFromGMT()
        let remoteSeconds = timeZone.secondsFromGMT()
        guard let newDate = Calendar.autoupdatingCurrent.date(byAdding: .second, value: localSeconds - remoteSeconds, to: date)
            else { throw RuntimeError.timeConversionFailure }
        let time = formatter.string(from: newDate)
        try printOutput(time: time, zone: localAbbreviation, zoneName: localName)
    }
}
