//
//  FKAnimatableButton.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit


open class FKAnimatableButton: UIButton {
  
  private var layersInitiated:Bool = false
  private var paths:[Int:[Int:CGPath]] = [:]
  public var shapeLayers:[CAShapeLayer] = []
  public var currentState:Int = 0
  
  public func path(for layerIndex:Int, state:Int) -> CGPath? {
    if let layerPaths = self.paths[layerIndex] {
      return layerPaths[state]
    }
    return nil
  }
  
  public func addPath(path:CGPath, for layerIndex:Int, and state:Int) {
    self.paths[layerIndex] = [state : path]
  }
  
  open func initLayers() {
    for lyr in self.shapeLayers {
      lyr.masksToBounds = true
      lyr.fillColor = self.tintColor.cgColor
      lyr.strokeColor = self.tintColor.cgColor
      lyr.strokeStart = 0
      lyr.strokeEnd = 1
      lyr.actions = [
        "strokeStart": NSNull(),
        "strokeEnd": NSNull(),
        "transform": NSNull(),
        "path": NSNull()
      ]
      self.layer.addSublayer(lyr)
    }
  }
  
  open func refreshShapes() {
    for (index, lyr) in self.shapeLayers.enumerated() {
      lyr.masksToBounds = true
      lyr.fillColor = self.tintColor.cgColor
      lyr.strokeColor = self.tintColor.cgColor
      lyr.strokeStart = 0
      lyr.strokeEnd = 1
      
      let layerAnimation = CABasicAnimation(keyPath: "path")
      layerAnimation.toValue = self.path(for: index, state: self.currentState)
      layerAnimation.duration = 0.4
      layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
      layerAnimation.fillMode = kCAFillModeForwards
      layerAnimation.isRemovedOnCompletion = false
      lyr.ocb_applyAnimation(layerAnimation)
    }
  }
  
  open override func layoutSubviews() {
    if !self.layersInitiated {
      self.initLayers()
      self.layersInitiated = true
    }
    self.refreshShapes()
  }
  
}
