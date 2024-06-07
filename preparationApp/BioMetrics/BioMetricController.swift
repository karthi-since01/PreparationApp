//
//  BioMetricController.swift
//  preparationApp
//
//  Created by Achu Anil's MacBook Pro on 06/06/24.
//

import Foundation
import UIKit
import LocalAuthentication

open class BioMetricController: NSObject {
    
    static let shared = BioMetricController()
    var allowableReuseDuration: TimeInterval = 0
}

extension BioMetricController {
    
    /// checks if biometric authentication can be performed currently on the device.
    class func canAuthenticate() -> Bool {
        
        var isBiometricAuthenticationAvailable = false
        var error: NSError? = nil
        
        if LAContext().canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthentication,
            error: &error
        ) {
            isBiometricAuthenticationAvailable = (error == nil)
        }
        return isBiometricAuthenticationAvailable
    }
    
    /// Check for biometric authentication
    class func authenticateWithBioMetrics(
        reason: String,
        fallbackTitle: String? = "",
        cancelTitle: String? = "",
        completion: @escaping (Result<Bool, AuthenticationError>) -> Void
    ) {
        
        // reason
        let reasonString = reason.isEmpty
        ? BioMetricController.shared.defaultBiometricAuthenticationReason()
        : reason
        
        // context
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = BioMetricController.shared.allowableReuseDuration
        context.localizedFallbackTitle = fallbackTitle
        context.localizedCancelTitle = cancelTitle
        
        // authenticate
        BioMetricController.shared.evaluate(
            policy: .deviceOwnerAuthenticationWithBiometrics,
            with: context,
            reason: reasonString,
            completion: completion
        )
    }
    
    /// Check for device passcode authentication
    class func authenticateWithPasscode(
        reason: String,
        cancelTitle: String? = "",
        completion: @escaping (Result<Bool, AuthenticationError>) -> ()
    ) {
        
        // reason
        let reasonString = reason.isEmpty
        ? BioMetricController.shared.defaultPasscodeAuthenticationReason()
        : reason
        
        let context = LAContext()
        context.localizedCancelTitle = cancelTitle
        
        // authenticate
        BioMetricController.shared.evaluate(
            policy: .deviceOwnerAuthentication,
            with: context,
            reason: reasonString,
            completion: completion
        )
    }
    
    /// checks if device supports face id and authentication can be done
    func faceIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
        return canEvaluate && context.biometryType == .faceID
    }
    
    /// checks if device supports touch id and authentication can be done
    func touchIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
        return canEvaluate && context.biometryType == .touchID
    }
    
    /// checks if device has faceId
    /// this is added to identify if device has faceId or touchId
    /// note: this will not check if devices can perform biometric authentication
    func isFaceIdDevice() -> Bool {
        let context = LAContext()
        _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType == .faceID
    }
    
    func isTouchdDevice() -> Bool {
        let context = LAContext()
        _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType == .touchID
    }
    
}

extension BioMetricController {
    
    /// get authentication reason to show while authentication
    private func defaultBiometricAuthenticationReason() -> String {
        return faceIDAvailable() ? kFaceIdAuthenticationReason : kTouchIdAuthenticationReason
    }
    
    /// get passcode authentication reason to show while entering device passcode after multiple failed attempts.
    private func defaultPasscodeAuthenticationReason() -> String {
        return faceIDAvailable() ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
        
    }
    
    /// evaluate policy
    private func evaluate(
        policy: LAPolicy,
        with context: LAContext,
        reason: String,
        completion: @escaping (Result<Bool, AuthenticationError>) -> ()
    ) {
        context.evaluatePolicy(policy, localizedReason: reason) { (success, err) in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                }else {
                    let errorType = AuthenticationError.initWithError(err as! LAError)
                    completion(.failure(errorType))
                }
            }
        }
    }
}
