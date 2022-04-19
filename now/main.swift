//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation
import ArgumentParser

/// A command that checks the time at remote locations
struct Now: ParsableCommand {
    static var configuration = CommandConfiguration(
        discussion: """
        Check the time at a given location, "now Sao Paolo Brazil". Locations
        are diacritical and case insensitive.  Use postcodes, cities, states,
        countries, even place names like "now Lincoln Memorial"

        When it's this time here: "now --local 5PM Bath UK"
        When it's that time there: "now --remote 5PM Bath UK"
        
        Valid time styles: 5PM, 5:30PM, 17:30, 1730. (No spaces.)
        """,
        version: "1.1"
    )

    @Option(
        name: [.short, .customLong("local"), .customLong("here"), .customLong("at"), .customShort("@")],
        help: "When it's this local time.")
    var localTime: String?
    
    @Option(
        name: [.short, .customLong("remote"),  .customLong("when"), .customLong("there")],
        help: "When it's this remote time.")
    var remoteTime: String?
    
    @Flag(
        name: .shortAndLong,
        help: "Output JSON results.")
    var json: Bool = false
    
    @Argument(parsing: .remaining)
    var locationInfo: [String]

    func run() throws {
        guard
            localTime == nil || remoteTime == nil
            else { throw RuntimeError.localRemoteOverlap }

        let hint = locationInfo.joined(separator: " ")
        try PlaceFinder.showTime(from: hint, at: localTime ?? remoteTime, castingTimeToLocal: remoteTime != nil, outputJSON: json)
    }    
}

Now.main()
