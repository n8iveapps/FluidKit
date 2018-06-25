//
//  Array.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/25/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

public extension Array {
  /// Shuffles the Array
  mutating func shuffle() {
    for _ in 0..<count*2 {
      sort { (_,_) in arc4random() < arc4random() }
    }
  }
}
