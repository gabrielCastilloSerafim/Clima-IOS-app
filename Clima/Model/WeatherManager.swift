//
//  WeatherMannager.swift
//  Clima
//
//  Created by Gabriel Castillo Serafim on 26/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//Created this protocol to be able to implement the delegate pattern and make sure that the file that is going to be the delegate to this file has the functions that we are going to be calling on the delegate.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError (error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b52d0571fc3ed4260b95508c821da3e1&units=metric"
    
    //We created this variable after implementing a delegate pattern to pass the processed data that we got from  the request to another file and what this variable does is that it is used to set the other file as the delegate for this file, it adopts the protocol data type because the file that is going to be the delegate must conform to the protocol that we created.
    var delegate: WeatherManagerDelegate?
    
    //Gets triggered in the WhetherViewController when done editing, gets the city  name as a parameter, adds it to the weatherURL variable and stores the string in the urlString variable and then calls the performRequest method below using the urlString as a parameter.
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    //Gets triggered in the WhetherViewController when the location button is pressed and creates the url using the latitude and longitude parameters to call the perform request method.
    func fetchWeather(longitude:CLLocationDegrees, latitude:CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        
        //1. Create a URL var and set it to a type URL String and because this type is an optional we first have to check if the value is not nil before assigning it to the variable and proceeding.
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession and assign it to a session variable.
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task by accessing its dataTask method using dot notation, this dataTask method required a function as input with the specified parameters to handle what will happen when the data gets fetched, it is written in form of a closure, this closure is a completion handler since it runs in the background and can take time to complete waiting for the API data.
            let task = session.dataTask(with: url) { data, response, error in
                
                //First we check if there was an error in the process
                if error != nil  {
                    //Sends the error report to the delegate.
                    delegate?.didFailWithError(error: error!)
                    //The return without nothing after it scapes the function and the functions code below it does not get executed
                    return
                }
                
                //Handles the data response, first does an optional binding to check if the data is not nil and then equals the data to a variable called safeData.
                if let safeData = data {
                    
                    //Calls the parseJSON function with our safeData that we got from the request and since the parseJSON function decodes our data and returns an object with the decoded data information we stored it in a weather object that has a WeatherModel? optional type and must be unwrapped.
                    if let weather = parseJSON(safeData) {
                        
                        //Since we adopted a delegate pattern to pass the weather object that contains the our processed info to other files, the line below says that whatever the delegate is call the didUpdateWeather function that will receive the weather object that we are passing.
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Ends the task that we created above.
            task.resume()
        }
    }
    
    
    
    //This function decodes the JSON data that we got from our request "safeData" by first "informing" the compiler how to get to the data inside the JSON file by using the "WeatherData" struct file that we crated and then returns the weather object that we created.
    func parseJSON(_ weatherData:Data) -> WeatherModel? {
        //Created a decoder object that can decode data
        let decoder  = JSONDecoder()
        //Used "do, try, catch" because the decode method can throw an error and all the methods that can throw an error need to have this "do, try, catch" structure
        do {                             //decode method requires a datatype and a data to decode
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //Since we created the decodedData object and it has a WeatherData type we can now access its properties with dot notation.
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            //To organise the code we created a weather model that has the variables for the data and a computed variable that has the value for an icon name that represents the id number, below we initialised an object with the weather model data type called weather.
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch {
            //Sends the error report to the delegate.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
