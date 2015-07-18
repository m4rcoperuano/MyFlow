//
//  GetWeatherService.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation

class GetWeatherService : NSObject, GetWeatherProtocol {
    func execute(lat: Float, lon: Float) -> GetWeatherResult {
        let result = GetWeatherResult();
        result.temperature = 50.0;
        
        return result;
    }
}