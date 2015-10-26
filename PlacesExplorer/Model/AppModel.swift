//
//  AppModel.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation

class AppModel {
    
    private var instance = AppModel()
    
    var venues: [Venue]?
    
    func sharedInstance() -> AppModel {
        return instance
    }
    
}