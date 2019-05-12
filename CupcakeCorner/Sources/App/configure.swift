import Vapor
import Leaf
import Fluent
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure the rest of your application here
    // Render HTML using Leaf
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self) // Prefer Leaf files to render views
    
    // Configure directory file-system
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    // Configure FluentSQLite
    try services.register(FluentSQLiteProvider())
    
    // Configure file to save files to
    var databaseConfig = DatabasesConfig()
    let db = try SQLiteDatabase(storage: .file(path: "\(directoryConfig.workDir)cupcake.db"))
    databaseConfig.add(database: db, as: .sqlite) // attaches database to this variable (.sqlite) to refer to it in the future easily
    services.register(databaseConfig)
    
    // Configure migrations
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Cupcake.self, database: .sqlite) // registers object type as appropriate data for SQLite
    migrationConfig.add(model: Order.self, database: .sqlite) // registers object type as appropriate data for SQLite
    services.register(migrationConfig)
}
