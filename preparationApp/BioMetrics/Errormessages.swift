//
//  Errormessages.swift
//  preparationApp
//
//  Created by Achu Anil's MacBook Pro on 06/06/24.
//

import Foundation
import LocalAuthentication

let kBiometryNotAvailableReason = "Biometric authentication is not available for this device."

// MARK: - Touch ID

let kTouchIdAuthenticationReason = "Confirm your fingerprint to authenticate."
let kTouchIdPasscodeAuthenticationReason = "Touch ID is locked now, because of too many failed attempts. Enter passcode to unlock Touch ID."

// MARK: - Error Messages Touch ID

let kSetPasscodeToUseTouchID = "Please set device passcode to use Touch ID for authentication."
let kNoFingerprintEnrolled = "There are no fingerprints enrolled in the device. Please go to Device Settings -> Touch ID & Passcode and enroll your fingerprints."
let kDefaultTouchIDAuthenticationFailedReason = "Touch ID does not recognize your fingerprint. Please try again with your enrolled fingerprint."

// MARK: - Face ID

let kFaceIdAuthenticationReason = "Confirm your face to authenticate."
let kFaceIdPasscodeAuthenticationReason = "Face ID is locked now, because of too many failed attempts. Enter passcode to unlock Face ID."

// MARK: - Error Messages Face ID

let kSetPasscodeToUseFaceID = "Please set device passcode to use Face ID for authentication."
let kNoFaceIdentityEnrolled = "There is no face enrolled in the device. Please go to Device Settings -> Face ID & Passcode and enroll your face."
let kDefaultFaceIDAuthenticationFailedReason = "Face ID does not recognize your face. Please try again with your enrolled face."
