//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//Imported CoreLocation to access gps data
import CoreLocation

//API Key = b52d0571fc3ed4260b95508c821da3e1

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Specify that the "CLLocationManager" delegate should report back to our class "WeatherViewController", have to do it before asking for location otherwise app will crash.
        locationManager.delegate = self
        //Ask users permission to use current location when login in, "Privacy - Location When In Use Usage Description" Plist file with the warning text was also created.
        locationManager.requestWhenInUseAuthorization()
        //Will get users location when app opens
        locationManager.requestLocation()
        
        
        //Specify that the "searchTextField" delegate should report back to our class "WeatherViewController".
        searchTextField.delegate = self
        
        //Sets the weatherManager "delegate"  var property to be equal to this class, "self"
        weatherManager.delegate = self
    }
    
    //Location button triggers "didUpdateLocations" by calling "requestLocation"
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
}



//MARK: - UITextFieldDelegate

//Added extension to the WeatherViewController class that conforms to the UITextfieldDelegate protocol meaning that by default the WeatherViewController class has all the functionality inside this extension, the extension groups all the functionality related to the UITextFieldDelegate.
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        //Set text field to end editing (and dismisses keyboard)
        searchTextField.endEditing(true)
        
    }
    
    //When the user presses the return button this function is triggered and it is basically asking if it should allow the return to be processed or not when the button is pressed in this case since we set the return value to true it will allow the button to be used
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Set text field to end editing (and dismisses keyboard)
        searchTextField.endEditing(true)
        
        return true
    }
    
    //Since we set the text field to end editing when the return or search buttons are pressed what will happen is that end editing will ask for this function if the editing can be ended or not and here we make a validation of the users input to see if it can be ended or not.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //When we don't specify witch text field are we referring to the method applies for all text fields.
        if textField.text != "" {
            //Allow return
            return true
        } else {
            //If the text input is blank sets the textField placeholder text to "Type something"
            textField.placeholder = "Type something"
            //Denny return
            return false
        }
    }
    
    //This function gets triggered when the text field editing gets indeed ended (it passed our validation condition above).
    func textFieldDidEndEditing(_ textField: UITextField) {
        //This checks if the text field String? optional type is nil and if its not assigns the string value to the city variable and then pass this data to the weatherManager.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        //Sets the text field to blank and placeholder back to search in case it got changed.
        searchTextField.text = ""
        searchTextField.placeholder = "Search"
    }
    
}



//MARK: - WeatherManagerDelegate

//Added extension to the WeatherViewController that conforms to the WeatherManagerDelegate protocol and all the code related to the WeatherManagerDelegate now is grouped in this extension.
extension WeatherViewController: WeatherManagerDelegate {
    
    //Function that conforms to the protocol that we created and will receive the object weather with all the processed information, getting this data depends on a completion handler running on a background thread that is responsible for making the API request thats why we have to wrap our code on the "DispatchQueue.main.async" to pass it to the main thread that is responsible for dealing with the user interface when it gets executed.
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    
    //Function that conforms to the our protocol and is responsible for receiving the errors that may occur when networking in the weather manager.
    func didFailWithError(error: Error) {
        print(error)
    }
    
}



//MARK: - CLLocationManagerDelegate

//Added extension to the WeatherViewController that conforms to the CLLocationManagerDelegate protocol and all the code related to the CLLocationManagerDelegate now is grouped in this extension.
extension WeatherViewController: CLLocationManagerDelegate {
    
    //Receives the location that we got when launching the app by calling ".requestLocation()"
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Inside this closure we access the "locations" array's last value to get the coordinates and store it in variables that we can use.
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            //Calls the function to fetch the data and display it.
            weatherManager.fetchWeather(longitude: lon, latitude: lat)
        }
    }
    
    //Must implement this "didFailWithError" in order to get location because it tells what to do in case of error.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
