//
//  ViewController.swift
//  AccountBook
//
//  Created by 박균호 on 8/5/20.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var homeViewController: HomeViewController!
    var actionViewController: ActionViewController!
    var settingViewController: NewSettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

}
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let tag = tabBarController.tabBar.selectedItem?.tag
        
        switch tag {
        case 0, 2:
            return true
        case 1:
            guard let actionViewController = storyboard?.instantiateViewController(withIdentifier: "ActionViewController") else { return true }
            actionViewController.modalPresentationStyle = .fullScreen
            self.present(actionViewController, animated: true, completion: nil)
            return false
        default:
            return true
        }
    }
}
