//
//  LocationsView.swift
//  MapApp
//
//  Created by Tharusha Lakshan on 9/23/24.
//

import SwiftUI
import MapKit


struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700
//    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//    
    var body: some View {
        ZStack{
            mapLayer
                .ignoresSafeArea()
            
            VStack(spacing: 0){
               header
                .padding()
                .frame(maxWidth: maxWidthForIpad)
                Spacer()
               locationsPreviewStack
            }
            
        }
        
        .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
    }
}


extension LocationsView{
    
    private var header: some View{
        VStack {
            Button(action: vm.toggleLocationsLiat){
                Text(vm.mapLocation.name + "," + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading){
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
                
            }
            if vm.showLocationsList{
                LocationsListView()
            }
            
            
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
    }
    
    private var mapLayer: some View{
        
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: {location in
            MapAnnotation(coordinate: location.coordinates){
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1
                                 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
//                MapMarker(coordinate: location.coordinates, tint: .blue)
        })
    }
    
    private var locationsPreviewStack: some View{
        ZStack{
            ForEach(vm.locations){ location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3),radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }
               
            }
        }
    }
}



#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
        
}



