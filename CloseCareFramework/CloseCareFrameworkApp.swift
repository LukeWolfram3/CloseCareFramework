//
//  CloseCareFrameworkApp.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/21/24.
//

import SwiftUI

@main
struct CloseCareFrameworkApp: App {
    
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                MainView()
            } else {
                Text("Need to help user")
            }
        }
        .environment(locationManager)
    }
}

/*
 Phase 1
 The current goal of this app is to allow users to see wait times, phone numbers, and website URLs for the closest hospitals and urgent cares
 Current needs:
 1) Create a mapview that tracks the user location ✅
 2) Use an api to download all the urgent cares and hospitals in the United States
 3) Calculate and display the map around those closest 3 hospitals and urgent cares
 4) Give step by step directions on how to get to each of those locations
 
 //OBJECTIVES FOR THIS WEEK:
// Get the app tracking the user location, updating, and showing which direction you are facing (last part need to do)
//Put down placemarkers for fake JSON data for hosptials and urgent cares, make them different ✅
 //Feature a popover when a location is selected on with wait time, distance, and ETA from car, website URL, phone with the option to call, the option to get directions, and hte option to open in maps

 
 
 Phase 2
 The second part which will be like a platform for doctors and patients to connect to each other
 */
