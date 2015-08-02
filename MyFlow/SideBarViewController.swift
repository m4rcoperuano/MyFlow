//
//  SideBarViewController.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/13/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    let menuOptions = [SideBarMenuOptions(menuTitle: MenuTitles.Weather), SideBarMenuOptions(menuTitle: MenuTitles.Toggle)];
    let cellIdentifier : String = "Cell";
    var currentMenuOption = SideBarMenuOptions(menuTitle: MenuTitles.Weather); //home page
    
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
        
        var tableViewCell : SideBarTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SideBarTableViewCell;
        tableViewCell?.backgroundColor = UIColor.clearColor();
        tableViewCell?.textLabel?.textColor = UIColor.whiteColor();
        
        let selectedBgView = UIView();
        selectedBgView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.6);
        tableViewCell?.selectedBackgroundView = selectedBgView;
        
        
        let menuOption = self.menuOptions[indexPath.row];
        tableViewCell?.textLabel?.text = "         \(menuOption.menuTitle.rawValue)";
        tableViewCell?.menuOption = menuOption;
        
        let customImageView = UIImageView(frame: CGRectMake(10, 8, 45, 45));
        customImageView.image = UIImage(named: menuOption.menuIconName);
        tableViewCell?.contentView.addSubview(customImageView);
        
        return tableViewCell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tableCell = tableView.cellForRowAtIndexPath(indexPath) as! SideBarTableViewCell;
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.SidebarMenuOptionSelected.rawValue, object: tableCell.menuOption);
    }
}
