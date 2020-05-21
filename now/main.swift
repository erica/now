import Foundation
import ArgumentParser

/// A command that checks the time at remote locations
struct Now: ParsableCommand {
    static var configuration = CommandConfiguration(
        discussion: """
        Check the time at a given location, "now Sao Paolo".

        Locations are diacritical and case insensitive.  Use postcodes, cities,
        states, countries, even place names like "now Lincoln Memorial"

        Set a reference time with `at`: "now --at 5P Bath UK"
        Retrieve the reference time with `when`: "now --when 5P Bath UK"
        
        Valid time styles: 5PM, 5P, 5:30PM, 5:30P, 17:30, 1730. (No spaces.)
        """)
    
    @Option(
        name: [.customLong("time"), .long, .customShort("t"), .customShort("@")],
        help: "At this local time")
    var at: String?
    
    @Option(
        name: [.long],
        help: "When it's this time at that location")
    var when: String?
    
    @Argument(parsing: .remaining)
    var locationInfo: [String]

    func run() throws {
        guard
            CommandLine.argc > 1
            else { throw CleanExit.helpRequest() }
        
        guard
            at == nil || when == nil
            else { throw RuntimeError("Cannot specify both --at and --when. Pick one.") }

        let hint = locationInfo.joined(separator: " ")
        let date: Date
        switch at ?? when {
        case let timeSpecifier?:
            date = try Date.date(from: timeSpecifier)
        default:
            date = Date()
        }
        try PlaceFinder.showTime(from: hint, date: date, castingTimeToLocal: when != nil)
    }    
}

Now.main()

