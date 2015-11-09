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
        getNearByVenues(dataString, success: success, failure: failure)
    }
    
    func getNearByVenues(location: CLLocationCoordinate2D, categoryId: String, success:(venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        let dataString = "ll=" + String(location.latitude) + "," + String(location.longitude) + "&categoryId=" + categoryId
        getNearByVenues(dataString, success: success, failure: failure)
    }
    
    
    private func getNearByVenues(dataString: String, success: (venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        let urlConstructor = createURLConstructorWithDataString(dataString)
        getVenues(urlConstructor, success: success, failure: failure)
    }
    
    private func getVenues(urlConstructor: URLConstructor, success: (venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        let urlSession = NSURLSession.sharedSession()
        print(urlConstructor.url)
        let task = urlSession.dataTaskWithURL(urlConstructor.url) { (data:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return
                }
                print(JSON)
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
    
    func getSimilarVenues(venueId: String, success:(venues: [Venue]) -> (), failure: (error: NSError) -> ()) {
        let urlConstructor = createURLConstructorForSimilarVenues(venueId)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(urlConstructor.url) { (data:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                    print("Not a dictionary")
                    return
                }
                
                print(JSON)
                let responseDict = JSONDictionary["response"] as! Dictionary<String, AnyObject>
                let similarVenuesDict = responseDict["similarVenues"] as! Dictionary<String, AnyObject>
                let venueDicts = similarVenuesDict["items"] as! [Dictionary<String, AnyObject>]
                let venues = venueDicts.map{ (venueDict) -> Venue in
                    return Mapper().map(venueDict, toObject: Venue())
                }
                success(venues: venues)
            }
            catch let JSONError as NSError {
                print("Error => \(JSONError)")
            }
        }
        task.resume()
    }
    
    //https://api.foursquare.com/v2/venues/VENUE_ID/similar
    func createURLConstructorForSimilarVenues(venueId: String) -> URLConstructor {
        let urlConstructor = URLConstructor()
        urlConstructor.endPoint = endpoint
        urlConstructor.webservice = "/v2/venues/" + venueId + "/similar"
        urlConstructor.clientId = clientId
        urlConstructor.clientSecret = clientSecret
        return urlConstructor
    }
    
}