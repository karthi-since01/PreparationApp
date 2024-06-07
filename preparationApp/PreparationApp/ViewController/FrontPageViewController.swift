//
//  FrontPageViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import UIKit

class FrontPageViewController: UIViewController {
    
    var searchButtonBottomConstraint: NSLayoutConstraint?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pinCodeTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Your PinCode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.textAlignment = .center
        textField.textColor = .black
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        let searchImage = UIImage(systemName: "magnifyingglass")
        button.setBackgroundImage(searchImage, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var searchPinCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search Pin Code", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Next Page", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
        return button
    }()
    
    var postOfficeData: [PostOffice] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        
        setUpConstraints()
        keyPadSetup()
    }
    
    // MARK: - Keypad setup
    func keyPadSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Constraints SetUp
    func setUpConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(pinCodeTextField)
        containerView.addSubview(searchButton)
        containerView.addSubview(listTableView)
        containerView.addSubview(nextButton)
        containerView.addSubview(activityIndicator)
        containerView.addSubview(searchPinCodeButton)
        
        activityIndicator.centerX == containerView.centerX
        activityIndicator.centerY == containerView.centerY
        
        searchButtonBottomConstraint = searchPinCodeButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10)
        searchButtonBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            pinCodeTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pinCodeTextField.trailingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            pinCodeTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            pinCodeTextField.heightAnchor.constraint(equalToConstant: 30),
            
            searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            
            listTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            listTableView.topAnchor.constraint(equalTo: pinCodeTextField.bottomAnchor),
            listTableView.bottomAnchor.constraint(equalTo: searchPinCodeButton.topAnchor, constant: -10),
            
            searchPinCodeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            searchPinCodeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            searchPinCodeButton.heightAnchor.constraint(equalToConstant: 30),
            searchPinCodeButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10),
            
            nextButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Button Actions
    @objc func goToNextPage() {
        let vc = PostMethodViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButtonTapped() {
        
        view.endEditing(true)
        
        postOfficeData.removeAll()
        listTableView.reloadData()
        activityIndicator.startAnimating()
        let pinCode = pinCodeTextField.text
        
        guard pinCode?.count == 6 else {
            showAlert(withTitle: "Error", message: "Enter a valid pin code")
            self.activityIndicator.stopAnimating()
            return
        }
        
        let url = "https://api.postalpincode.in/pincode/\(pinCode ?? "")"
        
        GenericAPI.getRequest(url: url) { (result: Result<[PostOfficeResponse], Error>) in
            
            switch result {
            case .success(let response):
                if let postOffices = response.first?.postOffices {
                    self.postOfficeData = postOffices
                    self.listTableView.reloadData()
                }
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print("Failed to fetch data: \(error)")
                self.showAlert(withTitle: "Try Again", message: "\n\(error)")
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - KeyPad Buttons
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        searchButtonBottomConstraint?.constant = -keyboardHeight + 40
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        searchButtonBottomConstraint?.constant = -10
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension FrontPageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 6
    }
}

// MARK: - UITableViewDataSource
extension FrontPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postOfficeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        let postData = postOfficeData[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(postData.name)\n\nDescription: \(postData.description ?? "---")\nBranch Type: \(postData.branchType)\nDelivery Status: \(postData.deliveryStatus)\nCircle: \(postData.circle)\nDistrict: \(postData.district)\nDivision: \(postData.division)\nRegion: \(postData.region)\nState: \(postData.state)\nCountry: \(postData.country)"
        return cell
    }
}
