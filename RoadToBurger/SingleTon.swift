import Foundation

class UserSingleton: NSObject {
    static let sharedInstance = UserSingleton()
    var username: String = ""
    var _id: String = ""
    
    private override init() {
        
    }
    
    func setUser(usuario: User) {
        username = usuario.nombre
        _id = usuario._id
    }
}
