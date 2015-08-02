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
    @IBOutlet var effectBg: UIView!
    
    private let weatherProtocol = ProtocolFactory.WeatherProtocol();
    private let userLocationProtocol = ProtocolFactory.UserLocationProtocol();
    
    private var refreshControl : UIRefreshControl!;
    private var animateBackgroundImage = false;
    
    private var visualEffectView : UIVisualEffectView!;
    
    private let weatherCellData = ["HourlyForecast", "5 day forecast"];
    let weatherCellId = "Weather";
    let normalCellId = "Cell";
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor.clearColor();
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = UIColor.clearColor();
        tableView.backgroundColor = UIColor.clearColor();
        tableView.allowsSelection = false;
        tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
        
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill;
        
        // Initialize the refresh control.
        refreshControl = UIRefreshControl();
        refreshControl.backgroundColor = UIColor.clearColor();
        refreshControl.tintColor = UIColor.whiteColor();
        refreshControl.addTarget(self, action: "refreshWeather", forControlEvents: UIControlEvents.ValueChanged);
        tableView.addSubview(refreshControl);
        
        //adding gradient to bottom view for effect
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0).CGColor;
        let mediumColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.3).CGColor;
        let darkColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).CGColor;
        self.effectBg.backgroundColor = UIColor.clearColor();
        
        let gradientLayer = CAGradientLayer();
        gradientLayer.colors = [mediumColor, whiteColor, darkColor] as [AnyObject];
        gradientLayer.locations = [0.05, 0.5, 1.0];
        gradientLayer.frame = CGRectMake(-8, 0, self.view.frame.width + 8, self.view.frame.height);
        self.effectBg.layer.insertSublayer(gradientLayer, atIndex: 0);
        //end adding gradient
        
        //adding blur view
        visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark));
        visualEffectView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
        visualEffectView.alpha = 0;
        self.view.insertSubview(visualEffectView, belowSubview: self.effectBg);
        
        
        //end adding blur view
        
        //nav bar blur
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true

        //adding image change effect to uiimageview
        if let cachedWeatherData = self.weatherProtocol.getCachedData() {
            handleWeatherResult(cachedWeatherData);
            
            var date = cachedWeatherData.lastUpdated!;
            var rightNow = NSDate();

            let timeInterval = rightNow.timeIntervalSinceDate(date);
            let minutes = timeInterval / 60.0;
            if (minutes > 25) { //if 25 minutes have passed..
                animateBackgroundImage = true;
                
                getWeatherInfo();
            }
        }
        else {
            animateBackgroundImage = true;
            getWeatherInfo();
        }
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
    
    func refreshWeather() {
        getWeatherInfo();
    }
    
    //MARK: - Private Methods
    private func callApi(result: GetUserLocationResult) {
        weatherProtocol.execute(lat: result.latitude, lon: result.longtitude) { (weatherResult) -> Void in
            if (weatherResult.statusCode == StatusCodes.Success)
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.handleWeatherResult(weatherResult);
                });
            }
            else
            {
                UIAlertController.showError(errorTitle: "Error Getting Weather", errorMessage: "I could not get your weather information :(", inViewController: self);
            }
        };
    }
 
    private func handleWeatherResult(weatherResult: GetWeatherResult)
    {
        if let cityName = weatherResult.city, let stateName = weatherResult.state, let weather = weatherResult.weather {
            self.title = "\(cityName), \(stateName)";
            
            var dayOrNight = "Day";
            if (weatherResult.isNightTime)
            {
                dayOrNight = "Night";
            }
            
            if let image = UIImage(named: "\(weather)_\(dayOrNight)") {
                if (self.animateBackgroundImage) {
                    self.animateBackground(image);
                }
                else {
                    self.backgroundImageView.image = image;
                }
            }
            else {
                UIAlertController.showError(errorTitle: "Weather image error", errorMessage: "No image for this weather: \(weather)", inViewController: self);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.WeatherInformationReceived.rawValue, object: weatherResult);
        });
        
        self.refreshControl.endRefreshing();

    }
    
   
    
    private func animateBackground(image: UIImage) {
        var tempImageView : UIImageView? = UIImageView(frame: self.backgroundImageView.frame);
        tempImageView!.image = self.backgroundImageView.image;
        tempImageView!.alpha = 1;
        tempImageView!.contentMode = UIViewContentMode.ScaleAspectFill;
        self.view.insertSubview(tempImageView!, aboveSubview: self.backgroundImageView);
        self.backgroundImageView.image = image;
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            tempImageView!.alpha = 0;
            })  { (complete) -> Void in
                tempImageView?.removeFromSuperview();
                tempImageView = nil;
        };
        
    }
    
}


//MARK: - UITableView delegate and source
extension WeatherViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherCellData.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!;
        
        if (indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCellWithIdentifier(weatherCellId) as? UITableViewCell;
            if (cell == nil)
            {
                cell = UITableViewCell(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 64));
                
                let weatherView = UIView.weatherCurrentTempNib();
                weatherView.frame = cell.frame;
                
                cell.contentView.addSubview(weatherView);
                cell.backgroundView = nil;
                cell.backgroundColor = UIColor.clearColor();
            }
        }
        else
        {
            cell = tableView.dequeueReusableCellWithIdentifier(normalCellId) as? UITableViewCell;
            if (cell == nil)
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: normalCellId);
                cell.backgroundView = nil;
                cell.backgroundColor = UIColor.clearColor();
            }
        }
        
        
        return cell;
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return self.view.frame.height - 64;
        } else {
            return 600;
        }
        
    }
}


//MARK : - Scrollview Delegate
extension WeatherViewController {
    //Need to add snapping behavior to the first cell of the tableview
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y <= self.view.frame.size.height / 6) {
            self.tableView .scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true);
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= self.view.frame.size.height / 6) {
            self.tableView .scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true);
        }
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if (targetContentOffset != nil) {
            let point = targetContentOffset.memory;
            if (point.y <= self.view.frame.size.height / 6) {
                self.tableView .scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true);
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var yPosition = scrollView.contentOffset.y;
        let threshold : CGFloat = 400.0;
        var alpha = yPosition / threshold;
        
        
        if (alpha < 0)
        {
            alpha = 0;
        }
        
        if (alpha > 1) {
            alpha = 1.0;
        }
        
        if (self.visualEffectView != nil)
        {
            self.visualEffectView.alpha = alpha;
            self.effectBg.alpha = 1.0 - alpha;
            NSLog("effectBg alpha: \(self.effectBg.alpha)")
        }
        
    }
}