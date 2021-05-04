//
//  ViewController.swift
//  weather
//
//  Created by Guhan on 18/03/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    let location = CLLocationManager()
    
    var weathermanager = WeatherManager()
    override func viewDidLoad() {
        weathermanager.delegate = self
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func currentLocationBtnTapped(_ sender: Any) {
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.requestLocation()
        
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weathermanager.createWeatherURL(latitude: lat, longitude: lon)
        }
    }
    
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            return true
        }else {
            textField.placeholder = "Type City name"
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weathermanager.createWeatherURl(cityName: city)
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weathermanager: WeatherManager, _ weather: WeatherModel) {
        print(weather)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureStrig
            self.cityLabel.text = weather.citiName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
}
