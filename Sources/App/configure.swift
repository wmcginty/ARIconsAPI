import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

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
    var databases = DatabasesConfig()
    let databaseConfig = try configuredPostgreSQLDatabaseConfig(with: env)
    let database = databaseConfig.map(PostgreSQLDatabase.init)
    database.map { databases.add(database: $0, as: .psql) }
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: AppInformation.self, database: .psql)
    services.register(migrations)
}

func configuredPostgreSQLDatabaseConfig(with env: Environment) throws -> PostgreSQLDatabaseConfig? {
    guard let url = Environment.get("DATABASE_URL") else {
        return PostgreSQLDatabaseConfig(hostname: "localhost",
                                        port: 5432,
                                        username: "willmcginty",
                                        database: "appinfos")
    }
    
    return try PostgreSQLDatabaseConfig(url: url)
}
