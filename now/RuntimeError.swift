import Foundation

/// A stringity error type representing runtime errors encountered by this utility
struct RuntimeError: Error, CustomStringConvertible {
    var description: String    
    init(_ description: String) {
        self.description = description
    }
}
