//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

/// Errors encountered while running this command
enum RuntimeError: String, Error, CustomStringConvertible {
    var description: String { rawValue }

    /// Mutual exclusion between `at` and `when`
    case localRemoteOverlap = "Cannot specify both remote and local times. Pick one."
    
    /// Time cannot be parsed
    case timeParseFailure = "Unable to parse hours and minutes from time string."
    
    /// Time components cannot be adjusted
    case timeAdjustError = "Failed to adjust time."
    
    /// Location cannot be fetched
    case locationFetchFailure = "Unable to fetch geocoded location information"
    
    /// Conversion fail
    case timeConversionFailure = "Time zone conversion failed."
}
