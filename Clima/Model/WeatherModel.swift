//
//  WeatherModel.swift
//  Clima
//
//  Created by Gabriel Castillo Serafim on 30/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    
    //This is a computed property, this mens that it has a value that depends on the execution of a code.
    var temperatureString:String {
        return String(format: "%.1f", temperature)
    }
    
    
    //This is a computed property, this mens that it has a value that depends on the execution of a code.
    var conditionName:String {
        
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
        
    }
    
    
    
    
    
}
