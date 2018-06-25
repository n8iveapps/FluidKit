//
//  UIControl.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

class ClosureSleeve {
  let closure: ()->()
  
  init (_ closure: @escaping ()->()) {
    self.closure = closure
  }
  
  @objc func invoke () {
    closure()
  }
}

public extension UIControl {
  @discardableResult
  public func addClosure(for controlEvents: UIControlEvents, _ closure: @escaping ()->()) -> Self {
    let sleeve = ClosureSleeve(closure)
    addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    return self
  }
}
