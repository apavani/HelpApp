//
//  FirstViewController.swift
//  Help
//
//  Created by demo on 9/28/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let distanceCalculator = DistanceCalculator(lat1: 54.3 , lat2: 72.11 , lon1: 65.43 , lon2: -45.21)
        distanceCalculator.calculateDistance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

