//
//  FKBarLayout.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

@objc public enum FKBarOrientation:Int {
  case horizontal = 0, vertical = 1
}

public protocol FKBarLayoutDelegate {
  var itemSize:CGSize { get }
  var itemSpacing:CGFloat { get }
  var canScroll:Bool { get }
}

open class FKBarLayout: UICollectionViewLayout {
  var orientation:FKBarOrientation = .horizontal
  var delegate:FKBarLayoutDelegate?
  
  open var layoutAttributes:[UICollectionViewLayoutAttributes] = []
  open var verticalHeight:CGFloat = 80
  
  // cache
  open override func prepare() {
    super.prepare()
    self.layoutAttributes = []
    var yOffset:CGFloat = 0
    var xOffset:CGFloat = 0
    // we only have one section
    if let itemSize = self.delegate?.itemSize, let itemSpacing = self.delegate?.itemSpacing {
      let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)
      for item in 0 ..< numberOfItems {
        let indexPath = IndexPath(item: item, section: 0)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if self.orientation == .horizontal {
          // increase xOffset, yOffset = 0
          attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
          xOffset += itemSize.width + itemSpacing
        }
        else {
          // increase yOffset, xOffset = 0
          attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
          yOffset += itemSize.height + itemSpacing
        }
        self.layoutAttributes.append(attributes)
      }
    }
  }
  
  // clear cache
  open override func invalidateLayout() {
    self.layoutAttributes = []
  }
  
  open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return self.layoutAttributes.filter { $0.frame.intersects(rect) }
  }
  
  open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return self.layoutAttributes.first { $0.indexPath == indexPath }
  }
  
  open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  open override var collectionViewContentSize: CGSize {
    if let cv = self.collectionView {
      if let del = self.delegate {
        if del.canScroll {
          let lastItem = cv.numberOfItems(inSection: 0) - 1
          if let itemAttributes = self.layoutAttributesForItem(at: IndexPath(item: lastItem, section: 0)) {
            return CGSize(width: (itemAttributes.frame.origin.x + itemAttributes.frame.size.width), height: (itemAttributes.frame.origin.y + itemAttributes.frame.size.height))
          }
        }
      }
      return cv.frame.size
    }
    return CGSize.zero
  }
  
  open func layoutKeyForIndexPath(_ indexPath : IndexPath) -> String {
    return "\(indexPath.section)_\(indexPath.row)"
  }
  
}
