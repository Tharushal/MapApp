//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Tharusha Lakshan on 9/23/24.
//

import Foundation



class LocationsViewModel: ObservableObject {
    
    @Published var locations: [Location]
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
    }
}
