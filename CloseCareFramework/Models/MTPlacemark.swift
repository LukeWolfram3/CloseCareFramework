//
//  MTPlacemarker.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/23/24.
//

import Foundation
import MapKit
import SwiftUI

class MTPlacemark {
    var name: String
    var latitude: Double
    var longitude: Double

    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
