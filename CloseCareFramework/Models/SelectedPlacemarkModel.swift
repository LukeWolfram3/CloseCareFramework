//
//  SelectedPlacemarkModel.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/27/24.
//

import Foundation
import MapKit

struct SelectedPlacemark: Hashable {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}
