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
    @IBOutlet var nowCastLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherSummaryImageView: UIImageView!
    
    var originalNowCastFrame : CGRect?;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateWeather:", name: NotificationNames.WeatherInformationReceived.rawValue, object: nil);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clearColor();
        temperatureLabel.textColor = UIColor.whiteColor();
        feelsLikeLabel.textColor = temperatureLabel.textColor;
        humidityLabel.textColor = temperatureLabel.textColor;
        nowCastLabel.textColor = temperatureLabel.textColor;
        
        containerView.backgroundColor = UIColor.clearColor();
        nowCastLabel.text = "";
        
        self.setNeedsLayout();
        
    }
    
    
    //MARK: - NSNotification Implementations
    func updateWeather(notification: NSNotification)
    {
        if (self.originalNowCastFrame == nil)
        {
            self.originalNowCastFrame = nowCastLabel.frame;
        }
        
        if let weatherInfo = notification.object as? GetWeatherResult {
            if let tempF = weatherInfo.tempInF {
                let tempFInInt : Int = Int(round(tempF));
                self.temperatureLabel.text = "\(tempFInInt)\u{00B0}";
            }
            
            if  weatherInfo.nowCast?.isEmpty == false {
                let cast = weatherInfo.nowCast as String!;
                let newTrimmedCast = cast.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
                let characters = newTrimmedCast.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as NSArray;
                let fixedCast = characters.componentsJoinedByString(" ");
                self.nowCastLabel.text = fixedCast;
                
                self.nowCastLabel.setTranslatesAutoresizingMaskIntoConstraints(true);
                
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.nowCastLabel.frame = self.originalNowCastFrame!;
                });
            }
            else {
                self.nowCastLabel.text = nil;
                let origin = self.nowCastLabel.frame.origin;
                let size = self.nowCastLabel.frame.size;
                
                self.nowCastLabel.setTranslatesAutoresizingMaskIntoConstraints(true);
                
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.nowCastLabel.frame = CGRectMake(origin.x, origin.y + size.height, size.width, 1);
                });
            }
            
            
            if let feelsLikeTemp = weatherInfo.feelsLikeTempInF {
                self.feelsLikeLabel.text = "Feels like \(Int(round(feelsLikeTemp)))\u{00B0}";
            }
            else {
                self.feelsLikeLabel.text = "";
            }
            
            if let humidity = weatherInfo.humidity {
                self.humidityLabel.text = "Humidity \(humidity)";
            }
            else {
                self.humidityLabel.text = "";
            }
            
            if let icon = weatherInfo.icon {
                self.weatherSummaryImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: icon)!)!);
            }
            
        }
    }
    
}

extension UIView {
    class func weatherCurrentTempNib() -> UIView {
        return NSBundle.mainBundle().loadNibNamed(NibNames.WeatherCurrentTemp.rawValue, owner: self, options: nil).first as! UIView;
    }
}
