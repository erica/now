import Foundation
import CoreLocation

/// A utility type to locate a place marker and print out a time with respect to that point.
enum PlaceFinder {
    /// Retrieve a placemark from a descriptive string.
    /// - Parameter hint: A free-form location indicator, such as a city name, zip code, place of interest.
    /// - Throws: `RuntimeError` if the location is not found
    /// - Returns: A `CLPlacemark` matching the text hint
    static func fetchPlaceMark(from hint: String) throws -> CLPlacemark {
        var _placemarks: [CLPlacemark]?
        var _error: Error?
        
        CLGeocoder().geocodeAddressString(hint) { __placemarks, __error in
            (_placemarks, _error) = (__placemarks, __error)
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
        CFRunLoopRun()

        if let error = _error { throw error }
        guard
            let placemarks = _placemarks,
            !placemarks.isEmpty
            else { throw RuntimeError("Locations not found") }
        return placemarks[0]
    }
    
    /// Display a user-localized time (medium style) for a timezone described by freeform text
    /// - Parameters:
    ///   - hint: A free-form location indicator, such as a city name, zip code, place of interest.
    ///   - date: An absolute date that will be adjusted to a timezone, localized to the user, and printed.
    /// - Throws: A `RuntimeError` if the target timezone cannot be interpreted.
    static func showTime(from hint: String, date: Date = Date(), reverse: Bool = false) throws {
        let placemark = try fetchPlaceMark(from: hint)
        guard let timeZone = placemark.timeZone
            else { throw RuntimeError("Timezone not retrieved") }
        
        var date = date
        if reverse {
            let ourseconds = Locale.autoupdatingCurrent.calendar.timeZone.secondsFromGMT()
            guard
                let theirseconds = placemark.timeZone?.secondsFromGMT(),
                let reverseDate = Calendar.autoupdatingCurrent.date(byAdding: .second, value: ourseconds - theirseconds, to: date) else {
                throw RuntimeError("Inexplicable time zone conversion fail. Sorry.")
            }
            date = reverseDate
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        if !reverse { formatter.timeZone = timeZone }
        let stringDate = formatter.string(from: date)
        
        let timezoneFormatter = DateFormatter()
        timezoneFormatter.dateFormat = " (z vvvv)"
        if !reverse { timezoneFormatter.timeZone = timeZone }

        if !reverse, let name = placemark.name { print("\(name) ", terminator: "") }
        else { print("Local ", terminator: "") }
        
        print(stringDate, terminator: "")
        print(timezoneFormatter.string(from: Date()))
    }
}
