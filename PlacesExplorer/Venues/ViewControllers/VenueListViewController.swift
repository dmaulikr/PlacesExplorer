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
    
    var locationManager: CLLocationManager?
    @IBOutlet weak var venuesTableView: UITableView!
    
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    var refreshControl: UIRefreshControl!
    var venues: [Venue] = []
    
    let venueDataService = VenueDataService()
    var isMainView = true
    
    var currentLocation: CLLocationCoordinate2D!
    var selectedVenueId: String?
    var selectedVenuesCategoryId: String?
    var selectedVenuesCategoryName: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if isMainView {
            self.title = "Locating You..."
            enableRefreshControl()
            findLocation()
        } else {
            //otherwise the top row is hidden behind the nav bar.
            tableTopConstraint.constant = 64
            fetchVenues(currentLocation, categoryId: selectedVenuesCategoryId!, categoryName: selectedVenuesCategoryName!)
        }
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

// For reference
//    func enableRefreshControl2() {
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        venuesTableView.addSubview(refreshControl)
//    }

    func refresh() {
        locationManager?.requestLocation()
        refreshControl.endRefreshing()
    }
    
    func findLocation() {
        
        if (locationManager == nil) {
            locationManager = CLLocationManager()
        }
        
        locationManager?.delegate = self

        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 100 // meteres
        locationManager?.requestWhenInUseAuthorization()
        ActivityManager.sharedManager().startActivityIndicator(view)
        locationManager?.requestLocation()
    }
    
    //MARK: locationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Invoking didUpdateLocations")
        if (locations.count > 0) {
            print("Location -> \(locations[0])")
            self.currentLocation = locations[0].coordinate
            self.fetchVenues(locations[0].coordinate)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location update FAILED")
    }
    
    //MARK: webservice access
    func fetchVenues(location: CLLocationCoordinate2D){
        self.title = "Accessing Venues..."
        ActivityManager.sharedManager().startActivityIndicator(self.view)
        venueDataService.getNearByVenues(location, success: { (venues) -> () in
                print("Success \(venues.count)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.venues = self.sortVenues(venues)
                    ActivityManager.sharedManager().stopActivityIndicator()
                    self.venuesTableView.reloadData()
                    self.title = "Nearby Venues"
                })
            
            }, failure: { (error) -> () in
                print("Failure")
        })
    }
    
    func fetchVenues(location: CLLocationCoordinate2D, categoryId: String, categoryName: String){
        self.title = "Accessing Popular \(categoryName)s..."
        ActivityManager.sharedManager().startActivityIndicator(self.view)
        venueDataService.getNearByVenues(location, categoryId: categoryId, success: { (venues) -> () in
            print("Success \(venues.count)")
            dispatch_async(dispatch_get_main_queue(), {
                ActivityManager.sharedManager().stopActivityIndicator()
                self.venues = self.sortVenues(venues)
                self.venuesTableView.reloadData()
                self.title = "Popular \(categoryName)s"
            })
            
            }, failure: { (error) -> () in
                print("Failure")
                self.title = "Couldn't Access Venues"
        })
    }
    
    func fetchSimilarVenues(venueId: String){
        print("Fetching similar venues...")
        ActivityManager.sharedManager().startActivityIndicator(self.view)
        venueDataService.getSimilarVenues(venueId, success: { (venues) -> () in
            print("Success \(venues.count)")
            dispatch_async(dispatch_get_main_queue(), {
                    ActivityManager.sharedManager().stopActivityIndicator()
                    self.venues = self.sortVenues(venues)
                    self.venuesTableView.reloadData()
                })
            
            }, failure: { (error) -> () in
                print("Failure")
        })
    }
    
    func sortVenues(var venues: [Venue]) -> [Venue] {
        venues.sortInPlace{(venue1, venue2) -> Bool in
            guard let distance1 = venue1.venueLocation?.distance,
                let distance2 = venue2.venueLocation?.distance else {
                    return false
            }
            return distance1 < distance2
        }
        return venues
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
        print("\(venue.name!)\n   \(venue.venueLocation?.city)    \(venue.venueLocation?.distance)")
        configureCell(cell, withVenue: venue)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isMainView {
            let venue = venues[indexPath.row]
            print("Selected Venue \(venue.name) - \(venue.id)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newListViewController = storyboard.instantiateViewControllerWithIdentifier("VenueListViewController") as! VenueListViewController
            newListViewController.selectedVenueId = venue.id
            newListViewController.currentLocation = self.currentLocation
            newListViewController.isMainView = false
            
            
            if let categories = venue.categories {
                if categories.count > 0 {
                    newListViewController.selectedVenuesCategoryId = categories[0].id
                    newListViewController.selectedVenuesCategoryName = categories[0].name
                    self.navigationController?.pushViewController(newListViewController, animated: true)
                } else {
                    openAlertView("No Popular Venues found")
                }
            } else {
                openAlertView("No Popular Venues found")
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func openAlertView(message: String) {
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    private func configureCell(cell: VenueListTableViewCell, withVenue venue: Venue) {
        cell.venueTitleLabel.text = venue.name
        if let categories = venue.categories {
            if categories.count > 0 {
                cell.venueTypeLabel.text = categories[0].name
            }
        }
        
        if let address = venue.venueLocation?.address {
            cell.venueAddressLabel.text = address
        } else {
            cell.venueAddressLabel.text = "-"
        }
        if let city = venue.venueLocation?.city {
            cell.venuePlaceLabel.text = city
        } else {
            cell.venuePlaceLabel.text = "-"
        }
        
        if let distance = venue.venueLocation!.distance {
            cell.venueDistanceLabel.text = String(distance) + " meters"
        } else {
            cell.venueDistanceLabel.text = "-"
        }
    }

}
