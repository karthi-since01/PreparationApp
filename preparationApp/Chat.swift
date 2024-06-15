import UIKit

struct User {
    let uid: String
    let displayName: String
    let email: String
    let profileImageURL: String
    let fcmTokenForAUser: String
}

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
