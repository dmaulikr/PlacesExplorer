//
//  VenueCategory.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

class VenueCategory: Mappable {

    var id: String?
    var name: String?

    class func newInstance() -> Mappable {
        return VenueCategory()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
    
}