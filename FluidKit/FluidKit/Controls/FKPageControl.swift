//
//  FKPageControl.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 1/30/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

open class FKPageControl: UIPageControl {
  
  /// This is now a Read only property
  open override var currentPage: Int {
    get { return Int(round(progress)) }
    set { /* Read Only */ }
  }
  
  @IBInspectable open var pageCount: Int = 0 { didSet { self.updatePageCount() } }
  @IBInspectable open var progress: CGFloat = 0 { didSet { layoutActivePageIndicator() } }
  
  // MARK: - Appearance
  
  @IBInspectable open var activeTint: UIColor = UIColor.white { didSet { activeLayer.backgroundColor = activeTint.cgColor } }
  @IBInspectable open var inactiveTint: UIColor = UIColor(white: 1, alpha: 0.3) { didSet { inactiveLayers.forEach() { $0.backgroundColor = inactiveTint.cgColor } } }
  @IBInspectable open var indicatorPadding: CGFloat = 10 { didSet { self.refreshLayout() } }
  @IBInspectable open var indicatorRadius: CGFloat = 5 { didSet { self.refreshLayout() } }
  
  
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  
  
  
  
  
  fileprivate var indicatorDiameter: CGFloat {
    return indicatorRadius * 2
  }
  
  fileprivate var inactiveLayers = [CALayer]()
  fileprivate lazy var activeLayer: CALayer = { [unowned self] in
    let layer = CALayer()
    layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.indicatorDiameter, height: self.indicatorDiameter))
    layer.backgroundColor = self.activeTint.cgColor
    layer.cornerRadius = self.indicatorRadius
    layer.actions = [
      "bounds": NSNull(),
      "frame": NSNull(),
      "position": NSNull()]
    return layer
    }()
  
  
  // MARK: - State Update
  fileprivate func updatePageCount() {
    guard self.pageCount != self.inactiveLayers.count else { return }
    // reset current layout
    self.inactiveLayers.forEach() { $0.removeFromSuperlayer() }
    self.inactiveLayers = [CALayer]()
    // add layers for new page count
    self.inactiveLayers = stride(from: 0, to:self.pageCount, by:1).map() { _ in
      let layer = CALayer()
      layer.backgroundColor = self.inactiveTint.cgColor
      self.layer.addSublayer(layer)
      return layer
    }
    self.layoutInactivePageIndicators()
    // ensure active page indicator is on top
    self.layer.addSublayer(self.activeLayer)
    self.layoutActivePageIndicator()
    self.invalidateIntrinsicContentSize()
  }
  
  // MARK: - Layout
  
  fileprivate func refreshLayout() {
    self.layoutInactivePageIndicators()
    self.layoutActivePageIndicator()
    self.invalidateIntrinsicContentSize()
  }
  
  fileprivate func layoutActivePageIndicator() {
    // ignore if progress is outside of page indicators' bounds
    guard self.progress >= 0 && self.progress <= CGFloat(self.pageCount - 1) else { return }
    let activeStart = floor(self.progress)
    let distanceFromPage = self.progress - activeStart
    let activeWidth = self.indicatorDiameter + self.indicatorPadding
    let width = (activeWidth * distanceFromPage) + self.indicatorDiameter
    let newFrame = CGRect(x: (activeStart * activeWidth), y: activeLayer.frame.origin.y, width: width, height: indicatorDiameter)
    self.activeLayer.cornerRadius = self.indicatorRadius
    self.activeLayer.frame = newFrame
  }
  
  fileprivate func layoutInactivePageIndicators() {
    var layerFrame = CGRect(x: 0, y: 0, width: self.indicatorDiameter, height: self.indicatorDiameter)
    self.inactiveLayers.forEach() { layer in
      layer.cornerRadius = self.indicatorRadius
      layer.frame = layerFrame
      layerFrame.origin.x += self.indicatorDiameter + self.indicatorPadding
    }
  }
  
  override open var intrinsicContentSize: CGSize {
    return sizeThatFits(CGSize.zero)
  }
  
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: CGFloat(inactiveLayers.count) * indicatorDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding, height: indicatorDiameter)
  }
  
}

