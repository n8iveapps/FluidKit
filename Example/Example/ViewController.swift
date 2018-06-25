//
//  ViewController.swift
//  Example
//
//  Created by Muhammad Bassio on 3/4/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit
import FluidKit

class ViewController: FKTabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let vc1 = UIViewController()
    vc1.view.backgroundColor = UIColor.green
    vc1.title = "Green"
    
    let vc2 = UIViewController()
    vc2.view.backgroundColor = UIColor.yellow
    vc2.title = "Yellow"
    
    let vc3 = UIViewController()
    vc3.view.backgroundColor = UIColor.red
    vc3.title = "Red"
    
    let vc4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grayVC")
    let vc5 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "redVC")
    
    
    self.viewControllers = [vc1, vc4, vc5]
    self.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}


extension ViewController: FKTabBarControllerDelegate {
  func tabBarController(_ tabBarController: FKTabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return FKFadeTransitioning()
  }
}
