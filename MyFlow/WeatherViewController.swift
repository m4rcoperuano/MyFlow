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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorGettingLocation", name: NotificationNames.ErrorRetrievingLocation.rawValue, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = UIColor.clearColor();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

//MARK: - NSNotificationCenter subs
extension WeatherViewController {
    func errorGettingLocation() {
        let alertController = UIAlertController(title: "Error retrieving location", message: "Unable to get your location", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil);
        }));
        
        presentViewController(alertController, animated: true, completion: nil);
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
        
        //MARK: Injecting dependencies in WeatherCurrentTempView
        weatherCurrentTempView.injectDependencies(GetWeatherService(), userLocationProtocol: GetUserLocationService());
        
        weatherCurrentTempView.loadCurrentTemperature();
        return weatherCurrentTempView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) { //Weather Current Temp
            return self.view.frame.height / 2;
        }
        
        return 0;
    }
}