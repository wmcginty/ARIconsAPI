import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let group = router.grouped("apps")
    group.get(AppInformation.parameter, use: ApplicationRouteController.fetchApplication)
    group.post(AppInformation.self, at: "add", use: ApplicationRouteController.addNewApplication)
    group.get(use: ApplicationRouteController.fetchApplications)
}
