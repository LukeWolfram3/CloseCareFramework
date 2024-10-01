//
//  TestGPTMapControlsView.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 10/1/24.
//

import SwiftUI
import MapKit

struct TestGPTMapControlsView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Your map view
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
            
            // Custom map controls positioned in the bottom left corner
            VStack {
                Spacer() // Pushes the controls to the bottom
                HStack {
                    VStack {
                        MapUserLocationButton()
                        MapCompass()
                        MapPitchToggle()
                    }
                    Spacer() // Pushes content to the left
                }
                .padding()
            }
        }
    }
}

#Preview {
    TestGPTMapControlsView()
}
