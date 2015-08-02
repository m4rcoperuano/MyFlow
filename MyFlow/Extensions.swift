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
    class func weatherApiKey() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(InfoPList.WeatherAPIKey.rawValue) as! String;
    }
    
    class func weatherApiUrl() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(InfoPList.WeatherAPIURL.rawValue) as! String;
    }
}

extension UIAlertController {
    class func showError(#errorTitle: String, errorMessage: String, inViewController: UIViewController) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            inViewController.dismissViewControllerAnimated(true, completion: nil);
        }));

        inViewController.presentViewController(alertController, animated: true, completion: nil);
    }
}
