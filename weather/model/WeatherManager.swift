//
//  weatherManager.swift
//  weather
//
//  Created by 1418972 on 19/03/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=411217a95ad71a25e19bfa09fb308e06&units=metric"
    
    func createWeatherURl(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        handleURL(with: urlString)
    }
    
    func createWeatherURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        handleURL(with: urlString)
    }
    func handleURL(with URLString: String) {
        if let url = URL(string: URLString) {
            let Session = URLSession(configuration: .default)
            let task = Session.dataTask(with: url) { (data, response, error ) in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJson(safeData) {
                        delegate?.didUpdateWeather(self, weather)
                        
                        
                    }
                }
            }
            task.resume()
        }
    }
    func parseJson(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let condionId = decodeData.weather[0].id
            let cityName = decodeData.name
            let temperature = decodeData.main.temp
            
            let weather = WeatherModel(conditionId: condionId, citiName: cityName, temperature: temperature)
            
            return weather
            
        }catch {
            delegate?.didFailWithError(error)
        }
        return nil
    }
}
