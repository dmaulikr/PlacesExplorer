//
//  VenueListViewController.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import UIKit
import CoreLocation

class VenueListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var venuesTableView: UITableView!
    
    var venues: [Venue] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        findLocation()
    }
    
    func findLocation() {
        
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // meteres
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
    //MARK: locationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Invoking didUpdateLocations")
        if (locations.count > 0) {
            print("Location -> \(locations[0])")
            self.fetchVenues(locations[0].coordinate)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location update FAILED")
    }
    
    //MARK: webservice access
    
    func fetchVenues(location: CLLocationCoordinate2D){
        let venueDataService = VenueDataService()
        print("Loading...")
//        let location = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        venueDataService.getNearByVenues(location, success: { (venues) -> () in
                print("Success \(venues.count)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.venues = venues
                    self.venuesTableView.reloadData()
                })
            
            }, failure: { (error) -> () in
                print("Failure")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("venueTableViewCell") as! VenueListTableViewCell
        let venue = venues[indexPath.row]
        print("\(venue.name)")
        cell.venueTitleLabel.text = venue.name
        if let categories = venue.categories {
            if categories.count > 0 {
                cell.venueTypeLabel.text = categories[0].name
            }
        }
        return cell
    }

}
