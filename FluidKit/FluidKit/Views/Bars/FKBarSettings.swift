//
//  FKBarSettings.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

open class FKBarSettings {
  
  static let defaultBarTintColor = UIColor.white
  static let defaultTintColor = UIColor.red
  static let defaultHeight:CGFloat = 44
  
  open var barTintColor:UIColor = FKBarSettings.defaultBarTintColor
  open var tintColor:UIColor = FKBarSettings.defaultTintColor
  open var image:UIImage?
  open var isTranslucent:Bool = true
  
  open var currentHeight:CGFloat = 44
  open var minimumHeight:CGFloat = 44 { didSet { if self.minimumHeight > self.maximumHeight { self.maximumHeight = self.minimumHeight } } }
  open var maximumHeight:CGFloat = 44 { didSet { if self.minimumHeight > self.maximumHeight { self.minimumHeight = self.maximumHeight } } }
  
}
