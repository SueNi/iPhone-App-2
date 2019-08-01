//
//  ViewController.swift
//  Adventure
//
//  Created by GWC2 on 7/22/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var text1: UILabel!
    let message = "One day, you are working on your homework on your computer. Suddenly, all your tabs are closed and a blue button appears on the screen."
    override func viewDidLoad() {
        
        super.viewDidLoad()
         //text1.text = " "
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        text1.an(Message: message, myLabel: text1)
    }

}

