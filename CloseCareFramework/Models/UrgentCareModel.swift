//
//  UrgentCareModel.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/23/24.
//

import Foundation

struct UrgentCare: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let phone: String
    let website: URL
    
//    enum CodingKeys: String, CodingKey {
//        case urgentCareName = "name"
//        case urgentCareLatitude = "latitude"
//        case urgentCareLongitude = "longitude"
//        case urgentCarePhone = "phone"
//        case urgentCareWebsite = "website"
//    }
}

struct UrgentCareList: Codable {
    let urgentCares: [UrgentCare]
}


