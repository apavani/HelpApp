//
//  FirstViewController.swift
//  Help
//
//  Created by demo on 9/28/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    var latitude: String!
    var longitude: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //var addLocation : PFObject = PFObject(className: "PeopleLocation")
        
        //self.locationManager = CLLocationManager()
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.delegate = self
        
        
        //Setting other variables in the PFObject
        //addLocation["Latitude"] = 40.50
        //addLocation["Longitude"] = 50.22014
       // addLocation.saveInBackground()
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the location label to the coordinates of location.
        latitude = "\(coord.latitude)"
        longitude = "\(coord.longitude)"
        
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

