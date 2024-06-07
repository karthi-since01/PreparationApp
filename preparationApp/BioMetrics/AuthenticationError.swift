//
//  AuthenticationError.swift
//  preparationApp
//
//  Created by Achu Anil's MacBook Pro on 06/06/24.
//

import Foundation
import LocalAuthentication

// MARK: - Authentication Errors

enum AuthenticationError: Error {
    
    case failed,
         canceledByUser,
         fallback,
         canceledBySystem,
         passcodeNotSet,
         biometryNotAvailable,
         biometryNotEnrolled,
         biometryLockedout,
         other
    
    static func initWithError(_ error: LAError) -> AuthenticationError {
        switch Int32(error.errorCode) {
            
        case kLAErrorAuthenticationFailed:
            return failed
        case kLAErrorUserCancel:
            return canceledByUser
        case kLAErrorUserFallback:
            return fallback
        case kLAErrorSystemCancel:
            return canceledBySystem
        case kLAErrorPasscodeNotSet:
            return passcodeNotSet
        case kLAErrorBiometryNotAvailable:
            return biometryNotAvailable
        case kLAErrorBiometryNotEnrolled:
            return biometryNotEnrolled
        case kLAErrorBiometryLockout:
            return biometryLockedout
        default:
            return other
        }
    }
    
    // MARK: - get error message based on type
    
    func message() -> String {
        let isFaceIdDevice = BioMetricController.shared.isFaceIdDevice()
        
        switch self {
            
        case .passcodeNotSet:
            return isFaceIdDevice ? kSetPasscodeToUseFaceID : kSetPasscodeToUseTouchID
            
        case .biometryNotAvailable:
            return kBiometryNotAvailableReason
            
        case .biometryNotEnrolled:
            return isFaceIdDevice ? kNoFaceIdentityEnrolled : kNoFingerprintEnrolled
            
        case .biometryLockedout:
            return isFaceIdDevice ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
            
        default:
            return isFaceIdDevice ? kDefaultFaceIDAuthenticationFailedReason : kDefaultTouchIDAuthenticationFailedReason
        }
    }
}
