//  Copyright © 2020 Erica Sadun. All rights reserved.

import Foundation

struct LocatedTime: Codable {
    let version: String = "1"
    let place: String
    let time: String
    let timeZone: String
    let zoneName: String
}
