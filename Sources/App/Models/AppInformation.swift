//
//  App.swift
//  ARIcons-ServerPackageDescription
//
//  Created by William McGinty on 6/21/18.
//

import Vapor
import FluentPostgreSQL

struct AppInformation: Content, PostgreSQLModel, Migration, Parameter {
    
    var id: Int?
    let title: String
    let storeURL: URL?
    let description: String?
}
