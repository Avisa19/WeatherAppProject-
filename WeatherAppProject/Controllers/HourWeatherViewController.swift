//
//  HourWeatherViewController.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import Foundation

import UIKit

class HourWeatherViewController: UIViewController {
    
    //MARK:- Interface Builder
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var windDirectLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    //MARK:- Properties
    var fetchedweather = HourlyWeather()
    var selectedCityId: Int?
    var cityBank = CityBank()
    var highTemp = 0.0
    var lowTemp = 0.0
    var isFavourite = false
    var isOpenFromFavourite: Bool?
    var settingsDic: [String: Any]?
    
    //MARK:- View Contoller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteButton.isHidden = true
        self.selectedCityId = UserDefaults.standard.integer(forKey: "SelectedCityIndex")
        
        do {
            let settings = try GeneralSettings.loadPropertyList()
            if settings["isFavouritedAny"] != nil {
                let forecastId = settings["ForecastId"] as! Int
                let cityId = settings["CityId"] as! Int
                if isOpenFromFavourite == true {
                    let cityId = settings["CityId"] as! Int
                    self.selectedCityId = cityId
                    self.styleFavouriteButton()
                } else {
                    if cityId == self.selectedCityId! && forecastId == 1 {
                        self.selectedCityId = cityId
                        self.styleFavouriteButton()
                    } else  {
                        self.styleUnFavouriteButton()
                    }
                }
                
                
            } else {
                self.styleUnFavouriteButton()
            }
        } catch {
            print(error)
        }
        
        
        self.fetchHourlyWeatherFromServer()
    }
    
    //fetch the weather from the server
    func fetchHourlyWeatherFromServer() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkServices.fetchHourlyWeather(latitude: self.cityBank.lists[selectedCityId!].latitude, longitude:  self.cityBank.lists[selectedCityId!].longitude, completion: { (result) in
            switch result {
            case .success(let weather):
                self.favouriteButton.isHidden = false
                self.fetchedweather = weather.hourly.data[0]
                self.highTemp = weather.hourly.data[0].temperature!
                self.lowTemp = weather.hourly.data[0].temperature!
                for onehourData in weather.hourly.data {
                    
                    if onehourData.temperature! > self.highTemp {
                        self.highTemp = onehourData.temperature!
                    }
                    
                    if onehourData.temperature! < self.lowTemp {
                        self.lowTemp = onehourData.temperature!
                    }
                }
                self.cityNameLabel.text = self.cityBank.lists[self.selectedCityId!].cityName
                
                if let time = self.fetchedweather.time {
                    self.timeLabel.text = getStringDate(timeStamp: TimeInterval(time))
                }
                
                self.highTemperatureLabel.text = "High: \(Int(self.highTemp))°C"
                self.lowTemperatureLabel.text = "Low: \(Int(self.lowTemp))°C"
                self.weatherTypeLabel.text = "\(weather.hourly.summary)"
                
                if let direction = self.fetchedweather.windBearing {
                    self.windDirectLabel.text = "Wind Direction: \(Int(direction))°"
                }
                
                if let speed = self.fetchedweather.windSpeed {
                    self.windSpeedLabel.text = "Wind Speed: \(Int(speed))km/h"
                }
                
                self.weatherTypeImageView.image = UIImage(named: weather.hourly.icon)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(_):
                print("Something went wrong!")
            }
        })
    }
    //MARK:  ***********Style favourite Button***********
    func styleFavouriteButton() {
        UIView.animate(withDuration: 1.5)
        {
        self.favouriteButton.backgroundColor = UIColor.blue
        self.favouriteButton.setTitleColor(.white, for: .normal)
        self.favouriteButton.setTitle("Unfavourite", for: .normal)
        self.isFavourite = true
        }
    }
    
    func styleUnFavouriteButton() {
        UIView.animate(withDuration: 1.5)
        {
        self.favouriteButton.backgroundColor = UIColor.white
        self.favouriteButton.setTitleColor(.blue, for: .normal)
        self.favouriteButton.setTitle("Favourite", for: .normal)
        self.isFavourite = false
        }
    }
}
/**************************************************************/
//MARK:- Button Actions
extension HourWeatherViewController {
    @IBAction func favouriteButtonPressed() {
        if self.isFavourite == false {
            self.styleFavouriteButton()
            do {
                var dictionary = try GeneralSettings.loadPropertyList()
                dictionary.updateValue(true, forKey: "isFavouritedAny")
                dictionary.updateValue(1, forKey: "ForecastId")
                dictionary.updateValue(self.selectedCityId, forKey: "CityId")
                
                try GeneralSettings.savePropertyList(dictionary)
            } catch {
                print(error)
            }
        } else if self.isFavourite == true {
            do {
                var dictionary = try GeneralSettings.loadPropertyList()
                dictionary.updateValue(false, forKey: "isFavouritedAny")
                dictionary.updateValue(-1, forKey: "ForecastId")
                dictionary.updateValue(-1, forKey: "CityId")
                try GeneralSettings.savePropertyList(dictionary)
            } catch {
                print(error)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

