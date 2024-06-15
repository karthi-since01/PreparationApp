//
//  Helper.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import Foundation
import UIKit
import FirebaseStorage

extension UIViewController {
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessAlert(withTitle title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (URL?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let uniqueImageName = "images/\(UUID().uuidString).jpg"
        let imagesRef = storageRef.child(uniqueImageName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imagesRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            
            imagesRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "No error description")")
                    completion(nil)
                    return
                }
                
                completion(downloadURL)
            }
        }
    }
}
