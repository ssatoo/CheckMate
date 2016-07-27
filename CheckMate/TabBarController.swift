//
//  TabBarController.swift
//  CheckMate
//
//  Created by Zacharias Giakoumi on 05/05/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var usingGesture = false
    var interactiveTransition:UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(TabBarController.didPan(_:)))
        self.view.addGestureRecognizer(panGesture)
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
    
    func didPan(gesture: UIPanGestureRecognizer){
        let point = gesture.locationInView(gesture.view)
        let percent = fmax(fmin((point.x / 300.0), 0.99), 0.0)
        self.interactiveTransition = UIPercentDrivenInteractiveTransition()
        
        switch (gesture.state){
        case .Began:
            self.usingGesture = true
            self.selectedIndex += 1
        case .Changed:
            self.interactiveTransition?.updateInteractiveTransition(percent)
        case .Ended, .Cancelled:
            if percent > 0.5 {
                self.interactiveTransition?.finishInteractiveTransition()
            } else {
                self.interactiveTransition?.cancelInteractiveTransition()
            }
            self.usingGesture = false
        default:
            NSLog("Unhandled state")
        }
    }
}