//
//  HospitalModel.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/23/24.
//

import Foundation

struct Hospital: Codable {
    let name: String
    let latitude: CGFloat
    let longitude: CGFloat
    let phone: String
    let website: URL
    
//    enum CodingKeys: String, CodingKey {
//        case hospitalName = "name"
//        case hospitalLatitude = "latitude"
//        case hospitalLongitude = "longitude"
//        case hospitalPhone = "phone"
//        case hospitalWebsite = "website"
//    }
}

struct HospitalList: Codable {
    let hospitals: [Hospital]
}

