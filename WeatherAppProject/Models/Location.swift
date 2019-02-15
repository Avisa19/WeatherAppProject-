//
//  ListOfLocations.swift
//  WeatherAppProject
//
//  Created by Avisa on 23/11/18.
//  Copyright © 2018 Avisa. All rights reserved.
//

import Foundation
import UIKit

// Creating Data Model for list of locations.
class Location {
    var cityName : String
    var latitude: String
    var longitude: String
    
    init(cityName: String, latitude: String, longitude: String) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
