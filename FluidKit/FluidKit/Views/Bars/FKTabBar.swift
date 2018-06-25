//
//  FKTabBar.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation

import UIKit

public protocol FKTabBarDelegate {
  func tabBar(_ tabBar: FKTabBar, didSelectItemAt index: Int)
}

open class FKTabBar: FKBar, FKBarLayoutDelegate {
  
  open var delegate:FKTabBarDelegate?
  
  /// The color behind the bar item icon.
  open var selectionIndicatorColor:UIColor = UIColor.clear { didSet { self.reload() } }
  
  /// Unselected items in this tab bar will be tinted with this color. default value is Gray
  open var unselectedItemTintColor:UIColor = UIColor.gray { didSet { self.reload() } }
  
  /// Determines how the tabBar position its contents, Default is UITabBarItemPositioningAutomatic.
  open var itemPositioning:UITabBarItemPositioning = .automatic { didSet { self.reload() } }
  
  /// Set the itemSpacing to a positive value to be used between tab bar items.
  open var itemSpacing:CGFloat = 0 { didSet { if self.itemPositioning != .fill { self.reload() } } }
  
  /// Set the itemWidth to a positive value to be used as the width for tab bar items.
  open var itemWidth:CGFloat = 49 { didSet { if self.itemPositioning != .fill { self.reload() } } }
  
  /// Set the itemHeight to a positive value to be used as the height for tab bar items.
  open var itemHeight:CGFloat = 49 { didSet { if self.itemPositioning != .fill { self.reload() } } }
  
  open override var contentInsets: UIEdgeInsets  { didSet { self.reload() } }
  
  /// Determines whether the bar content is scrollable
  open var canScroll: Bool = false
  
  /// The desired size of the tabBar item, determined in reload()
  open var itemSize:CGSize = .zero
  
  open var items:[UITabBarItem] = []
  open var selectedIndex:Int = 0
  private let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: FKBarLayout())
  public var layout:FKBarLayout = FKBarLayout()
  
  open override func tintColorDidChange() {
    self.settings.tintColor = self.tintColor
  }
  
  open override func initBarUI() {
    self.clipsToBounds = false
    self.layer.shadowOffset = CGSize(width: 0, height: -1)
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowRadius = 0
    self.itemSpacing = 0
    self.itemWidth = 64
    self.itemHeight = 70
    self.layout.delegate = self
    self.collectionView.backgroundColor = UIColor.clear
    self.collectionView.collectionViewLayout = self.layout
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.scrollsToTop = false
    self.registerItemViews()
    self.addSubview(self.collectionView)
    self.collectionView.backgroundColor = UIColor.clear
  }
  
  open func registerItemViews() {
    self.collectionView.register(FKTabBarItemView.self, forCellWithReuseIdentifier: "fkTabBarItemView")
  }
  
  open override func reload() {
    self.backgroundColor = self.settings.barTintColor
    if self.settings.isTranslucent {
      self.backgroundColor = self.settings.barTintColor.withAlphaComponent(0.85)
    }
    var width = self.itemWidth
    var height = self.itemHeight
    let numberOfItems = min(self.items.count, 5)
    if self.layout.orientation == .horizontal {
      height = self.bounds.height - (self.contentInsets.top + self.contentInsets.bottom)
      let maxWidth = max((self.itemWidth * CGFloat(numberOfItems) + self.itemSpacing * CGFloat(numberOfItems - 1)), 512)
      let availableWidth = self.bounds.width - (self.contentInsets.left + self.contentInsets.right)
      if maxWidth < availableWidth {
        if self.itemPositioning == .fill {
          self.collectionView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: availableWidth, height: height)
          width = (availableWidth - (self.itemSpacing * CGFloat(numberOfItems - 1))) / CGFloat(numberOfItems)
        } else {
          self.collectionView.frame = CGRect(x: 0, y: self.contentInsets.top, width: maxWidth, height: height)
          self.collectionView.center.x = self.bounds.width / 2
          width = (maxWidth - (self.itemSpacing * CGFloat(numberOfItems - 1))) / CGFloat(numberOfItems)
        }
      } else {
        self.collectionView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: availableWidth, height: height)
        if !self.canScroll {
          width = (availableWidth - (self.itemSpacing * CGFloat(numberOfItems - 1))) / CGFloat(numberOfItems)
        }
      }
    } else {
      width = self.bounds.width - (self.contentInsets.left + self.contentInsets.right)
      let availableHeight = self.bounds.height - (self.contentInsets.top + self.contentInsets.bottom)
      let maxHeight = self.itemHeight * CGFloat(numberOfItems) + self.itemSpacing * CGFloat(numberOfItems - 1)
      if maxHeight < availableHeight {
        if self.itemPositioning == .fill {
          self.collectionView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: width, height: availableHeight)
          height = (availableHeight - (self.itemSpacing * CGFloat(numberOfItems - 1))) / CGFloat(numberOfItems)
        } else {
          self.collectionView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: width, height: maxHeight)
          //self.collectionView.center.y = self.bounds.height / 2
        }
      } else {
        self.collectionView.frame = CGRect(x: self.contentInsets.left, y: self.contentInsets.top, width: width, height: availableHeight)
        if !self.canScroll {
          width = (availableHeight - (self.itemSpacing * CGFloat(numberOfItems - 1))) / CGFloat(numberOfItems)
        }
      }
    }
    self.itemSize = CGSize(width: width, height: height)
    self.collectionView.reloadData()
  }
  
}

extension FKTabBar: UICollectionViewDataSource {
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return min(self.items.count, 5)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fkTabBarItemView", for: indexPath) as! FKTabBarItemView
    let item = self.items[indexPath.item]
    cell.imageView.image = item.image?.withRenderingMode(.alwaysTemplate)
    cell.titleLabel.text = item.title
    cell.layer.borderWidth = 1
    if let fkItem = item as? FKTabBarItem {
      cell.titleLabel.font = fkItem.font
    }
    if indexPath.item == self.selectedIndex {
      cell.titleLabel.textColor = self.settings.tintColor
      cell.imageView.tintColor = self.settings.tintColor
    } else {
      cell.titleLabel.textColor = self.unselectedItemTintColor
      cell.imageView.tintColor = self.unselectedItemTintColor
    }
    return cell
  }
}

extension FKTabBar: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.delegate?.tabBar(self, didSelectItemAt: indexPath.item)
  }
}
