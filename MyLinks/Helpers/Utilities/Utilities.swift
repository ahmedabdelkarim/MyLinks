//
//  Utilities.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/9/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
  class func subviewsOfView(view: UIView, withType type: String) -> [UIView]
  {
    let prefix = "<\(type)"
    var subviewArray = view.subviews.flatMap { subview in subviewsOfView(view: subview, withType: type) }

    if view.description.hasPrefix(prefix) {
      subviewArray.append(view)
    }
    
    return subviewArray
  }
}

