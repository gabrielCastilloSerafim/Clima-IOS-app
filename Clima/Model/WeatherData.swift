//
//  WeatherData.swift
//  Clima
//
//  Created by Gabriel Castillo Serafim on 29/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


//We have to make sure that our struct conforms to the Decodable protocol.
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp:Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
