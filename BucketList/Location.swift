//
//  Location.swift
//  BucketList
//
//  Created by Bahadır Ersin on 8.03.2023.
//

import Foundation
import CoreLocation

struct Location:Identifiable,Equatable,Codable{
    
    var id:UUID
    var name:String
    var description:String
    let longitude:Double
    let latitude:Double
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", longitude: -0.141, latitude: 51.501)
    
    static func ==(lhs:Location,rhs:Location)->Bool{
        lhs.id == rhs.id
    }
    
    init(name: String, description: String, longitude:Double, latitude:Double) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
    }
}
