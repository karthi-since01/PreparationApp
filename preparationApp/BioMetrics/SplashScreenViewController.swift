//
//  SplashScreenViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/7/24.
//

import Foundation
import UIKit
import LocalAuthentication

/**
 `SplashScreenViewController` is responsible for handling biometric authentication.
 This view controller uses Face ID/Touch ID for authentication and provides appropriate
 fallbacks in case of authentication failure.
 */
class SplashScreenViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "aa")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewAndConstraint()
        authenticateWithBioMetrics()
    }
    
    func addViewAndConstraint(){
        view.addSubview(imageView)
        imageView.edges == view.edges
    }

    /// Attempts to authenticate the user using biometrics (Face ID/Touch ID)
    func authenticateWithBioMetrics() {
        BioMetricController.authenticateWithBioMetrics(reason: "") { (result) in
            switch result {
            case .success:
                print("authentication success")
                self.navigateToNextViewController()
            case .failure(let error):
                print("authentication failure: \(error)")
                switch error {
                case .biometryNotEnrolled:
                    self.showBiometricEnrollmentAlert()
                case .biometryNotAvailable, .failed:
                    self.authenticateWithPasscode()
                case .fallback, .other , .canceledByUser, .canceledBySystem:
                    self.showExitConfirmationAlert()
                case .passcodeNotSet:
                    self.showPasscodeNotSetAlert()
                default:
                    self.authenticateWithPasscode()
                }
            }
        }
    }
    
    /// Checks if both Touch ID and Face ID are not set
    func isBiometricNotSet() -> Bool {
        return !isTouchIdEnrolled() && !isFaceIdEnrolled()
    }
    
    /// Checks if either Touch ID or Face ID is enrolled
    func isBiometricEnrolled() -> Bool {
        return isTouchIdEnrolled() && isFaceIdEnrolled()
    }
    
    /// Checks if Touch ID is enrolled on the device
    func isTouchIdEnrolled() -> Bool {
        let context = LAContext()
        var error: NSError?
        let isTouchIdAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        return isTouchIdAvailable
    }
    
    /// Checks if Face ID is enrolled on the device
    func isFaceIdEnrolled() -> Bool {
        let context = LAContext()
        var error: NSError?
        let isFaceIdAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        return isFaceIdAvailable
    }
    
    /// Shows an alert prompting the user to set a device passcode
    func showPasscodeNotSetAlert() {
        let alertController = UIAlertController(
            title: "Passcode Not set/turned off",
            message: "To use passcode, you need to enroll your passcode in device settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.showExitConfirmationAlert()
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Shows an alert prompting the user to enroll in biometric authentication
    func showBiometricEnrollmentAlert() {
        let alertController = UIAlertController(
            title: "Biometric Not Enrolled",
            message: "To use biometric authentication, you need to enroll your biometric data in device settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {
            _ in self.showExitConfirmationAlert()
        }
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// Shows an alert indicating authentication failure and exits the app after 2 seconds
    func showExitConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Authentication Failure",
            message: "You dont have access for this application.",
            preferredStyle: .alert
        )
        
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                exit(0)
            }
        }
    }
    
    /// Attempts to authenticate the user using a passcode
    func authenticateWithPasscode() {
        BioMetricController.authenticateWithPasscode(reason: "") { (result) in
            switch result {
            case .success:
                print("Passcode authentication success")
                self.navigateToNextViewController()
            case .failure(let error):
                print("Passcode authentication failure: \(error)")
                self.authenticateWithPasscode()
            }
        }
    }
    
    /// Navigates to the next view controller upon successful authentication
    func navigateToNextViewController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(0.5))) {
            let viewcontroller = SignInSignUpViewController()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}
