import Foundation


/// Errors encountered while running this command
enum RuntimeError: String, Error {
    /// Mutual exclusion between `at` and `when`
    case atWhenOverlap = "Cannot specify both --at and --when. Pick one."
    
    /// Time cannot be parsed
    case timeParseFailure = "Unable to parse hours and minutes from time string."
    
    /// Hour cannot be set
    case targetHourFailure = "Failed to set target hour."
    
    /// Minute cannot be set
    case targetMinuteFailure = "Failed to set target minute."
    
    /// Location cannot be fetched
    case locationFetchFailure = "Unable to fetch location information"
    
    /// Timezone cannot be fetched
    case timezoneFetchFailure = "Timezone not retrieved"
    
    /// This should never happen
    case inexplicableFailure = "Inexplicable time zone conversion fail. Sorry."
}
