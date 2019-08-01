//
//  animate.swift
//  Adventure
//
//  Created by GWC2 on 7/22/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func an(Message: String, myLabel: UILabel) {
        myLabel.text = ""
        let characterArray = Array(Message)
        var characterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true, block: { timer in
            if characterIndex < characterArray.count {
                let char = characterArray[characterIndex]
                myLabel.text! += "\(char)"
                characterIndex += 1
            } else {
                timer.invalidate()
            }
        })
    }

}
