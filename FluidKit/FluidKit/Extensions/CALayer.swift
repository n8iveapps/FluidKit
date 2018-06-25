//
//  CALayer.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

public extension CALayer {
  // Thanks to https://github.com/robb/hamburger-button
  func ocb_applyAnimation(_ animation: CABasicAnimation) {
    if let copy = animation.copy() as? CABasicAnimation, let keyPath = copy.keyPath {
      
      if copy.fromValue == nil {
        copy.fromValue = self.presentation()?.value(forKeyPath: keyPath)
      }
      
      self.add(copy, forKey: copy.keyPath)
      self.setValue(copy.toValue, forKeyPath:keyPath)
    }
  }
}
