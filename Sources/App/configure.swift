import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.memory), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateRoom())
    app.migrations.add(CreateTeam())
    
    app.logger.logLevel = .debug
      
    try app.autoMigrate().wait()
    
    try app.register(collection: UserController())
    try app.register(collection: RoomController())
    try app.register(collection: TeamController())
    
    // register routes
    try routes(app)
}
