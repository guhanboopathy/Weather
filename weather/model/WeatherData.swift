//
//  weatherData.swift
//  weather
//
//  Created by Guhan on 03/05/21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main:Decodable {
    let temp:Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
