//
//  SideBarMenuOptions.swift
//  MyFlow
//
//  Created by Marco Ledesma on 8/1/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit

enum MenuTitles : String {
    case Weather = "Weather"
    case Toggle = "Toggl"
}

class SideBarMenuOptions : NSObject
{
    let menuTitle : MenuTitles;
    let menuIconName : String;
    let menuVCID : String;
    
    init(menuTitle: MenuTitles)
    {
        self.menuTitle = menuTitle;
        
        var menuIconName : String?;
        switch (menuTitle)
        {
        case MenuTitles.Weather:
            menuIconName = ImageNames.SidebarWeatherIcon.rawValue;
            menuVCID = "WeatherVC";
        case MenuTitles.Toggle:
            menuIconName = ImageNames.SidebarTogglIcon.rawValue;
            menuVCID = "TogglVC";
        default:
            menuIconName = ImageNames.SidebarWeatherIcon.rawValue;
        }
        
        self.menuIconName = menuIconName!;
    }
}