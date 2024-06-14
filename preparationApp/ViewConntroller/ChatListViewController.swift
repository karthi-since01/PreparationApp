//
//  ChatListViewController.swift
//  preparationApp
//
//  Created by AIT MAC on 6/12/24.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class ChatListViewController: UIViewController {
    
    var users: [User] = []
    
    lazy var headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        return label
    }()
    
    lazy var chatListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: "chatCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = .orange
        
        if let currentUser = Auth.auth().currentUser {
            headingLabel.text = "\(currentUser.displayName ?? "Unknown") - Chat List"
            print(":::: currentUser.photoURL - \(String(describing: currentUser.photoURL))")
        }
        
        setUpUI()
        getUsersFromFireBaseAuth()
    }
    
    func setUpUI() {
        view.addSubviews(with: [headingLabel, chatListTableView])
        
        headingLabel.top == view.safeAreaLayoutGuide.topAnchor + .ratioHeightBasedOniPhoneX(5)
        headingLabel.height == .ratioHeightBasedOniPhoneX(30)
        headingLabel.centerX == view.centerX
        
        chatListTableView.top == headingLabel.bottom + .ratioHeightBasedOniPhoneX(15)
        chatListTableView.leading == view.leading
        chatListTableView.trailing == view.trailing
        chatListTableView.bottom == view.bottom
    }
    
    func getUsersFromFireBaseAuth() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: current user not found")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("userList").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                self.users = querySnapshot?.documents.compactMap({ document -> User? in
                    let data = document.data()
                    guard let uid = data["uid"] as? String,
                          let displayName = data["displayName"] as? String,
                          let email = data["email"] as? String,
                          let image = data["profileImageURL"] as? String
                    else {
                        return nil
                    }
                    return User(uid: uid, displayName: displayName, email: email, profileImageURL: image)
                }).filter { $0.uid != currentUserID } ?? []
                
                DispatchQueue.main.async {
                    self.chatListTableView.reloadData()
                }
            }
        }
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatListTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.displayName
        cell.lastMessageLabel.text = user.uid
        
        cell.userProfileImage.image = UIImage(systemName: "person.circle")
        
        if let imageUrl = URL(string: user.profileImageURL) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let currentCell = tableView.cellForRow(at: indexPath) as? ChatListTableViewCell {
                            currentCell.userProfileImage.image = image
                        }
                    }
                }
            }.resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let chatViewController = ChatViewController()
        chatViewController.user2Name = user.displayName
        chatViewController.user2UID = user.uid
        chatViewController.user2ImgUrl = user.profileImageURL
        
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}
