//
//  GetUserLocation.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation
import CoreLocation

class GetUserLocationService: NSObject, GetUserLocationProtocol, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager();
    private var usersLocation : CLLocation?;
    private var completeBlock : ((GetWeatherResult!) -> Void)?;
    
    
    func execute(#completeBlock: ((GetWeatherResult!) -> Void)!)
    {
        manager.delegate = self;
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization();
        } else {
            manager.startUpdatingLocation();
        }
        
        self.completeBlock = completeBlock;
    }
    
    
    //MARK: CLLocationManager delegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedAlways {
            manager.startUpdatingLocation();
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        for location in locations as! [CLLocation] {
            usersLocation = location;
            if usersLocation?.horizontalAccuracy <= 100 {
                manager.stopUpdatingLocation();
                executeCompleteBlockSuccess();
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        executeCompleteBlockErrorWithMessage("Failed getting location");
    }
    
    //MARK: Private methods
    private func executeCompleteBlockSuccess() {
        var result = GetWeatherResult();
        self.completeBlock!(result);
    }
    
    private func executeCompleteBlockErrorWithMessage(message : String)
    {
        var result = GetWeatherResult();
        result.statusCode = StatusCodes.Error;
        result.message = message;
        
        self.completeBlock!(result);
    }
}
