//
//  Int.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/25/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

public extension Int {
  func duplicate4bits() -> Int {
    return (self << 4) + self
  }
}
