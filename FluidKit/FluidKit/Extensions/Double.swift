//
//  Double.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/25/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

public extension Double {
  /// Rounds the double to decimal places value
  func roundTo(places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
