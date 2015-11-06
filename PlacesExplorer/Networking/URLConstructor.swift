//
//  URLConstructor.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 5/11/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation

class URLConstructor {
    
    var endPoint: String!
    var webservice: String!
    var clientId: String!
    var clientSecret: String!
    var dataURLString: String!
    
    
    //Example: https://api.foursquare.com/v2/venues/search?client_id=45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF&client_secret=E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815&ll=-37.8136,144.9631
    var urlString: String {
        get {
            var interURLString = endPoint + webservice
            if let localClientId = clientId {
                interURLString = interURLString + "?" + "client_id=" + localClientId + "&" + "client_secret=" + clientSecret
            }
            
            if let localDataURLString = dataURLString {
                if let localClientId = clientId {
                    interURLString = interURLString + "&" + dataURLString
                } else {
                    interURLString = interURLString + "?" + dataURLString
                }
                
            }
            
            return interURLString
        }
    }
    
    var url: NSURL {
        get {
            return NSURL(string: urlString)!
        }
    }
    
}