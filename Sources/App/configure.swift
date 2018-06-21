import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure our database
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)apps.db"))
    databaseConfig.add(database: db, as: .sqlite)
    services.register(databaseConfig)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: AppInformation.self, database: .sqlite)
    services.register(migrations)

}
