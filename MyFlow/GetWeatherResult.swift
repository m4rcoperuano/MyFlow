//
//  GetWeatherResult.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation

class GetWeatherResult : ResultBase {
    var city : String?;
    var state : String?;
    var zip : String?;
    var tempInF : Float?;
    var weather : String?;
    var isNightTime = false;
    var lastUpdated : NSDate?;
    var feelsLikeTempInF : Float?;
    var nowCast : String?;
    var humidity : String?;
    var icon : String?;
}