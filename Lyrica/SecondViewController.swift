//
//  SecondViewController.swift
//  Lyrica
//
//  Created by Nathan Lewis on 7/10/17.
//  Copyright © 2017 Nathan Lewis. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:243/255, green:226/255, blue:172/255, alpha:1.0)]
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

