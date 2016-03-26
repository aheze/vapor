import Vapor

class UserController: Controller<User> {
    required init(application: Application) {
        super.init(application: application)
        
        Log.info("User controller created")
    }
    
    /// Display many instances
    override func index(request: Request) throws -> ResponseConvertible {
        return Json([
            "controller": "MyController.index"
        ])
    }
    
    /// Create a new instance.
    override func store(request: Request) throws -> ResponseConvertible {
        return Json([
            "controller": "MyController.store"
        ])
    }
    
    /// Show an instance.
    override func show(request: Request, item: User) throws -> ResponseConvertible {
        return Json([
            "controller": "MyController.show",
        ])
    }
    
    /// Update an instance.
    override func update(request: Request, item: User) throws -> ResponseConvertible {
        return Json([
            "controller": "MyController.update",
        ])
    }
    
    /// Delete an instance.
    override func destroy(request: Request, item: User) throws -> ResponseConvertible {
        Log.info("Delete: \(item)")
        
        return item
    }
    
}
