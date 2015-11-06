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
    
    func getNearByVenues(success:(venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        
        let urlString = "https://api.foursquare.com/v2/venues/search?client_id=45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF&client_secret=E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815&ll=-37.8136,144.9631"
        
        let url = NSURL(string: urlString)
        let urlSession = NSURLSession.sharedSession()
        urlSession.dataTaskWithURL(url!) { (data:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return
                }
                let responseDict = JSONDictionary["response"] as! Dictionary<String, AnyObject>
                let venueDicts = responseDict["venues"] as! [Dictionary<String, AnyObject>]
                let venues = venueDicts.map{(venueDict)->Venue  in
                    return Mapper().map(venueDict, toObject: Venue())
                }
                success(venues: venues)
            }
            catch let JSONError as NSError {
                print("Error -> \(JSONError)")
            }
            
        }.resume()
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
