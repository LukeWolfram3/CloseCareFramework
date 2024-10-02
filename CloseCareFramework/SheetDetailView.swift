//
//  SheetDetailView.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/27/24.
//

import SwiftUI
import MapKit

// Change this sheet view so that it has search options and then make a fullcover screen that goes above the sheet for directions and information

struct SheetDetailView: View {
    
    @Binding var showSheet: Bool
    @Binding var selectedDetent: PresentationDetent
    @Binding var urgentCares: [UrgentCare]
    @Binding var hospitals: [Hospital]
    @Binding var getDirections: Bool
    @Binding var placeType: String?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var filteredUrgentCares: [UrgentCare] = []
    @State private var filteredHospitals: [Hospital] = []
    @Binding var MKMapItemPlacemark: MKMapItem?
    
    @State private var textFieldText: String = ""
//    @Binding var textFieldTapped: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var showFullScreenCover: Bool = false
    @State private var selectedUrgentCare: UrgentCare?
    @State private var selectedHospital: Hospital?
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: isTextFieldFocused ? "chevron.left" : "location.magnifyingglass")
                        .font(.title)
                        .padding(.leading, 7)
                        .padding(.trailing, 1)
                        .onTapGesture {
                                if isTextFieldFocused {
                                    textFieldText = ""
                                        isTextFieldFocused = false
                                } else {
                                        isTextFieldFocused = true
                                   selectedDetent = .fraction(0.42)
                                }
                        }
                    TextField(isTextFieldFocused ? "" : "Find hospitals and urgent cares", text: $textFieldText)
                        .onChange(of: textFieldText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                filterFacilities(searchText: newValue)
                            }
                        }
                    Spacer()
                    if !textFieldText.isEmpty {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .padding(.trailing, 8)
                            .onTapGesture {
                                textFieldText = ""
                            }
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: UIScreen.main.bounds.height * 0.05)
                .focused($isTextFieldFocused)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .onTapGesture {
                        selectedDetent = .fraction(0.42)
                }
                if isTextFieldFocused && !textFieldText.isEmpty {
                    listOfFacilities(filteredUrgentCares: $filteredUrgentCares, filteredHospitals: $filteredHospitals, showFullScreenCover: $showFullScreenCover, selectedUrgentCare: $selectedUrgentCare, selectedHospital: $selectedHospital)
                        .frame(maxWidth: 300, maxHeight: 350)
                }
                Spacer()
                
                    if MKMapItemPlacemark == nil && selectedDetent == .fraction(0.42) && isTextFieldFocused == false {
                        HStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: UIScreen.main.bounds.height * 0.15)
                                .foregroundStyle(.purple)
                                .shadow(color: .purple.opacity(0.7), radius: 20, x: 0, y: 50)
                                .padding(4)
                                .overlay(
                                    Text("Browse urgent care wait times")
                                        .multilineTextAlignment(.center)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .shadow(color: .black, radius: 3, x: 0, y: 2)
                                )

                            RoundedRectangle(cornerRadius: 15)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: UIScreen.main.bounds.height * 0.15)
                                .foregroundStyle(.red)
                                .shadow(color: .red.opacity(0.7), radius: 20, x: 0, y: 50)
                                .padding(4)
                                .overlay(
                                    Text("Browse hospital wait times")
                                        .multilineTextAlignment(.center)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .shadow(color: .black, radius: 3, x: 0, y: 2)
                                )
                    }
                }
                Spacer()
            }

            .padding()
            
        }
        .background(.ultraThinMaterial)
        .onChange(of: selectedDetent) { oldValue, newValue in
            if newValue == .fraction(0.08) {
                isTextFieldFocused = false
            }
        }
        //This is a sketchy way to show the full screen cover because we aren't supposed to use logic, consider using an item instead
//        .fullScreenCover(isPresented: $showFullScreenCover) {
//            if let urgentCare = selectedUrgentCare {
//                FullScreenCoverView(urgentCare: urgentCare)
//            } else if let hospital = selectedHospital {
//                FullScreenCoverView(hospital: hospital)
//            }
//        }
        }
    }

struct listOfFacilities: View {
    
    @Binding var filteredUrgentCares: [UrgentCare]
    @Binding var filteredHospitals: [Hospital]
    @Binding var showFullScreenCover: Bool
    @Binding var selectedUrgentCare: UrgentCare?
    @Binding var selectedHospital: Hospital?

    var body: some View {
            List {
                ForEach(filteredUrgentCares, id: \.name) { urgentCare in
                    HStack {
                        Image(systemName: "bandage")
                            .foregroundStyle(.purple)
                        Text(urgentCare.name)
                    }
                    .font(.headline)
                    .onTapGesture {
                        selectedUrgentCare = urgentCare
                        showFullScreenCover = true
                    }
                }
                ForEach(filteredHospitals, id: \.name) { hospital in
                    HStack {
                        Image(systemName: "cross.fill")
                            .foregroundStyle(.red)
                        Text(hospital.name)
                    }
                    .font(.headline)
                    .onTapGesture {
                        selectedHospital = hospital
                        showFullScreenCover = true
                    }
                }
            }
            .padding(.leading, 1)
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .listStyle(.plain)
    }
}



#Preview {
    SheetDetailView(showSheet: .constant(false), selectedDetent: .constant(.medium), urgentCares: .constant([UrgentCare(name: "Test Urgent Care", latitude: 37.7749, longitude: -122.4194, phone: "919-6969-6969", website: URL(string: "https://fasttrackurgentcare.com")!)]), hospitals: .constant([Hospital(name: "Test Hospital", latitude: 37.7749, longitude: 122.4194, phone: "696-6969-6969", website: URL(string: "https://testhospital.com")!)]), getDirections: .constant(false), placeType: .constant("Urgent Care"), MKMapItemPlacemark: .constant(nil))
}



extension SheetDetailView {
    func searchDatabase(searchItem: String) -> ([UrgentCare], [Hospital]){
        let foundUrgentCares = urgentCares.filter { $0.name.localizedStandardContains(searchItem)}
        let foundHospitals = hospitals.filter { $0.name.localizedStandardContains(searchItem)}
        
        return (foundUrgentCares, foundHospitals)
    }
    
    func filterFacilities(searchText: String) {
        let (foundUrgentCares, foundHospitals) = searchDatabase(searchItem: searchText)
        filteredUrgentCares = foundUrgentCares
        filteredHospitals = foundHospitals
    }
}
