//
//  VenueDataServiceTests.swift
//  PlacesExplorer
//
//  Created by Madhu Samuel on 5/11/2015.
//  Copyright © 2015 Madhu. All rights reserved.
//

import XCTest
@testable import PlacesExplorer

class VenueDataServiceTests: XCTestCase {

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
        let endpoint = "https://api.foursquare.com"
        let apiUrl = "/v2/venues/search"
        let clientId = "45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF"
        let clientSecret = "E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815"
        let data = "ll=-37.8136,144.9631"
        
        let stichedUpURLString = "https://api.foursquare.com/v2/venues/search?client_id=45OD3KD2OAX3IDGYPJ3FVXQX5VYIGWV5JDQGM1MDBGJEWFJF&client_secret=E3G1JPJWTJF4XISJA5C5DYVKQLEXSOQGBLPWPLADBZFBTO2R&v=20130815&ll=-37.8136,144.9631"

        let urlConstructor = URLConstructor()
        urlConstructor.endPoint = endpoint
        urlConstructor.webservice = apiUrl
        urlConstructor.clientId = clientId
        urlConstructor.clientSecret = clientSecret
        urlConstructor.dataURLString = data
        print(urlConstructor.urlString)
        print(stichedUpURLString)
        XCTAssertEqual(urlConstructor.urlString, stichedUpURLString, "URL Construction")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
