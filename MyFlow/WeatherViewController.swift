//
//  WeatherViewController.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/18/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundImageView: UIImageView!;
    
    private let weatherProtocol = ProtocolFactory.WeatherProtocol();
    private let userLocationProtocol = ProtocolFactory.UserLocationProtocol();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = UIColor.clearColor();
        tableView.backgroundColor = UIColor.clearColor();
        tableView.contentInset = UIEdgeInsetsMake(44,0,0,0);
        getWeatherInfo();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func getWeatherInfo() {
        weak var weakSelf = self;
        userLocationProtocol.execute { (result) -> Void in
            if (result.statusCode == StatusCodes.Success) {
                weakSelf!.callApi(result);
            }
            else {
                UIAlertController.showError(errorTitle: "Error Getting Location", errorMessage: "I could not get your location :(", inViewController: weakSelf!);
            }
        };
    }
    
    
    //MARK: - Private Methods
    private func callApi(result: GetUserLocationResult) {
        weatherProtocol.execute(lat: result.latitude, lon: result.longtitude) { (weatherResult) -> Void in
            if (weatherResult.statusCode == StatusCodes.Success)
            {
                self.handleWeatherResult(weatherResult);
            }
            else
            {
                UIAlertController.showError(errorTitle: "Error Getting Weather", errorMessage: "I could not get your weather information :(", inViewController: self);
            }
        };
    }
 
    private func handleWeatherResult(weatherResult: GetWeatherResult)
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let cityName = weatherResult.city, let stateName = weatherResult.state {
                self.title = "\(cityName), \(stateName)";
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.WeatherInformationReceived.rawValue, object: weatherResult);
        })
    }
}


//MARK: - UITableView delegate and source
extension WeatherViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        return cell;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let weatherCurrentTempView = UIView.weatherCurrentTempNib() as! WeatherCurrentTempView;
        return weatherCurrentTempView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) { //Weather Current Temp
            return self.view.frame.height - 44;
        }
        
        return 0;
    }
}