//
//  ViewController.swift
//  AccountBook
//
//  Created by James Kim on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var homeViewController: HomeViewController!
    var actionViewController: ActionViewController!
    var settingViewController: SettingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController")
        actionViewController = storyboard?.instantiateViewController(identifier: "ActionViewController")
        settingViewController = storyboard?.instantiateViewController(identifier: "SettingViewController")
        
        homeViewController.tabBarItem.title = "home"
        actionViewController.tabBarItem.image = .add
        settingViewController.tabBarItem.title = "setting"
        
        self.setViewControllers([homeViewController, actionViewController, settingViewController], animated: true)
    }

}
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.tabBar.selectedItem?.tag == 1 {
            if let storyboard = storyboard?.instantiateViewController(identifier: "ActionViewController") {
                storyboard.modalPresentationStyle = .formSheet
                self.present(storyboard, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
