//
//  EViewController.swift
//  Example
//
//  Created by Muhammad Bassio on 3/10/18.
//  Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import UIKit

class EViewController: UIViewController {
  
  @IBInspectable var statusBarStyle:Int = 0 {
    didSet {
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
  @IBInspectable var statusBarHidden:Bool = false {
    didSet {
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle(rawValue: self.statusBarStyle)!
  }
  
  override var prefersStatusBarHidden: Bool {
    return self.statusBarHidden
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

