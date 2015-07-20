//
//  Constants.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/13/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation

enum StoryBoardID : String {
    case Weather = "WeatherVC"
    case SideBar = "SideBarVC"
}

enum ImageNames : String {
    case SidebarBackground = "Sidebar Background"
    case SidebarWeatherIcon = "Sidebar Weather Icon"
}

enum InfoPList : String {
    case WeatherAPIKey = "Weather API Key"
    case WeatherAPIURL = "Weather API URL"
}

enum NibNames : String {
    case WeatherCurrentTemp = "WeatherCurrentTemp"
}

enum NotificationNames : String {
    case WeatherInformationReceived = "WeatherInformationReceived"
}

enum StatusCodes : Int {
    case Success = 200
    case Error = 500
}