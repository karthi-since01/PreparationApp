//
//  SignInSignUpViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/11/24.
//

import UIKit
import FirebaseAuth

class SignInSignUpViewController: UIViewController {
    
    var currentUser: User = Auth.auth().currentUser!
    
    lazy var signInScreen = SignInScreen()
    lazy var signUpScreen = SignUpScreen()
    
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
            print("sighin submit button tapped")
            self?.signInTap()
        }
        
        signUpScreen.signUpSubmitButtonAction = { [weak self] in
            print("sigh up submit button tapped")
            self?.signUpTap()
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
        signUpScreen.height == .ratioWidthBasedOniPhoneX(300)
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
              let confirmPassword = signUpScreen.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(withTitle: "Error", message: "All Fields are Mandatory!!!")
            return
        }
        
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error creating user: \(error.localizedDescription)")
                    self.showAlert(withTitle: "Error", message: error.localizedDescription)
                } else if let user = authResult?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating display name: \(error.localizedDescription)")
                            self.showAlert(withTitle: "Error", message: error.localizedDescription)
                        } else {
                            print("Display name updated successfully")
                        }
                    }
                    print("User created with UID: \(user.uid)")
                    self.signInScreen.isHidden = false
                    self.signUpScreen.isHidden = true
                    
                    self.signUpScreen.nameTextField.text = ""
                    self.signUpScreen.emailTextField.text = ""
                    self.signUpScreen.passwordTextField.text = ""
                    self.signUpScreen.confirmPasswordTextField.text = ""
                    
                    self.showAlert(withTitle: "Success", message: "User created successfully !!!")

                    
//                    let vc = FrontPageViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
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
            } else {
                print("User signed in successfully")
                let vc = FrontPageViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
