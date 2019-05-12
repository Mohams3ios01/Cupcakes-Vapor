//
//  Cupcake.swift
//  App
//
//  Created by Mohammed Ibrahim on 2019-05-11.
//

import Foundation
import Vapor
import FluentSQLite

// Inherit from Content class in order to be able use
// this Cupcake type as content for leaf files
struct Cupcake: Content, SQLiteModel, Migration {
    var id: Int?
    var name: String
    var description: String
    var price: Int
}
