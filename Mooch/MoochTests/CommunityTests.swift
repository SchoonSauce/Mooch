//
//  CommunityTests.swift
//  Mooch
//
//  Created by adam on 9/6/16.
//  Copyright © 2016 cse498. All rights reserved.
//


import XCTest
import CoreLocation
@testable import Mooch

class CommunityTests: XCTestCase {
    
    func testDesignatedInit() {
        let latitude: CLLocationDegrees = 42.7325
        let longitude: CLLocationDegrees = 84.5555
        let myLocation: CLLocation = CLLocation(latitude: latitude,longitude: longitude)
        let community = Community(id: 7, address: "123 LaSalle", name: "123 Big Apartments", pictureURL:"I am a sample pic",location: myLocation)
        
        //Test that all the variables are correctly initialized
        XCTAssert(community.id == 7)
        XCTAssert(community.address == "123 LaSalle")
        XCTAssert(community.name == "123 Big Apartments")
        XCTAssert(community.pictureURL == "I am a sample pic")
        XCTAssert(community.location.coordinate.latitude == 42.7325)
        XCTAssert(community.location.coordinate.longitude == 84.5555)
    }
    
    //Test that a Community is constructed without failing when given JSON with all the data it needs
    func testConvenienceInitSuccess() {

        let communityJSON: JSON = [Community.JSONMapping.id.rawValue : 1234,  Community.JSONMapping.address.rawValue : "1234 address lane", Community.JSONMapping.name.rawValue : "highrise apartments", Community.JSONMapping.pictureURL.rawValue :"I am a sample pic", Community.JSONMapping.latitude.rawValue: "42.7325",Community.JSONMapping.longitude.rawValue: "84.5555"]
        
        do {
            let community = try Community(json: communityJSON)
            
            //Test that all the variables are correctly initialized
            XCTAssert(community.id == 1234)
            XCTAssert(community.address == "1234 address lane")
            XCTAssert(community.name == "highrise apartments")
            XCTAssert(community.pictureURL == "I am a sample pic")
            XCTAssert(community.location.coordinate.latitude == 42.7325)
            XCTAssert(community.location.coordinate.longitude == 84.5555)

        } catch {
            XCTFail()
        }
    }
    //Test that a Community is constructed with failing when given JSON with incomplete the data it needs

    func testConvenienceIdError() {
        let communityJSON: JSON = [Community.JSONMapping.id.rawValue : 1234]
        
        var jsonErrorThrown = false
        
        do {
            let _ = try Community(json: communityJSON)
            XCTFail()
        } catch Community.JSONInitializationError.address {
            jsonErrorThrown = true
        } catch {
            
        }
        XCTAssert(jsonErrorThrown)
    }
    func testConvenienceAddressError() {
        let communityJSON: JSON = [Community.JSONMapping.id.rawValue : 1234,Community.JSONMapping.address.rawValue : "1234 address lane"]
        
        var jsonErrorThrown = false
        
        do {
            let _ = try Community(json: communityJSON)
            XCTFail()
        } catch Community.JSONInitializationError.name {
            jsonErrorThrown = true
        } catch {
            
        }
        XCTAssert(jsonErrorThrown)
    }
    func testConvenienceNameError() {
        let communityJSON: JSON = [Community.JSONMapping.id.rawValue : 1234,Community.JSONMapping.address.rawValue : "1234 address lane",Community.JSONMapping.name.rawValue : "highrise apartments"]
        var jsonErrorThrown = false
        do {
            let _ = try Community(json: communityJSON)
            XCTFail()
        } catch Community.JSONInitializationError.pictureURL {
            jsonErrorThrown = true
        } catch {
        }
        XCTAssert(jsonErrorThrown)
    }
    func testConveniencePictureURLError() {
        let communityJSON: JSON = [Community.JSONMapping.id.rawValue : 1234,Community.JSONMapping.address.rawValue : "1234 address lane",Community.JSONMapping.name.rawValue : "highrise apartments"]
        var jsonErrorThrown = false
        do {
            let _ = try Community(json: communityJSON)
            XCTFail()
        } catch Community.JSONInitializationError.pictureURL {
            jsonErrorThrown = true
        } catch {
        }
        XCTAssert(jsonErrorThrown)
    }
    

    
    //Test that a Community throws the expected error when it doesn't have all the data it needs
    func testConvenienceInitError() {
        let communityJSON: JSON = ["id" : 1234,"name":"jiang","pictureURL":"sample Pic"]
        
        var jsonErrorThrown = false
        
        do {
            let _ = try Community(json: communityJSON)
            XCTFail()
        } catch Community.JSONInitializationError.address {
            jsonErrorThrown = true
        } catch {
            
        }
        
        XCTAssert(jsonErrorThrown)
    }
}
