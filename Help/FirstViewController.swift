//
//  FirstViewController.swift
//  Help
//
//  Created by demo on 9/28/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import CoreLocation
import UIKit

class FirstViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var name: UILabel!

    var locationManager : CLLocationManager!
    var myLatitude : CLLocationDegrees!
    var myLongitude : CLLocationDegrees!
    var myName : String!
    
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
        println("Test")
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        self.Dialogue.layer.borderWidth = 0.1
        loadNewData()
        self.name.text = self.myName
    }

    override func viewDidAppear(animated: Bool) {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
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
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Most recent updates are appended to end of array,
        // so find the most recent update in last index.
        var loc : CLLocation = locations?[locations.count - 1] as CLLocation
        
        // The location stored as a coordinate.
        var coord : CLLocationCoordinate2D = loc.coordinate
        
        // Set the coordinates of location.
        self.myLatitude = coord.latitude
        self.myLongitude = coord.longitude
        println(self.myLatitude)
        println(self.myLongitude)
        // Tell location manager to stop collecting and updating location.
        self.locationManager.stopUpdatingLocation()
        
        //Setting other variables in the PFObject
        var addLocation : PFObject = PFObject(className: "PeopleLocation")
        addLocation["Latitude"] = (self.myLatitude.description as NSString).floatValue
        addLocation["Longitude"] = (self.myLongitude.description as NSString).floatValue
        
        
        let deviceID =  IdentityGenerator()
        
        var isRegistered : Bool = isDeviceRegistered(deviceID: deviceID.identifierForVendor.description)
        
        if(!isRegistered)
        {
        addLocation["DeviceID"] = deviceID.identifierForVendor.UUIDString as String
        }
        
        else
        {
            //Logic to update the co-ordinates in the corresponding row where the device ID is found
        }
        addLocation.saveInBackground()
        
    }
    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


            func isDeviceRegistered(deviceID ID:String!) -> Bool{
                
            var flag : Bool = false
            var query = PFQuery(className: "PeopleLocation")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    for object in objects{
                        var deviceID: String = object.objectForKey("DeviceID") as String
                        if(ID==deviceID)
                        {
                        flag = true
                        }
                    }
                }
                }
                return flag
    }
}

