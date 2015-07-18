//
//  Extensions.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/13/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
    }
    
    class func sidebarViewController() -> SideBarViewController {
        return UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(StoryBoardID.SideBar.rawValue) as! SideBarViewController;
    }
}

extension NSBundle {
    class func wepApiKey() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(InfoPList.WeatherAPIKey.rawValue) as! String;
    }
}