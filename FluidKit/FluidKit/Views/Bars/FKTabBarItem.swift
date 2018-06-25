//
//  FKTabBarItem.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKTabBarItem: UITabBarItem {
  
  @IBInspectable open var badgeBackgroundColor:UIColor? = UIColor.red
  @IBInspectable open var badgeTextColor:UIColor? = UIColor.white
  @IBInspectable open var font:UIFont? = UIFont.systemFont(ofSize: 10)
  @IBInspectable open var badgeFont:UIFont? = UIFont.systemFont(ofSize: 10)
  @IBInspectable open var showsEmptyBadge:Bool = false
  
  @available(iOS 9.0, *)
  open override var badgeColor:UIColor? {
    get { return self.badgeBackgroundColor }
    set(newValue) { self.badgeBackgroundColor = newValue }
  }
}
