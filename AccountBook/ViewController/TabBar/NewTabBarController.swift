//
//  NewTabBarController.swift
//  AccountBook
//
//  Created by Kyoon Ho Park on 2023/07/06.
//

import UIKit

private enum ScreenType: CaseIterable {
    case home
    case action
    case settings
    
    var index: Int {
        switch self {
        case .home: return 0
        case .action: return 1
        case .settings: return 2
        }
    }
    
    var defaultIconImg: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")
        case .action: return UIImage(named: "add_icon")
        case .settings: return UIImage(systemName: "gearshape")
        }
    }
    
    var selectedIconImg: UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house.fill")
        case .action: return UIImage(named: "add_icon")
        case .settings: return UIImage(systemName: "gearshape.fill")
        }
    }
}

internal final class NewTabBarController: UITabBarController {
    
    // MARK: - SYSTEM FUNC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.backgroundColor = .white
        
        // MARK: 홈화면
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
        
        // MARK: 작성화면(화면구색을 위한 임시 화면)
        let viewController = UIViewController()
        
        // MARK: 설정화면
        let reactor = NewSettingsReactor()
        let viewcon = NewSettingsViewController()
        viewcon.bind(reactor: reactor)
        let settingsNavigationViewcon = UINavigationController(rootViewController: viewcon)
        
        self.setViewControllers([homeViewController, viewController, settingsNavigationViewcon], animated: true)
        
        if let tabBarItems = self.tabBar.items {
            tabBarItems.forEach {
                $0.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
            for screenType in ScreenType.allCases {
                tabBarItems[screenType.index].image = screenType.defaultIconImg
                tabBarItems[screenType.index].selectedImage = screenType.selectedIconImg
                tabBarItems[screenType.index].tag = screenType.index
            }
        }
    }
}


// MARK: - UITabBarController Delegate
extension NewTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard tabBarController.tabBar.selectedItem?.tag == ScreenType.action.index else { return true }
        
        let writeBudgetReactor = NewWriteBudgetReactor()
        let writeBudgetViewCon = NewWriteBudgetViewController()
        writeBudgetViewCon.modalPresentationStyle = .fullScreen
        writeBudgetViewCon.bind(reactor: writeBudgetReactor)
        self.present(writeBudgetViewCon, animated: true)
        
        return false
    }
}
