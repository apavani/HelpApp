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
    
    @IBOutlet var Dialogue: UITextView!

    
    struct UserInfo {
        var userID: String!
        var latitude: Float!
        var longitude: Float!
        var distance: Float!
    }
    
    var users:  [UserInfo] = []
    
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
        loadNewData()
    }

    
        func loadNewData()
        {
            var query = PFQuery(className: "PeopleLocation")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    if (self.users.count>0)
                    {
                     self.users.removeAll(keepCapacity: false)
                    }
                    self.Dialogue.text=""
                    for object in objects{
                        var longitude: Float = object.objectForKey("Longitude") as Float
                        
                        var latitude: Float = object.objectForKey("Latitude") as Float
                        
                        var userID : String = object.objectForKey("DeviceID") as String
                        
                        let distanceCalc = DistanceCalculator(lat1: 40 , lat2: latitude, lon1: 36 , lon2: longitude)
                        
                        var distance: Float = distanceCalc.calculateDistance()
                        
                        var userdata: UserInfo = UserInfo(userID: userID, latitude: latitude, longitude: longitude, distance: distance)
                        
                        self.users.append(userdata)
                        var text:String!
                        
                        for user in self.users {
                            text = self.Dialogue.text + user.userID + ":" + "\(user.distance)" + "\n"
                        }
                        self.Dialogue.text = text
                    }
                    
                }

    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the location label to the coordinates of location.
        var myLatitude: String = "\(coord.latitude)"
        var myLongitude: String = "\(coord.longitude)"
        
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
            }
    
    //override func didReceiveMemoryWarning() {
      //  super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}


}
}

