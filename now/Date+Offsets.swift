//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

extension Date {
    
    /// Returns a reminder date from a string formatted either hour-24:minute or hour:minute-meridian.
    ///
    /// This method constructs a date from an hour and minute representation.
    /// The date is calculated from "now", moving to midnight and adding the hour and minute components.
    /// If the new date is earlier than "now", it's pushed forward 24 hours, producing the first possible
    /// instance of that hour/minute time in the future.
    ///
    /// - Parameter string: a string formatted either as "h:ma" or "H:m"
    /// - Throws: `RuntimeError`s when unable to parse the input string.
    /// - Returns: A new date, initialized to the offset of the date either today or tomorrow.
    static func date(from string: String) throws -> Date {

        // Establish partial date from string or throw. The string
        // provides hour and minute offsets from midnight.
        let dateFormatter = DateFormatter()
        var date: Date?
        for format in ["h:ma", "ha", "H:m", "HH", "Hm", "HHmm"] {
            dateFormatter.dateFormat = format
            if let parsed = dateFormatter.date(from: string) {
                date = parsed
                break
            }
        }
        
        guard
            let componentDate = date
            else { throw RuntimeError("Unable to parse hours and minutes from time string.") }
        
        let components = NSCalendar.autoupdatingCurrent
            .dateComponents([.hour, .minute], from: componentDate)
        guard
            let hourComponent = components.hour,
            let minuteComponent = components.minute
            else { throw RuntimeError("Unable to extract minute and hour components from time string.") }
        
        // Calculate the target date by starting with the time representing "now",
        // replacing the hour and minute components to represent a time for "today"
        var targetDate = Date(timeIntervalSinceReferenceDate: 24 * 60 * 60)
        
        guard
            let newDateWithHour = NSCalendar.autoupdatingCurrent
                .date(bySetting: .hour, value: hourComponent, of: targetDate)
            else { throw RuntimeError("Failed to set target hour.") }
        targetDate = newDateWithHour
        
        guard
            let newDateWithMinute = NSCalendar.autoupdatingCurrent
                .date(bySetting: .minute, value: minuteComponent, of: targetDate)
            else { throw RuntimeError("Failed to set target minute.") }
        targetDate = newDateWithMinute
        
        return targetDate
    }
}
