//
//  Anchor.swift
//  Space Rescue
//
//  Created by GWC2 on 7/25/19.
//  Copyright © 2019 GWC. All rights reserved.
//

import ARKit


enum NodeType: String {
    case dog = "dog"
    case fuel = "fuel"
    case pusheen = "pusheen"
    case nyan = "nyan"
}

class Anchor: ARAnchor {
    var type: NodeType?

}
