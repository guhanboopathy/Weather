//
//  weatherModel.swift
//  weather
//
//  Created by Guhan on 03/05/21.
//

import Foundation

struct WeatherModel {
    let conditionId : Int
    let citiName : String
    let temperature : Double
    
    var temperatureStrig : String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName : String {
        switch conditionId {
        case 200...232:
            return K.boltWeather
        case 300...321:
            return K.cloudBrizzle
        case 500...531:
            return K.cloudRain
        case 600...622:
            return K.cloudSnow
        case 701...781:
            return K.cloudFog
        case 800:
            return K.sunMax
        case 801...804:
            return K.boltWeather
        default:
            return K.cloud
        }
    }  
}
