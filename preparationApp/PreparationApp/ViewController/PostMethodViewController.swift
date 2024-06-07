//
//  PostMethodViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import UIKit
import Alamofire

class PostMethodViewController: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Your Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.textColor = .black
        return textField
    }()
    
    lazy var jobTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Your Job Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.textColor = .black
        return textField
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        swipeBack()
        setUpConstraints()
    }
    
    
    func swipeBack() {
        let swipeLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleswipeLeft(_:)))
        swipeLeft.edges = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    func setUpConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(nameTextField)
        containerView.addSubview(jobTextField)
        containerView.addSubview(nextButton)
        
        containerView.leading   == view.leading + .ratioHeightBasedOniPhoneX(10)
        containerView.trailing  == view.trailing + .ratioHeightBasedOniPhoneX(-10)
        containerView.top       == view.top + .ratioHeightBasedOniPhoneX(50)
        containerView.bottom    == view.bottom + .ratioHeightBasedOniPhoneX(-10)
        
        nameTextField.leading   == containerView.leading + .ratioHeightBasedOniPhoneX(20)
        nameTextField.trailing  == containerView.trailing + .ratioHeightBasedOniPhoneX(-20)
        nameTextField.top       == containerView.top + .ratioHeightBasedOniPhoneX(25)
        nameTextField.height    == .ratioHeightBasedOniPhoneX(30)
        
        jobTextField.leading    == containerView.leading + .ratioHeightBasedOniPhoneX(20)
        jobTextField.trailing   == containerView.trailing + .ratioHeightBasedOniPhoneX(-20)
        jobTextField.top        == nameTextField.bottom + .ratioHeightBasedOniPhoneX(25)
        jobTextField.height     == .ratioHeightBasedOniPhoneX(30)
        
        nextButton.centerX      == containerView.centerX
        nextButton.height       == .ratioHeightBasedOniPhoneX(50)
        nextButton.width        == .ratioWidthBasedOniPhoneX(100)
        nextButton.top          == jobTextField.bottom + .ratioHeightBasedOniPhoneX(50)

    }
    
    @objc func handleswipeLeft(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func submitButtonTapped() {
        view.endEditing(true)
        
        let userName = nameTextField.text ?? ""
        let jobName = jobTextField.text ?? ""
        
        if userName.isEmpty || jobName.isEmpty {
            self.showAlert(withTitle: "Error", message: "All Fields are Manditory !")
        }
        
        let url = "https://reqres.in/api/users"
        
        let params = [
            "name": userName,
            "job": jobName
        ]
        
        GenericAPI.postRequest(url: url, parameters: params) { (result: Result<PostAPIModel, Error>) in
            switch result {
            case .success(let success):
                print(success)
                self.showAlert(withTitle: "Success", message: "You registered Job Successfully !!!")
            case .failure(let error):
                print(error)
                self.showAlert(withTitle: "Error", message: "Failed to register job. Please try again later.")
            }
        }
    }
}
