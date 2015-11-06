//
//  VenueLocation.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 6/11/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation

class VenueLocation: Mappable {
    var address: String?
    var city: String?
    var distance: Int? //meters
    
    class func newInstance() -> Mappable {
        return VenueLocation()
    }
    
    func mapping(map: Map) {
        address <- map["address"] //"4 Gwynne St"
        city <- map["city"] //Richmond
        distance <- map["distance"] //42
    }
}