//
//  TabViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red
        setUpTabs()
    }
    
    private func setUpTabs(){
        let classesVC = ClassViewController()
        let racesVC = RacesViewController()
        let monstersVC = MonsterViewController()
        let settingsVC = SettingsViewController()
        
        classesVC.navigationItem.largeTitleDisplayMode = .automatic
        monstersVC.navigationItem.largeTitleDisplayMode = .automatic
        racesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: classesVC)
        let nav2 = UINavigationController(rootViewController: racesVC)
        let nav3 = UINavigationController(rootViewController: monstersVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Classes",
                                       image: nil,
                                       tag: 1)
        
        nav2.tabBarItem = UITabBarItem(title: "Races",
                                       image: nil,
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Monsters",
                                   image: nil,
                                   tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: nil,
                                       tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(
            [nav1, nav2, nav3, nav4],
            animated: true)
    }
}
