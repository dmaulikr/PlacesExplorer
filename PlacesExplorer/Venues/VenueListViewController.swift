//
//  VenueListViewController.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 26/10/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import UIKit

class VenueListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var venuesTableView: UITableView!
    var venues: [Venue] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVenues()
    }
    
    func fetchVenues(){
        let dataService = DataService()
        dataService.getNearByVenues({ (venues) -> () in
                print("Success \(venues.count)")
                self.venues = venues
                self.venuesTableView.reloadData()
            }) { (error) -> () in
                print("Failure")
        }
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
        return cell
    }

}
