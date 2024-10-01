//
//  MainView.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/21/24.
//

import SwiftUI
import MapKit

struct MainView: View {
    
    @Environment(LocationManager.self) var locationManager
    @State private var urgentCares: [UrgentCare] = []
    @State private var hospitals: [Hospital] = []
    @State private var scaleSize: Bool = false
    @State private var showSheet: Bool = false
    @State private var textFieldText: String = ""
    @State private var selectedPlacemark: String?
    @State private var MKMapItemPlacemark: MKMapItem?
    
    @State private var getDirections: Bool = false
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    @State private var placeType: String?
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    //        .userLocation(fallback: .automatic)
    var body: some View {
        ZStack {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation()
            
            ForEach(urgentCares, id: \.name) { urgentCare in
                Marker(
                    coordinate: CLLocationCoordinate2D(
                        latitude: urgentCare.latitude,
                        longitude: urgentCare.longitude
                    )
                ) {
                    Text(urgentCare.name)
                    Image(systemName: "bandage.fill")
                }
                .tint(Color.purple)
                .tag(selectedPlacemark)
            }
            
            
            ForEach(hospitals, id: \.name) { hospital in
                Marker(
                    coordinate: CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude)) {
                        Text(hospital.name)
                        Image(systemName: "cross.fill")
                    }
                    .tint(Color.red)
                    .tag(hospital.name)
            }
            if let route {
                MapPolyline(route.polyline)
                    .stroke(placeType == "Urgent Care" ? .purple : .red, lineWidth: 6)
            }
        }
        .onChange(of: selectedPlacemark, { oldValue, newValue in
            if let selectedPlacemark = selectedPlacemark {
                MKMapItemPlacemark = fetchMKMapItem(selectedPlacemark: selectedPlacemark)
                //                print("placeType: \(placeType)")
                print("selectedPlacemark: \(selectedPlacemark) -> MKMapItem")
            }
            showSheet = newValue != nil
            route = nil
            getDirections = false
        })
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
            }
        })
        .sheet(isPresented: $showSheet, content: {
            SheetDetailView(showSheet: $showSheet, urgentCares: $urgentCares, hospitals: $hospitals, getDirections: $getDirections, placeType: $placeType, MKMapItemPlacemark: $MKMapItemPlacemark)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .onAppear{
            loadUrgentCares()
            loadHospitals()
            //            print(hospitals)
            //            print(urgentCares)
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
        }
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "location.magnifyingglass")
//                        .foregroundStyle(.blue)
                        .font(.title)
                        .padding(.leading, 3)
                    TextField("Search...", text: $textFieldText)
                        .font(.title)
                    Image(systemName: "person.fill")
                        .font(.title)
                        .padding(.trailing, 12)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.08)
                .background(.white)
                .cornerRadius(20)
                .padding()
            }
    }
}
}
#Preview {
    MainView()
        .environment(LocationManager())
}


extension MainView {
    
    private func loadUrgentCares()  {
        if let data = readLocalJSONFile(forName: "UCData") {
            if let urgentCareList: UrgentCareList = decodeJSON(from: data, as: UrgentCareList.self) {
                urgentCares = urgentCareList.urgentCares
//                print(urgentCares)
                
            } else {
                print("Failed to decode urgent care data")
            }
        } else {
            print("Failed to read JSON file")
        }
    }
    
    private func loadHospitals() {
        if let data = readLocalJSONFile(forName: "HospitalsData") {
            if let hospitalsList: HospitalList = decodeJSON(from: data, as: HospitalList.self) {
                hospitals = hospitalsList.hospitals
//                print(hospitals)
                
            } else {
                print("Failed to decode urgent care data")
            }
        } else {
            print("Failed to read JSON file")
        }
    }
    
    func determinePlaceType(for placemarkName: String) -> String? {
        if urgentCares.contains(where: { $0.name == placemarkName }) {
            placeType = "Urgent Care"
            return placeType
//            return "Urgent Care"
        } else if hospitals.contains(where: { $0.name == placemarkName }) {
            placeType = "Hospital"
            return placeType
//            return "Hospital"
        }
        print("Placemark is not found")
        return nil
    }

    func fetchMKMapItem(selectedPlacemark: String) -> MKMapItem? {
       if let placeType = determinePlaceType(for: selectedPlacemark) {
           if placeType == "Urgent Care" {
               if let urgentCare = urgentCares.first(where: { $0.name == selectedPlacemark }) {
                   let coordinate = CLLocationCoordinate2D(latitude: urgentCare.latitude, longitude: urgentCare.longitude)
                   let mkPlacemark = MKPlacemark(coordinate: coordinate)
                   let mapItem = MKMapItem(placemark: mkPlacemark)
                   mapItem.name = urgentCare.name
                   print("Urgent Care found: \(urgentCare.name)")
                   return mapItem
           }
           } else if placeType == "Hospital" {
               if let hospital = hospitals.first(where: { $0.name == selectedPlacemark }) {
                   let coordinate = CLLocationCoordinate2D(latitude: hospital.latitude, longitude: hospital.longitude)
                   let mkPlacemark = MKPlacemark(coordinate: coordinate)
                   let mapItem = MKMapItem(placemark: mkPlacemark)
                   mapItem.name = hospital.name
                   print("Hospital found: \(hospital.name)")
                   return mapItem
               }
           }
       }
       print("Placemark not found in either list")
       return nil
   }

    func fetchRoute() {
        if let MKMapItemPlacemark {
            let request = MKDirections.Request()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = MKMapItemPlacemark
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = MKMapItemPlacemark
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showSheet = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}

/*
 Testing out new commit
 */
