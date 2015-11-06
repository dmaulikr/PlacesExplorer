//
//  VenueDataService.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 6/11/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import Foundation
import CoreLocation

class VenueDataService: DataService {
    
    func getNearByVenues(location: CLLocationCoordinate2D, success:(venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        
        let dataString = "ll=" + String(location.latitude) + "," + String(location.longitude)
        let urlConstructor = createURLConstructorWithDataString(dataString)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(urlConstructor.url) { (data:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
            
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
            
            }
        task.resume()
    }
    
    
}