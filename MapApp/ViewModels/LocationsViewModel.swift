//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Tharusha Lakshan on 9/23/24.
//

import Foundation
import MapKit
import SwiftUI


class LocationsViewModel: ObservableObject {
    
    //All loaded locations
    @Published var locations: [Location]
    
    //Current location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    //current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //show list of locations
    @Published var showLocationsList: Bool = false
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion (
                center: location.coordinates,
                span: mapSpan)
        }
    }
    
    
    func toggleLocationsLiat(){
        withAnimation(.easeInOut){
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location:Location){
        withAnimation(.easeInOut){
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed(){
        //Get the current index
//        let currentIndex = locations.firstIndex { location in
//        return location == mapLocation}
        
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else{
            print("could not find current index in locations array! Should never happen.")
            return
        }
        
        //check of the nextIndex is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            //Next index is Not valid
            // Restart from 0
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return
        }
        
        //Next index is valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
