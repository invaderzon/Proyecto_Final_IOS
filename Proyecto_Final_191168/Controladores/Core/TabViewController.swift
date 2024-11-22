//
//  TabViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    private func setUpTabs() {
        let personajeVC = PersonajeViewController()
        let locacionVC = LocacionViewController()
        let especiesVC = EspecieViewController()
        let settingsVC = SettingsViewController()
        
        personajeVC.navigationItem.largeTitleDisplayMode = .automatic
        locacionVC.navigationItem.largeTitleDisplayMode = .automatic
        especiesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: personajeVC)
        let nav2 = UINavigationController(rootViewController: locacionVC)
        let nav3 = UINavigationController(rootViewController: especiesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters",
                                       image: UIImage(systemName: "person"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Species",
                                       image: UIImage(systemName: "person.3"),
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(systemName: "gear"),
                                       tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}
