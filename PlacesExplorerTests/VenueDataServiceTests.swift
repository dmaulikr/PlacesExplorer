//
//  VenueDataServiceTests.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 5/11/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import XCTest
@testable import PlacesExplorer
import CoreLocation

class VenueDataServiceTests: XCTestCase {
    
    let endpoint = "https://api.foursquare.com"
    let searchApiUrl = "/v2/venues/search"
    let clientId = "45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF"
    let clientSecret = "E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAddition() {
        XCTAssertEqual(1+1, 2, "sum")
    }
    
    func testSubtraction() {
        XCTAssertEqual(1-1, 0, "subtraction")
    }
    
    func testURLConstruction() {
        let venueDataService = VenueDataService()
        
        let urlConstructor = venueDataService.createURLConstructorWithDataString("ll=-37.8136,144.9631")
        
        let stichedUpURLString = "https://api.foursquare.com/v2/venues/search?client_id=45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF&client_secret=E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815&ll=-37.8136,144.9631"
        
        print(urlConstructor.urlString)
        print(stichedUpURLString)
        XCTAssertEqual(urlConstructor.urlString, stichedUpURLString, "URL Construction")
    }
    
    func testFetchVenuesForAlocation() {
        let expectation =  expectationWithDescription("Search API Test")
        
        let venueDataService = VenueDataService()
        let location = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        venueDataService.getNearByVenues(location, success: { (venues) -> () in
                print("venues test passed")
                XCTAssertTrue(venues.count > 0, "Venues are retrieved")
                expectation.fulfill()
            }, failure: { (error) -> () in
                
            }
        )
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            print(">>> time out")
        }
    }
    
    func testNearByVenues() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
