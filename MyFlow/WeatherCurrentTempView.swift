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

    private var weatherProtocol : GetWeatherProtocol!;
    private var userLocationProtocol : GetUserLocationProtocol!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    func injectDependencies(weatherProtocol: GetWeatherProtocol, userLocationProtocol: GetUserLocationProtocol) {
        self.weatherProtocol = weatherProtocol;
        self.userLocationProtocol = userLocationProtocol;
    }
    
    func loadCurrentTemperature() {
        weak var weakSelf = self;
        self.userLocationProtocol.execute { (result) -> Void in
            if (result.statusCode == StatusCodes.Success) {
                weakSelf!.callApi();
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.ErrorRetrievingLocation.rawValue, object: nil);
            }
        };
    }
    
    
    //MARK: - Private Methods
    private func callApi() {
        NSLog("API called");
    }
}

extension UIView {
    class func weatherCurrentTempNib() -> UIView {
        return NSBundle.mainBundle().loadNibNamed(NibNames.WeatherCurrentTemp.rawValue, owner: self, options: nil).first as! UIView;
    }
}
