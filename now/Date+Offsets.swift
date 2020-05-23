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
        
        // Establish midnight.
        // If offset is not possible, use unmodified date
        let now = Date()
        let year = Calendar.autoupdatingCurrent.component(.year, from: now)
        let month = Calendar.autoupdatingCurrent.component(.month, from: now)
        let day = Calendar.autoupdatingCurrent.component(.day, from: now)
        let midnight = Calendar.autoupdatingCurrent.date(from: DateComponents(year: year, month: month, day: day)) ?? now

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
            else { throw RuntimeError.timeParseFailure }
        
        let components = NSCalendar.autoupdatingCurrent
            .dateComponents([.hour, .minute], from: componentDate)
        guard
            let hourComponent = components.hour,
            let minuteComponent = components.minute
            else { throw RuntimeError.timeParseFailure }
        
        // Calculate the target date by starting with the time representing "now",
        // replacing the hour and minute components to represent a time for "today"
        var targetDate = midnight
        
        guard
            let newDateWithHour = NSCalendar.autoupdatingCurrent
                .date(bySetting: .hour, value: hourComponent, of: targetDate)
            else { throw RuntimeError.targetHourFailure }
        targetDate = newDateWithHour
        
        guard
            let newDateWithMinute = NSCalendar.autoupdatingCurrent
                .date(bySetting: .minute, value: minuteComponent, of: targetDate)
            else { throw RuntimeError.targetMinuteFailure }
        targetDate = newDateWithMinute
        
        return targetDate
    }
}
