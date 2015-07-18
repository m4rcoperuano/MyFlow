//
//  SideBarViewController.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/13/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit

enum MenuTitles : String {
    case Weather = "Weather"
}

class SideBarMenuOptions : NSObject
{
    let menuTitle : MenuTitles;
    let menuIconName : String;
    
    init(menuTitle: MenuTitles)
    {
        self.menuTitle = menuTitle;
        
        var menuIconName : String?;
        switch (menuTitle)
        {
            case MenuTitles.Weather:
                menuIconName = ImageNames.SidebarWeatherIcon.rawValue;
            default:
                menuIconName = ImageNames.SidebarWeatherIcon.rawValue;
        }
        
        self.menuIconName = menuIconName!;
    }
}

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let menuOptions = [SideBarMenuOptions(menuTitle: MenuTitles.Weather)];
    let cellIdentifier : String = "Cell";
    var currentMenuOption = MenuTitles.Weather;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = UIColor.clearColor();
        self.tableView.separatorColor = UIColor.clearColor();
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: ImageNames.SidebarBackground.rawValue)!);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - UITableView Delegate
extension SideBarViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tableViewCell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell;
        tableViewCell?.backgroundColor = UIColor.clearColor();
        tableViewCell?.textLabel?.textColor = UIColor.whiteColor();
        
        let selectedBgView = UIView();
        selectedBgView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6);
        tableViewCell?.selectedBackgroundView = selectedBgView;
        
        
        let menuOption = self.menuOptions[indexPath.row];
        tableViewCell?.textLabel?.text = menuOption.menuTitle.rawValue;
        tableViewCell?.imageView?.image = UIImage(named: menuOption.menuIconName);
        
        return tableViewCell!;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell.textLabel?.text == self.currentMenuOption.rawValue)
        {
            cell.setSelected(true, animated: false);
        }
    }
}
