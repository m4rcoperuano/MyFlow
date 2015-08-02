//
//  GetWeatherService.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation

//Designed to work with Wunderground
class GetWeatherService : NSObject, GetWeatherProtocol {
    let weatherAPIURL = NSBundle.weatherApiUrl();
    let weatherAPIKey = NSBundle.weatherApiKey();
    var completeBlock : ((GetWeatherResult) -> Void)?;
    
    func execute(#lat: Double, lon: Double, completeBlock: ((GetWeatherResult) -> Void)!) {
        self.completeBlock = completeBlock;
        
        var fullQueryUrl = "\(weatherAPIURL)\(weatherAPIKey)/conditions/q/\(lat),\(lon).json";
        NSLog("Querying URL \(fullQueryUrl)");
        
        var session = NSURLSession.sharedSession();
        var request = NSURLRequest(URL: NSURL(string: fullQueryUrl)!);
        
        session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) -> Void in
                var result = GetWeatherResult();
                
                if (error == nil)
                {
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary;
                    
                    if let observableData : NSDictionary = json["current_observation"] as? NSDictionary {
                        
                        if let locationData = observableData["display_location"] as? NSDictionary {
                            result.city = locationData["city"] as? String;
                            result.state = locationData["state"] as? String;
                            result.zip = locationData["zip"] as? String;
                            result.tempInF = observableData.objectForKey("temp_f") as? Float;
                            result.feelsLikeTempInF = (observableData.objectForKey("feelslike_f") as? NSString)?.floatValue;
                            result.weather = self.getNormalizedWeatherName(weather:observableData.objectForKey("weather") as? String);
                            
                            var possibleIcon = observableData.objectForKey("icon") as? String;
                            if let icon = possibleIcon {
                                let trueIconStr = "http://icons-ak.wxug.com/i/c/h/\(icon).gif";
                                result.icon = trueIconStr;
                            }
                            
                            
                            result.nowCast = observableData.objectForKey("nowcast") as? String;
                            result.humidity = observableData.objectForKey("relative_humidity") as? String;
                            
                            self.success(weatherResult: result);
                        }
                        else {
                            self.error(nil);
                        }
                        
                    }
                    else
                    {
                        self.error(nil);
                    }
                    
                }
                else
                {
                    self.error(error);
                }
        }).resume();
    }
    
    func getNormalizedWeatherName(#weather: String?) -> String?
    {
        if let w = weather {
            var normalizedWeather = w;
            
            if (w.rangeOfString("Cloud") != nil || w.rangeOfString("Overcast") != nil) {
                normalizedWeather = "Partly Cloudy";
            }
            
            if (w.rangeOfString("Rain") != nil || w.rangeOfString("Drizzle") != nil) {
                normalizedWeather = "Rain";
            }
            
            if (w.rangeOfString("Thunder") != nil) {
                normalizedWeather = "Thunderstorm";
            }
            
            return normalizedWeather;
        }
        else {
            return weather;
        }
    }
    
    func getCachedData() -> GetWeatherResult? {
        return getResultFromUserDefaults();
    }
    
    func clearCache() {
        var userDefaults = NSUserDefaults.standardUserDefaults();
        userDefaults.removeObjectForKey("WeatherResultDateSet");
        userDefaults.synchronize();
    }
 
    private func error(error: NSError?)
    {
        var result = GetWeatherResult();
        result.statusCode = StatusCodes.Success;
        
        if (error != nil) {
            result.message = "\(error)";
        }
        else {
            result.message = "An unknown error has occurred";
        }
        
        if let block = completeBlock {
            block(result);
        }
    }
    
   
    private func success(#weatherResult: GetWeatherResult)
    {
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(.CalendarUnitHour, fromDate: date);
        let hour = components.hour;
        
        //store in nsuserdefaults for easy retreival later
        var userDefaults = NSUserDefaults.standardUserDefaults();
        userDefaults.setObject(weatherResult.city, forKey: "WeatherResultCity");
        userDefaults.setObject(weatherResult.state, forKey: "WeatherResultState");
        userDefaults.setObject(weatherResult.zip, forKey: "WeatherResultZip");
        userDefaults.setObject(weatherResult.weather, forKey: "WeatherWeather");
        userDefaults.setObject(weatherResult.tempInF, forKey: "WeatherResultTempInF");
        userDefaults.setObject(weatherResult.feelsLikeTempInF, forKey: "WeatherResultFeelsLikeTempInF");
        userDefaults.setObject(weatherResult.nowCast, forKey: "WeatherResultNowCast");
        userDefaults.setObject(weatherResult.humidity, forKey: "WeatherResultHumidity");
        userDefaults.setObject(weatherResult.icon, forKey: "WeatherResultIcon");
        userDefaults.setObject(NSDate(), forKey: "WeatherResultDateSet");
        
        if (hour > 19) //Night time, hard coded for now (7pm)
        {
            userDefaults.setBool(true, forKey: "WeatherIsNightTime");
            weatherResult.isNightTime = true;
        }
        else
        {
            userDefaults.setBool(false, forKey: "WeatherIsNightTime");
            weatherResult.isNightTime = false;
        }
        
        userDefaults.synchronize();
        
        if let block = completeBlock {
            block(weatherResult);
        }
    }
    
    private func getResultFromUserDefaults() -> GetWeatherResult?
    {
        var userDefaults = NSUserDefaults.standardUserDefaults();
        var result = GetWeatherResult();
        if (userDefaults.objectForKey("WeatherResultDateSet") != nil) {
//            var date = userDefaults.objectForKey("WeatherResultDateSet") as! NSDate;
//            var rightNow = NSDate();
//            
//            let timeInterval = rightNow.timeIntervalSinceDate(date);
//            let minutes = timeInterval / 60.0;
//            if (minutes > 5) { //5 minute cache
//                return nil;
//            }
            
        } else {
            return nil;
        }
        
        result.city = userDefaults.objectForKey("WeatherResultCity") as? String;
        result.state = userDefaults.objectForKey("WeatherResultState") as? String;
        result.zip = userDefaults.objectForKey("WeatherResultZip") as? String;
        result.tempInF = userDefaults.objectForKey("WeatherResultTempInF") as? Float;
        result.weather = userDefaults.objectForKey("WeatherWeather") as? String;
        result.isNightTime = userDefaults.boolForKey("WeatherIsNightTime");
        result.nowCast = userDefaults.objectForKey("WeatherResultNowCast") as? String;
        result.feelsLikeTempInF = userDefaults.objectForKey("WeatherResultFeelsLikeTempInF") as? Float;
        result.lastUpdated = userDefaults.objectForKey("WeatherResultDateSet") as? NSDate;
        result.humidity = userDefaults.objectForKey("WeatherResultHumidity") as? String;
        result.icon = userDefaults.objectForKey("WeatherResultIcon") as? String;
        
        return result;
    }
}