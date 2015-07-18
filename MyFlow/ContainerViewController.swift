//
//  ContainerViewController.swift
//  MyFlow
//
//  Created by Marco Ledesma on 7/13/15.
//  Copyright (c) 2015 Marco Ledesma. All rights reserved.
//

import UIKit


enum ContainerMenuButtonPosition {
    case Left
    case Right
}

enum SlideOutState {
    case Open
    case Collapsed
}

class ContainerViewController: UIViewController {
    
    var centerViewController : UINavigationController!;
    var sideBarViewController : SideBarViewController!;
    var menuPosition: ContainerMenuButtonPosition!;
    var tapGesture: UITapGestureRecognizer?;
    
    var menuSlideState:SlideOutState = SlideOutState.Collapsed { //closures!!
        didSet {
            let shouldSet = menuSlideState != SlideOutState.Collapsed;
            self.showSidebarShadow(shouldShow: shouldSet);
        }
    };
    
    let expandedOffset: CGFloat = 100;
    
    //MARK: - Standard View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuPosition = .Left;
        self.swapCenterViewController(viewControllerName: StoryBoardID.Weather.rawValue);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    func swapCenterViewController(#viewControllerName: String)
    {
        self.centerViewController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(viewControllerName) as! UINavigationController;
        
        self.view.addSubview(self.centerViewController.view);
        
        self.addChildViewController(self.centerViewController);
        self.centerViewController.didMoveToParentViewController(self);
        
        self.addMenuButton(viewController: self.centerViewController.viewControllers[0] as! UIViewController);
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:");
        self.centerViewController.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    func toggleMenu()
    {
        if (self.menuSlideState == .Collapsed)
        {
            self.addLeftPanelViewController();
            self.animateLeftPanel(shouldExpand: true);
        }
        else
        {
            self.animateLeftPanel(shouldExpand: false);
        }
    }
    
    
    // MARK: - Update UI 
    func addMenuButton(#viewController: UIViewController)
    {
        let menuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu");
        if (self.menuPosition == .Left)
        {
            viewController.navigationItem.leftBarButtonItem = menuButton;
        }
        else
        {
            viewController.navigationItem.leftBarButtonItem = menuButton;
        }
    }
    
    func addLeftPanelViewController()
    {
        if (self.sideBarViewController == nil)
        {
            self.sideBarViewController = UIStoryboard.sidebarViewController();
            self.view.insertSubview(self.sideBarViewController.view, atIndex: 1);
            self.addChildViewController(self.sideBarViewController);
            self.sideBarViewController.didMoveToParentViewController(self);
        }
    }
    
    func animateLeftPanel(#shouldExpand: Bool)
    {
        if (shouldExpand)
        {
            self.menuSlideState = .Open;
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(self.centerViewController.view.frame) - self.expandedOffset);
            
            self.tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:");
            self.centerViewController.view.addGestureRecognizer(tapGesture!);
        }
        else
        {
            if let gesture = self.tapGesture {
                self.centerViewController.view.removeGestureRecognizer(gesture);
                self.tapGesture = nil;
            }
            
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.menuSlideState = .Collapsed;
                //TODO: Figure out if we really should remove this from the superview, does it really effect performance?
                //self.sideBarViewController!.view.removeFromSuperview();
                //self.sideBarViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat,
        completion: ((Bool) -> Void)! = nil)
    {
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.centerViewController.view.frame.origin.x = targetPosition
            },
            completion: completion);
    }
    
    func showSidebarShadow(#shouldShow:Bool)
    {
        if (shouldShow)
        {
            self.centerViewController.view.layer.shadowOpacity = 1;
            self.centerViewController.view.layer.shadowRadius = 20;
            self.centerViewController.view.layer.shadowColor = UIColor.blackColor().CGColor;
            //self.centerViewController.view.layer.shadowColor = UIColor.whiteColor().CGColor;
        }
        else
        {
            self.centerViewController.view.layer.shadowOpacity = 0;
        }
    }
}

//MARK: - Gesture Recognizer Delegate
extension ContainerViewController : UIGestureRecognizerDelegate
{
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
        let originalCenterX = self.view.center.x;
        
        switch(recognizer.state) {
            case .Began:
                if (self.menuSlideState == .Collapsed) {
                    if (gestureIsDraggingFromLeftToRight) {
                        addLeftPanelViewController()
                    }
                    
                    showSidebarShadow(shouldShow: true);
                }
            case .Changed:
                let newXPosition = recognizer.view!.center.x + recognizer.translationInView(view).x
                
                if (newXPosition >= originalCenterX)
                {
                    recognizer.view!.center.x = newXPosition;
                    recognizer.setTranslation(CGPointZero, inView: view)
                }
            case .Ended:
                if (self.sideBarViewController != nil) {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                    animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                }
            default:
                break
        }
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        self .animateLeftPanel(shouldExpand: false);
    }
}
