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
        var fullQueryUrl = "\(weatherAPIURL)\(weatherAPIKey)/geolookup/q/\(lat),\(lon).json";
        NSLog("Querying URL \(fullQueryUrl)");
        
        var session = NSURLSession.sharedSession();
        var request = NSURLRequest(URL: NSURL(string: fullQueryUrl)!);
        
        self.completeBlock = completeBlock;
        
        session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) -> Void in
                var result = GetWeatherResult();
                
                if (error == nil)
                {
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary;
                    
                    if let locationData : NSDictionary = json["location"] as? NSDictionary {
                        result.city = locationData["city"] as? String;
                        result.state = locationData["state"] as? String;
                        result.zip = locationData["zip"] as? String;
                        
                        self.getWeatherInfo(weatherResult: result);
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
    
    //MARK: - Get location and weather info
    private func getWeatherInfo(#weatherResult: GetWeatherResult)
    {
        if (weatherResult.city == nil || weatherResult.state == nil)
        {
            error(nil);
            return;
        }
        
        var fullQueryUrl = "\(weatherAPIURL)\(weatherAPIKey)/conditions/q/\(weatherResult.state!)/\(weatherResult.city!).json";
        NSLog("Querying URL \(fullQueryUrl)");
        
        var session = NSURLSession.sharedSession();
        var request = NSURLRequest(URL: NSURL(string: fullQueryUrl)!);
        
        session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) -> Void in
                if (error == nil)
                {
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary;
                    
                    if let conditionData : NSDictionary = json["current_observation"] as? NSDictionary {
                        weatherResult.tempInF = (conditionData.objectForKey("feelslike_f") as? NSString)?.floatValue;
                        
                        self.success(weatherResult: weatherResult);
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
        if let block = completeBlock {
            block(weatherResult);
        }
    }
}