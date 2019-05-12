//
//  Order.swift
//  App
//
//  Created by Mohammed Ibrahim on 2019-05-12.
//

import FluentSQLite
import Vapor
import Foundation

// Inherit from Content class in order to be able use
// this Order type as content for leaf files
struct Order: Content, SQLiteModel, Migration {
    var id: Int?
    var cakeName: String
    var buyerName: String
    var date: Date?
}
