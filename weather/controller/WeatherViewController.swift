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
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var celsius: UILabel!
    let locationManager = CLLocationManager()
    
    var weathermanager = WeatherManager()
    override func viewDidLoad() {
        weathermanager.delegate = self
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func currentLocationBtnTapped(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        let alertView = UIAlertController(title: K.alert.error, message: error.localizedDescription, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: K.alert.OKTitle, style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weathermanager.createWeatherURL(latitude: lat, longitude: lon)
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // searchTextField.endEditing(true)
        if searchTextField.text == nil || searchTextField.text == ""{
            let alertView = UIAlertController(title: "", message: K.alert.cityMessage, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title:K.alert.OKTitle, style: .default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }else {
            searchTextField.endEditing(true)
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            return true
        }else {
            textField.placeholder = K.searchPlaceHolder
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weathermanager.createWeatherURL(cityName: city)
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title:K.alert.error, message: error.localizedDescription, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: K.alert.OKTitle, style: .default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func didUpdateWeather(_ weathermanager: WeatherManager, _ weather: WeatherModel) {
        print(weather)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureStrig
            self.cityLabel.text = weather.citiName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.celsius.text = "C"
            self.degreeLabel.text = "°"
        }
    }  
}
