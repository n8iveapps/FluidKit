//
//  FKButton.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/26/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKButton: UIButton {
  
  private var tintColors:[UInt:UIColor] = [:]
  private var imageColors:[UInt:UIColor] = [:]
  private var backgroundColors:[UInt:UIColor] = [:]
  
  open var loadingIndicator:UIActivityIndicatorView?
  
  @IBInspectable public var imageViewRenderingMode:UIImageRenderingMode = .automatic {
    didSet {
      self.imageView?.image = self.imageView?.image?.withRenderingMode(self.imageViewRenderingMode)
      self.updateStateChange()
    }
  }
  
  open override var isEnabled: Bool { didSet { self.updateStateChange() } }
  open override var isSelected: Bool { didSet { self.updateStateChange() } }
  open override var isHighlighted: Bool { didSet { self.updateStateChange() } }
  open var isLoading:Bool = false { didSet { self.updateStateChange() } }
  
  public func setTintColor(_ color: UIColor?, for state: UIControlState) {
    self.tintColors[state.rawValue] = color
  }
  
  public func setImageColor(_ color: UIColor?, for state: UIControlState) {
    self.imageColors[state.rawValue] = color
  }
  
  public func setBackgroundColor(_ color: UIColor?, for state: UIControlState) {
    self.backgroundColors[state.rawValue] = color
  }
  
  public func tintColor(for state: UIControlState) -> UIColor? {
    return self.tintColors[state.rawValue]
  }
  
  public func imageColor(for state: UIControlState) -> UIColor? {
    return self.imageColors[state.rawValue]
  }
  
  public func backgroundColor(for state: UIControlState) -> UIColor? {
    return self.backgroundColors[state.rawValue]
  }
  
  
  func updateStateChange() {
    self.backgroundColor = self.backgroundColors[self.state.rawValue]
    self.tintColor = self.tintColors[self.state.rawValue]
    self.imageView?.tintColor = self.tintColor
    self.titleLabel?.textColor = self.tintColor
    if let titleColor = self.titleColor(for: self.state) {
      self.titleLabel?.textColor = titleColor
    }
    if let imageColor = self.imageColor(for: self.state) {
      self.imageView?.tintColor = imageColor
    }
    if self.isLoading {
      self.titleLabel?.isHidden = true
      self.imageView?.isHidden = true
      self.loadingIndicator?.startAnimating()
      if let loadingIndicator = self.loadingIndicator { self.addSubview(loadingIndicator) }
    } else {
      self.titleLabel?.isHidden = false
      self.imageView?.isHidden = false
      self.loadingIndicator?.stopAnimating()
      self.loadingIndicator?.removeFromSuperview()
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    self.loadingIndicator?.center = self.center
  }
  
  @discardableResult
  open func onTap(handler: @escaping () -> Void) -> Self {
    return self.addClosure(for: .touchUpInside, handler)
  }
  
  
}

