//
//  FKTabBarController.swift
//  FluidKit
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

@objc public protocol FKTabBarControllerDelegate {
  @objc optional func tabBarController(_ tabBarController: FKTabBarController, shouldSelect viewController: UIViewController) -> Bool
  @objc optional func tabBarController(_ tabBarController: FKTabBarController, didSelect viewController: UIViewController)
  @objc optional func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: FKTabBarController) -> UIInterfaceOrientationMask
  @objc optional func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: FKTabBarController) -> UIInterfaceOrientation
  
  @objc optional func tabBarController(_ tabBarController: FKTabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
  @objc optional func tabBarController(_ tabBarController: FKTabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}


open class FKTabBarController: FKContainerController {
  /// The container view controller delegate receiving the protocol callbacks.
  open var delegate:FKTabBarControllerDelegate?
  
  /// The index of the currently selected and visible child view controller.
  open var selectedIndex:Int = -1 {
    willSet {
      if self.selectedIndex > -1 {
        self.previousViewController = self.viewControllers[self.selectedIndex]
      }
    }
    didSet {
      if let del = self.delegate {
        if let shouldSelect = del.tabBarController?(self, shouldSelect: self.selectedViewController!) {
          if shouldSelect {
            self.transition(to: self.viewControllers[self.selectedIndex])
            self.tabBar.selectedIndex = self.selectedIndex
            self.tabBar.reload()
          } else {
            self.selectedIndex = oldValue
          }
        } else {
          self.transition(to: self.viewControllers[self.selectedIndex])
          self.tabBar.selectedIndex = self.selectedIndex
          self.tabBar.reload()
        }
      } else {
        self.transition(to: self.viewControllers[self.selectedIndex])
        self.tabBar.selectedIndex = self.selectedIndex
        self.tabBar.reload()
      }
      self.setNeedsStatusBarAppearanceUpdate()
      self.view.backgroundColor = self.selectedViewController?.view.backgroundColor
    }
  }
  /// The currently selected and visible child view controller.
  open var selectedViewController:UIViewController? {
    if self.selectedIndex >= 0 {
      return self.viewControllers[self.selectedIndex]
    }
    return nil
  }
  private var previousViewController:UIViewController?
  
  
  @IBInspectable open var tabBarHeight:CGFloat = 49
  @IBInspectable open var tabBarWidth:CGFloat = 70
  @IBInspectable open var maxHorizontalWidth:CGFloat = 8000
  
  private var constraintsAdded = false
  private var fkTabBar = FKTabBar(frame: CGRect.zero)
  
  open override var prefersStatusBarHidden: Bool {
    if let svc = self.selectedViewController {
      return svc.prefersStatusBarHidden
    }
    return super.prefersStatusBarHidden
  }
  
  open override var preferredStatusBarStyle: UIStatusBarStyle {
    if let svc = self.selectedViewController {
      return svc.preferredStatusBarStyle
    }
    return super.preferredStatusBarStyle
  }
  
  open var tabBar:FKTabBar {
    return self.fkTabBar
  }
  
  open override var viewControllers: [UIViewController] {
    didSet {
      self.tabBar.items = []
      for vc in self.viewControllers {
        self.tabBar.items.append(vc.tabBarItem)
      }
      self.tabBar.reload()
    }
  }
  
  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if let mask = self.delegate?.tabBarControllerSupportedInterfaceOrientations?(self) {
      return mask
    }
    return super.supportedInterfaceOrientations
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    self.contentView.backgroundColor = UIColor.yellow
    self.tabBar.backgroundColor = UIColor.white
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    self.tabBar.translatesAutoresizingMaskIntoConstraints = false
    self.tabBar.delegate = self
    
    self.view.backgroundColor = UIColor.white
    self.view.isOpaque = true
    self.view.addSubview(self.tabBar)
    
    if self.viewControllers.count > 0 {
      self.selectedIndex = 0
    }
  }
  
  override open func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if self.viewControllers.count < 1 {
      fatalError("tabBar controller should have at least one viewController")
    } else {
      if let vc = self.selectedViewController {
        self.transition(to: vc)
      } else {
        self.selectedIndex = 0
      }
    }
  }
  
  
  open override func layoutSubviews() {
    if self.view.bounds.width > self.maxHorizontalWidth {
      /*let barWidth = self.tabBarWidth + self.contentInsets.left
       
       self.tabBar.frame = CGRect(x: 0, y: (self.view.bounds.height - barHeight), width: self.view.bounds.width, height: barHeight)
       self.tabBar.contentInsets.top = 0
       self.tabBar.contentInsets.bottom = self.contentInsets.bottom
       self.tabBar.contentInsets.left = self.contentInsets.left
       self.tabBar.contentInsets.right = self.contentInsets.right
       
       self.contentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.height - barHeight))*/
    } else {
      let barHeight = self.tabBarHeight + self.contentInsets.bottom
      self.tabBar.frame = CGRect(x: 0, y: (self.view.bounds.height - barHeight), width: self.view.bounds.width, height: barHeight)
      self.tabBar.contentInsets.top = 0
      self.tabBar.contentInsets.bottom = self.contentInsets.bottom
      self.tabBar.contentInsets.left = self.contentInsets.left
      self.tabBar.contentInsets.right = self.contentInsets.right
      self.contentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.height - barHeight))
    }
  }
  
  
  
  open override func transitionAnimator(from currentViewController: UIViewController, to nextViewController: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self.delegate?.tabBarController?(self, animationControllerForTransitionFrom: currentViewController, to: nextViewController)
  }
  
  open override func interactionController(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.delegate?.tabBarController?(self, interactionControllerFor: animator)
  }
  
  
  open func transition(to viewController:UIViewController) {
    if (viewController == self.previousViewController) || (!self.isViewLoaded) {
      return
    }
    self.transition(from: self.previousViewController, to: viewController, completion: nil)
  }
  
  
}

extension FKTabBarController: FKTabBarDelegate {
  public func tabBar(_ tabBar: FKTabBar, didSelectItemAt index: Int) {
    self.selectedIndex = index
  }
  
  
}
