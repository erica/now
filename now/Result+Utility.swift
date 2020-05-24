//  Copyright © 2020 Erica Sadun. All rights reserved.

public extension Result {
    /// Initializes a `Result` from a completion handler's `(data?, error?)`.
    ///
    /// When both data and error are non-nil, `Result` first populates the
    /// `.failure` member over the `success`.
    ///
    /// - Parameters:
    ///   - data: the optional data returned via a completion handler
    ///   - error: the optional error returned via a completion handler
    init(_ data: Success?, _ error: Failure?) {
        precondition(!(data == nil && error == nil))
        switch (data, error) {
        case (_, let failure?): self = .failure(failure)
        case (let success?, _): self = .success(success)
        default:
            fatalError("Cannot initialize `Result` without success or failure")
        }
    }
}
