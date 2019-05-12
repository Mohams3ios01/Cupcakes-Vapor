//
//  Order.swift
//  iOSCupcakes
//
//  Created by Mohammed Ibrahim on 2019-05-12.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import Foundation

// Codable makes it easy to encode to json when sending it thru the api
struct Order: Codable {
    var cakeName: String
    var buyerName: String
}
