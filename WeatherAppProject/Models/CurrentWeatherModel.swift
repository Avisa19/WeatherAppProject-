//
//  CurrentWeather.swift
//  WeatherAppProject
//
//  Created by Avisa on 3/12/18.
//  Copyright © 2018 Avisa. All rights reserved.
//

import Foundation
import UIKit



struct CurrentWeatherModel {
    let summary: String
    let icon: String
    let temperature: Double
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String: Any)
    }
    
    init(json: [String: Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    
    
    
    static let basePath = "https://api.darksky.net/forecast/aa9333328d8aaa465a132b80cb8692a0/"
    
    static func forecast (withLocation location: String, completion: @escaping ([CurrentWeatherModel]) -> ()) {

        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            var forecastArray: [CurrentWeatherModel] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let dailyForecasts = json["daily"] as? [String: Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String: Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? CurrentWeatherModel(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
    
}
