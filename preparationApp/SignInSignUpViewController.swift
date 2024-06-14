//
//  SignInSignUpViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInSignUpViewController: UIViewController {

    lazy var signInScreen = SignInScreen()
    lazy var signUpScreen = SignUpScreen()
    
    var convertedImageURL: String = ""
    
    lazy var switchViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(switchViewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray4
        
        self.signUpScreen.isHidden = true
        switchViewButton.setTitle("don't have an account? SignUp", for: .normal)
        
        setUpUI()
        
        signInScreen.signInSubmitButtonAction = { [weak self] in
            print("sign in submit button tapped")
            self?.signInTap()
        }
        
        signUpScreen.signUpSubmitButtonAction = { [weak self] in
            print("sign up submit button tapped")
            self?.signUpTap()
        }
        
        signUpScreen.profileImageButtonAction = { [weak self] in
            print("Gallery button tapped")
            self?.profileButtonTap()
        }
    }
    
    func setUpUI() {
        view.addSubviews(with: [signInScreen, signUpScreen, switchViewButton])
        
        signInScreen.centerX == view.centerX
        signInScreen.centerY == view.centerY
        signInScreen.height == .ratioWidthBasedOniPhoneX(300)
        signInScreen.width == .ratioWidthBasedOniPhoneX(300)
        
        signUpScreen.centerX == view.centerX
        signUpScreen.centerY == view.centerY
        signUpScreen.height == .ratioWidthBasedOniPhoneX(400)
        signUpScreen.width == .ratioWidthBasedOniPhoneX(300)
        
        switchViewButton.bottom == view.bottom - .ratioHeightBasedOniPhoneX(5)
        switchViewButton.leading == view.leading + .ratioHeightBasedOniPhoneX(5)
        switchViewButton.trailing == view.trailing + .ratioHeightBasedOniPhoneX(-5)
        switchViewButton.height == .ratioWidthBasedOniPhoneX(30)
    }
    
    @objc func switchViewButtonTapped() {
        if signInScreen.isHidden {
            signInScreen.isHidden = false
            signUpScreen.isHidden = true
            switchViewButton.setTitle("don't have an account? SignUp", for: .normal)
        } else {
            signInScreen.isHidden = true
            signUpScreen.isHidden = false
            switchViewButton.setTitle("already having account? signIn", for: .normal)
        }
    }
    
    func signUpTap() {
        guard let email = signUpScreen.emailTextField.text, !email.isEmpty,
              let password = signUpScreen.passwordTextField.text, !password.isEmpty,
              let name = signUpScreen.nameTextField.text, !name.isEmpty,
              let profileImage = signUpScreen.profileImageView.image,
              let confirmPassword = signUpScreen.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(withTitle: "Error", message: "All Fields are Mandatory!!!")
            return
        }
        
        if password == confirmPassword {
            
            self.uploadImageToFirebaseStorage(image: profileImage) { downloadURL in
                guard let downloadURL = downloadURL else {
                    print("Error uploading profile image to Firebase Storage")
                    self.showAlert(withTitle: "Error", message: "Failed to upload profile image")
                    return
                }
                
                self.convertedImageURL = downloadURL.absoluteString
                print(":::: STEP 1 \(self.convertedImageURL)")
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error creating user: \(error.localizedDescription)")
                        self.showAlert(withTitle: "Error", message: error.localizedDescription)
                    } else if let user = authResult?.user {
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = name
                        changeRequest.photoURL = URL(string: self.convertedImageURL)
                        changeRequest.commitChanges { error in
                            if let error = error {
                                print("Error updating display name: \(error.localizedDescription)")
                                self.showAlert(withTitle: "Error", message: error.localizedDescription)
                            } else {
                                print("Display name updated successfully")
                            }
                        }
                        print(":::: STEP 2 \(self.convertedImageURL)")
                        print("User created with UID: \(user.uid)")
                        
                        let db = Firestore.firestore()
                        db.collection("userList").document(user.uid).setData([
                            "uid": user.uid,
                            "displayName": name,
                            "email": email,
                            "profileImageURL": self.convertedImageURL
                        ]) { error in
                            if let error = error {
                                print("Error adding user to Firestore: \(error.localizedDescription)")
                            } else {
                                print("User added to Firestore successfully")
                            }
                        }
                        
                        print(":::: STEP 3 \(self.convertedImageURL)")
                        
                        self.signInScreen.isHidden = false
                        self.signUpScreen.isHidden = true
                        
                        self.signUpScreen.nameTextField.text = ""
                        self.signUpScreen.emailTextField.text = ""
                        self.signUpScreen.passwordTextField.text = ""
                        self.signUpScreen.confirmPasswordTextField.text = ""
                        
                        self.showAlert(withTitle: "Success", message: "User created successfully !!!")
                    }
                }
            }
        } else {
            showAlert(withTitle: "Error", message: "Passwords don't match")
        }
    }
    
    func signInTap() {
        
        guard let email = signInScreen.emailTextField.text, !email.isEmpty,
              let password = signInScreen.passwordTextField.text, !password.isEmpty else {
            showAlert(withTitle: "Error", message: "All Fields are Mandatory!!!")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.showAlert(withTitle: "Error", message: error.localizedDescription)
            } else if let user = authResult?.user {
                print("User signed in successfully")
                print(user.displayName ?? "No display name --- ")
                print(user.uid)
                let vc = ChatListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func profileButtonTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension SignInSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            signUpScreen.profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
