//
//  ProtocolFactory.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/19/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit

class ProtocolFactory: NSObject {
    class func WeatherProtocol() -> GetWeatherProtocol {
        return GetWeatherService();
    }
    
    class func UserLocationProtocol() -> GetUserLocationProtocol {
        return GetUserLocationService();
    }
}
