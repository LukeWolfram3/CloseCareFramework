//
//  FullScreenCoverView.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 10/2/24.
//

import SwiftUI
import MapKit

struct FullScreenCoverView: View {
    
    @Binding var showSheet: Bool
    @Binding var selectedDetent: PresentationDetent
    @Binding var urgentCares: [UrgentCare]
    @Binding var hospitals: [Hospital]
    @Binding var getDirections: Bool
    @Binding var placeType: String?
    @State private var lookAroundScene: MKLookAroundScene?
    
    @Binding var MKMapItemPlacemark: MKMapItem?
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(MKMapItemPlacemark?.name ?? "Unable to find name")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Spacer()
                    Button {
                        selectedDetent = .fraction(0.42)
                        MKMapItemPlacemark = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.gray, Color(.systemGray6))
                    }
                }
                
                if let scene = lookAroundScene {
                    LookAroundPreview(initialScene: scene)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding()
                } else {
                    ContentUnavailableView("No preview available", systemImage: "eye.slash")
                }
                
                HStack(spacing: 24) {
                    
                    Button {
                        getDirections = true
                        //                    print("placeType in sheet: \(placeType)")
                    } label: {
                        Text("Get directions")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 170, height: 48)
                            .background(placeType == "Urgent Care" ? Color.purple : Color.red)
                            .cornerRadius(12)
                    }
                    Button {
                        if let MKMapItemPlacemark {
                            MKMapItemPlacemark.openInMaps()
                        }
                    } label: {
                        Text("Open in maps")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 170, height: 48)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                }
            }
            
            .padding()
        }
        //        .background(.windowBackground)
    }
}
    

    #Preview {
        SheetDetailView(showSheet: .constant(false), selectedDetent: .constant(.medium), urgentCares: .constant([UrgentCare(name: "Test Urgent Care", latitude: 37.7749, longitude: -122.4194, phone: "919-6969-6969", website: URL(string: "https://fasttrackurgentcare.com")!)]), hospitals: .constant([Hospital(name: "Test Hospital", latitude: 37.7749, longitude: 122.4194, phone: "696-6969-6969", website: URL(string: "https://testhospital.com")!)]), getDirections: .constant(false), placeType: .constant("Urgent Care"), MKMapItemPlacemark: .constant(nil))
    }
