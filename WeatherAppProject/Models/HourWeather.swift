//
//  HourWeather.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation
import UIKit


// Create Data Model for 24-hours Forecasr

struct HourWeather: Codable {
    var hourly: Hourly
}

struct Hourly: Codable {
    var icon: String
    var summary: String
    var data: [HourlyWeather]
}

struct HourlyWeather: Codable {
    var time: Int?
    var summary: String?
    var icon: String?
    var temperature: Double?
    var windSpeed: Double?
    var windBearing: Int?
}
