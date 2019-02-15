//
//  LocationBank.swift
//  WeatherAppProject
//
//  Created by Avisa on 7/1/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation



  // Creating a location items and appending it to the list

class CityBank {
    
    var lists = [Location]()
   
    init() {
        lists.append(Location(cityName: "New York", latitude: "40.7128", longitude: "74.0060"))
        lists.append(Location(cityName: "Chicago", latitude: "41.8781", longitude: "87.6298"))
        lists.append(Location(cityName: "Plano", latitude: "33.0198", longitude: "96.6989"))
        lists.append(Location(cityName: "Boston", latitude: "42.3601", longitude: "71.0589"))
        lists.append(Location(cityName: "Baltimore", latitude: "39.2904", longitude: "76.6122"))
        lists.append(Location(cityName: "Washington", latitude: "38.9072", longitude: "77.0369"))
        lists.append(Location(cityName: "Ankeny", latitude: "41.7318", longitude: "93.6001"))
        lists.append(Location(cityName: "Boone", latitude: "42.0597", longitude: "93.8802"))
        lists.append(Location(cityName: "Urbandale", latitude: "41.6267", longitude: "93.7122"))
        lists.append(Location(cityName: "Phoenix", latitude: "33.4484", longitude: "112.0704"))
        lists.append(Location(cityName: "Denver", latitude: "39.7392", longitude: "104.9903"))
        lists.append(Location(cityName: "Pittsburgh", latitude: "40.4406", longitude: "79.9959"))
        lists.append(Location(cityName: "Ames", latitude: "42.0308", longitude: "93.6319"))
        lists.append(Location(cityName: "Houston", latitude: "29.7604", longitude: "95.3698"))
        lists.append(Location(cityName: "Austin", latitude: "30.2672", longitude: "97.7431"))
        lists.append(Location(cityName: "Dallas", latitude: "32.7767", longitude: "96.7970"))
        lists.append(Location(cityName: "San Antonio", latitude: "29.4241", longitude: "98.4936"))
        lists.append(Location(cityName: "Seattle", latitude: "47.6062", longitude: "122.3321"))
        lists.append(Location(cityName: "Vancouver", latitude: "49.2827", longitude: "123.1207"))
        lists.append(Location(cityName: "Iowa City", latitude: "41.6611", longitude: "91.5302"))
    }
}
