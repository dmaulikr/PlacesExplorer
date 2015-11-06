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
    var refreshControl: UIRefreshControl!
    var venues: [Venue] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        enableRefreshControl()
        findLocation()
    }
    
    //Ideally a refresh control uses a tableviewcontroller. Since we are using a uiviewcontroller, we create 
    //a new tableviewcontroller just to use refreshcontrol. The below commented method also works, but there is a 
    //slight "stutter".
    func enableRefreshControl() {
        let tableViewController = UITableViewController()
        tableViewController.tableView = venuesTableView
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableViewController.refreshControl = refreshControl
    }
    
//    func enableRefreshControl2() {
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        venuesTableView.addSubview(refreshControl)
//    }

    func refresh() {
        locationManager.requestLocation()
        refreshControl.endRefreshing()
    }
    
    func findLocation() {
        
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100 // meteres
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        ActivityManager.sharedManager().startActivityIndicator(venuesTableView)
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
        ActivityManager.sharedManager().startActivityIndicator(self.view)
        venueDataService.getNearByVenues(location, success: { (venues) -> () in
                print("Success \(venues.count)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.venues = venues
                    ActivityManager.sharedManager().stopActivityIndicator()
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
