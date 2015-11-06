//
//  DataService.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation

class DataService {
    
    let endpoint = "https://api.foursquare.com"
    let searchApiUrl = "/v2/venues/search"
    let clientId = "45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF"
    let clientSecret = "E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815"
    
    func login(userName: String, password: String, success:()->(), failure: (error: NSError)->()) {
        print("Loggin in \(userName)")
    }
    
    func createURLConstructorWithDataString(data: String) -> URLConstructor {
        let urlConstructor = URLConstructor()
        urlConstructor.endPoint = endpoint
        urlConstructor.webservice = searchApiUrl
        urlConstructor.clientId = clientId
        urlConstructor.clientSecret = clientSecret
        urlConstructor.dataURLString = data
        return urlConstructor
    }
}
