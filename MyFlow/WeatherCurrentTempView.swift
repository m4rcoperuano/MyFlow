//
//  WeatherCurrentTempTableCell.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCurrentTempView: UIView {
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeather:", name: NotificationNames.WeatherInformationReceived.rawValue, object: nil);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clearColor();
        self.temperatureLabel.textColor = UIColor.whiteColor();
        self.containerView.backgroundColor = UIColor.clearColor();
    }
    
    
    //MARK: - NSNotification Implementations
    func updateWeather(notification: NSNotification)
    {
        if let weatherInfo = notification.object as? GetWeatherResult {
            if let tempF = weatherInfo.tempInF {
                let tempFInInt : Int = Int(round(tempF));
                self.temperatureLabel.text = "\(tempFInInt)\u{00B0}";
            }
        }
    }
}

extension UIView {
    class func weatherCurrentTempNib() -> UIView {
        return NSBundle.mainBundle().loadNibNamed(NibNames.WeatherCurrentTemp.rawValue, owner: self, options: nil).first as! UIView;
    }
}
