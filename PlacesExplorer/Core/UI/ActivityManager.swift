//
//  ActivityManager.swift
//  BeCollectiveUniMeetup
//
//  Created by Madhu Samuel on 17/08/2015.
//  Copyright (c) 2015 BeCollective. All rights reserved.
//

import UIKit

//Provides a shared activity indicator for view controllers
class ActivityManager {
    
    private var activityIndicatorView: UIActivityIndicatorView
    
    private static var singleton: ActivityManager!
    private var isRunning = false;
    
    
    init() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicatorView.hidesWhenStopped = true
    }
    
    static func sharedManager() -> ActivityManager {
        if (singleton == nil) {
            singleton = ActivityManager()
        }
        return singleton
    }
    
    func startActivityIndicator(parentView: UIView) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.frame = CGRectMake(parentView.frame.width/2 - 50, 210, 100, 100)
        UIApplication.sharedApplication().keyWindow?.addSubview(activityIndicatorView)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        isRunning = true
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        isRunning = false
    }

    func isActivityRunning() -> Bool {
        return isRunning
    }
    
}
