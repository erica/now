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
        // Parse date in preferred order
        let dateFormatter = DateFormatter()
        var date: Date?
        for format in ["h:ma", "ha", "H:m", "HH", "Hm", "HHmm"] {
            dateFormatter.dateFormat = format
            if let parsed = dateFormatter.date(from: string) {
                date = parsed
                break
            }
        }
        
        // Ensure date was constructed
        guard
            let componentDate = date
            else { throw RuntimeError.timeParseFailure }
                
        // Construct YMD components from now
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        // Construct HM components from constructed date
        let hour = calendar.component(.hour, from: componentDate)
        let minute = calendar.component(.minute, from: componentDate)

        // Combine
        guard let adjustedDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))
            else { throw RuntimeError.timeAdjustError }
        return adjustedDate
    }
}
