//
//  Helper.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
