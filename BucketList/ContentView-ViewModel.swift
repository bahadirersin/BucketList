//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Bahadır Ersin on 9.03.2023.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView{
    @MainActor class ViewModel:ObservableObject{
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.504, longitude: -0.11), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            }catch{
                locations = []
            }
        }
        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options:[.atomic,.completeFileProtection])
            }catch{
                print("Unable to save data.")
            }
        }
        
        func addLocation(){
            let newLocation = Location(name: "New Location", description: "Interesting Point", longitude: mapRegion.center.longitude, latitude: mapRegion.center.latitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location:Location){
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                save()
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error:NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "We need to identify you to show details."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                    if success{
                        Task{ @MainActor in
                            self.isUnlocked = true                        }
                    }else{
                        
                    }                }
            }else{
                
            }
        }
    }
}

