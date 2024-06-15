//
//  ChatNotificationController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/15/24.
//

import Foundation
import Firebase
import Alamofire

class ChatNotificationController {
    
    static let shared = ChatNotificationController()
    
    private let fcmEndpoint = "https://fcm.googleapis.com/v1/projects/preparationapp-6a34c/messages:send?access_token="
    
    // This access token expires at every 1 hour
    // regenerate by -> "gcloud auth print-access-token" -> use this command in terminal "mac".
    
    private let accessToken = "ya29.a0AXooCguSvIAUlMNmxCCT4soRA4UbdtT6n3C-vAoUt-AIWIBuOGp-Wyg8wRv7fAdFWKtLYD9geDdIkqWYpB7-S50xd_GiOeM0_k4m1EXJ1--OXn-Zc4p8ejoJZTwx5BXMF3QU2f3ChP12INMX7c0KQZNCUWlbZ1yXGxF52Fu1dBEaCgYKATYSARASFQHGX2Midcs4DlGpDe0P7BLWsvrnLA0178"
    
    func sendPushNotification(to token: String, title: String, body: String, data: [String: Any]) {
        
        let notificationPayload: [String: Any] = [
            "message": [
                "token": token,
                "notification": [
                    "title": title,
                    "body": body
                ],
                "data": data
            ]
        ]
        
        let url = "\(fcmEndpoint)\(accessToken)"
        
        AF.request(url, method: .post, parameters: notificationPayload, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(accessToken)"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("FCM response: \(value)")
                case .failure(let error):
                    print("Error sending push notification: \(error)")
                }
            }
    }
}
