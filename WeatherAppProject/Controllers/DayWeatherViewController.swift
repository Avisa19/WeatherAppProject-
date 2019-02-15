//
//  DayWeatherViewController.swift
//  WeatherAppProject
//
//  Created by Avisa Poshtkouhi on 10/01/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit

class DayWeatherViewController: UIViewController {

    //MARK:- Interface Builder
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var dayTableView: UITableView!
    
    //MARK:- Properties
    var fetchedweather = [DailyWeather]()
    var selectedCityId: Int?
    var cityBank = CityBank()
    var isFavourite = false
    var isOpenFromFavourite: Bool?
    var settingsDic: [String: Any]?
    
    //MARK:- View Contoller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteButton.isHidden = true
        self.dayTableView.isHidden = true
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
                    if cityId == self.selectedCityId! && forecastId == 2 {
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
        
        self.fetchDayWeatherFromServer()
    }
    
    //fetch the weathers from the server
    func fetchDayWeatherFromServer() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkServices.fetch7DayWeather(latitude: self.cityBank.lists[selectedCityId!].latitude, longitude:  self.cityBank.lists[selectedCityId!].longitude, completion: { (result) in
            switch result {
            case .success(let weather):
                self.dayTableView.isHidden = false
                self.favouriteButton.isHidden = false
                self.cityNameLabel.text = self.cityBank.lists[self.selectedCityId!].cityName
                self.fetchedweather = weather.daily.data
                self.fetchedweather.removeFirst()
                self.dayTableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(_):
                print("Something went wrong!")
            }
        })
    }
    //MARK: ********************Styling favourite Button ***************
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
/*********************************************************************/
//MARK:- Button Actions
extension DayWeatherViewController {
    @IBAction func favouriteButtonPressed() {
        if self.isFavourite == false {
            self.styleFavouriteButton()
            do {
                var dictionary = try GeneralSettings.loadPropertyList()
                dictionary.updateValue(true, forKey: "isFavouritedAny")
                dictionary.updateValue(2, forKey: "ForecastId")
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


//MARK:- Tableview DataSource and Delegate Methods
extension DayWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.fetchedweather.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell", for: indexPath) as! DayTableViewCell
        
        if let time = self.fetchedweather[indexPath.row].time {
            cell.timeLabel.text = getStringDate(timeStamp: TimeInterval(time))
        }
        
        if let temp = self.fetchedweather[indexPath.row].temperatureHigh {
            cell.highTemperatureLabel.text = "High: \(Int(temp))°C"
        }
        
        if let temp = self.fetchedweather[indexPath.row].temperatureLow {
            cell.lowTemperatureLabel.text = "Low: \(Int(temp))°C"
        }
        
        if let type = self.fetchedweather[indexPath.row].summary {
            cell.weatherTypeLabel.text = "\(type)"
        }
        
        if let direction = self.fetchedweather[indexPath.row].windBearing {
            cell.windDirectLabel.text = "Wind Direction: \(Int(direction))°"
        }
        
        if let speed = self.fetchedweather[indexPath.row].windSpeed {
            cell.windSpeedLabel.text = "Wind Speed: \(Int(speed))km/hr"
        }
        
        if let icon = self.fetchedweather[indexPath.row].icon {
            cell.weatherTypeImageView.image = UIImage(named: icon)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235.0
    }
    
}
