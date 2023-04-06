import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.memory), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateRoom())
    
    app.logger.logLevel = .debug
      
    try app.autoMigrate().wait()
    
    try app.register(collection: UserController())
    try app.register(collection: RoomController())
    
    // register routes
    try routes(app)
}
