//
//  ApplicationRouteController.swift
//  ARIcons-ServerPackageDescription
//
//  Created by William McGinty on 6/21/18.
//

import Vapor

struct ApplicationRouteController {
    
    static func addNewApplication(_ request: Request, info: AppInformation) throws -> Future<HTTPResponseStatus> {
        return info.create(on: request).transform(to: .ok)
    }
    
    static func fetchApplications(_ request: Request) throws -> Future<[AppInformation]> {
        return AppInformation.query(on: request).all()
    }
    
    static func fetchApplication(_ request: Request) throws -> Future<AppInformation> {
        return try request.parameters.next(AppInformation.self)
    }
}
