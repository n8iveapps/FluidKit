//
//  FKBar.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKBar: UIView {
  
  open var settings:FKBarSettings = FKBarSettings() { didSet { self.reload() } }
  open var contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) { didSet { self.reload() } }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.initBarUI()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initBarUI()
  }
  
  /// Initializes the bar interface.
  open func initBarUI() { }
  
  /// Reloads the bar UI.
  open func reload() { }
  
  open override func layoutSubviews() {
    self.reload()
  }
  
}
