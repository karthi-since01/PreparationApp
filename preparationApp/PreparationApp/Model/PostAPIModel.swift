//
//  PostAPIModel.swift
//  preparationApp
//
//  Created by AIT MAC on 6/6/24.
//

import Foundation

// MARK: - PostAPIModelElement
struct PostOfficeResponse: Codable {
    let message: String
    let status: String
    let postOffices: [PostOffice]

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case postOffices = "PostOffice"
    }
}

// MARK: - PostOffice
struct PostOffice: Codable {
    let name: String
    let description: String?
    let branchType: String
    let deliveryStatus: String
    let circle: String
    let district: String
    let division: String
    let region: String
    let block: String
    let state: String
    let country: String
    let pincode: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Description"
        case branchType = "BranchType"
        case deliveryStatus = "DeliveryStatus"
        case circle = "Circle"
        case district = "District"
        case division = "Division"
        case region = "Region"
        case block = "Block"
        case state = "State"
        case country = "Country"
        case pincode = "Pincode"
    }
}

// MARK: - PostAPIModel
struct PostAPIModel: Codable {
    let name, job, id, createdAt: String
}
