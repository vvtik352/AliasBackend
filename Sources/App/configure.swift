import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.memory), as: .sqlite)
    app.logger.logLevel = .debug
      
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRoom())
    
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
