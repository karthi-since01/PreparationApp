//
//  ChatListTableViewCell.swift
//  preparationApp
//
//  Created by AIT MAC on 6/12/24.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    lazy var userProfileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle.fill")
        image.layer.cornerRadius = .ratioHeightBasedOniPhoneX(25)
        image.clipsToBounds = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "User Name"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "Last Message"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setUpUI()
    }
    
    func setUpUI() {
        addSubviews(with: [userProfileImage, nameLabel, lastMessageLabel])
        
        userProfileImage.centerY == centerY
        userProfileImage.height == .ratioHeightBasedOniPhoneX(50)
        userProfileImage.width == .ratioHeightBasedOniPhoneX(50)
        userProfileImage.leading == leading + .ratioHeightBasedOniPhoneX(5)
        
        nameLabel.leading == userProfileImage.trailing + .ratioHeightBasedOniPhoneX(20)
        nameLabel.trailing == trailing + .ratioHeightBasedOniPhoneX(-10)
        nameLabel.top == top + .ratioHeightBasedOniPhoneX(10)
        
        lastMessageLabel.leading == userProfileImage.trailing + .ratioHeightBasedOniPhoneX(20)
        lastMessageLabel.trailing == trailing + .ratioHeightBasedOniPhoneX(-10)
        lastMessageLabel.bottom == bottom - .ratioHeightBasedOniPhoneX(10)
        
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }

}
