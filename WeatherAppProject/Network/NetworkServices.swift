//
//  File.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

// Network service for fetching Data.

class NetworkServices {
    static func fetchCurrentWeather(latitude: String, longitude: String, completion: ((Result<CurrentWeather>) -> Void)?) {

        let url = URL(string: "https://api.darksky.net/forecast/d9e7b36f935bf89802fceea8b2bd4c1b/\(latitude),\(longitude)?exclude=daily,minutely,hourly,flags")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion?(.failure(error))
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(CurrentWeather.self, from: jsonData)
                        completion?(.success(weather))
                    } catch {
                        print(error)
                        completion?(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    static func fetchHourlyWeather(latitude: String, longitude: String, completion: ((Result<HourWeather>) -> Void)?) {
        
        let url = URL(string: "https://api.darksky.net/forecast/d9e7b36f935bf89802fceea8b2bd4c1b/\(latitude),\(longitude)?exclude=flags,currently,daily,minutely")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion?(.failure(error))
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(HourWeather.self, from: jsonData)
                        completion?(.success(weather))
                    } catch {
                        print(error)
                        completion?(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    static func fetch7DayWeather(latitude: String, longitude: String, completion: ((Result<DayWeather>) -> Void)?) {
        
        let url = URL(string: "https://api.darksky.net/forecast/d9e7b36f935bf89802fceea8b2bd4c1b/\(latitude),\(longitude)?exclude=flags,currently,hourly")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            DispatchQueue.main.async {
                if let error = responseError {
                    completion?(.failure(error))
                } else if let jsonData = responseData {
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(DayWeather.self, from: jsonData)
                        completion?(.success(weather))
                    } catch {
                        print(error)
                        completion?(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                    completion?(.failure(error))
                }
            }
        }
        task.resume()
    }
}

