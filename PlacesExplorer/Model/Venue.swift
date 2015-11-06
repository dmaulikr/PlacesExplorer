//
//  Venue.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation

class Venue: Mappable {
    var id: String?
    var name: String?
    var categories: [VenueCategory]?
    var description: String?
    var venueLocation: VenueLocation?
    
    class func newInstance() -> Mappable {
        return Venue()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        categories <- map["categories"]
        description <- map["description"]
        venueLocation <- map["location"]
    }
}