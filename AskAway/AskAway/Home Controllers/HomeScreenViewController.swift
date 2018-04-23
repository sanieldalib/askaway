//
//  HomeScreenViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/20/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class HomeScreenViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "toSignIn", sender: self)
    }
    @IBOutlet weak var menuBar: ButtonBarView!
    
    override func viewDidLoad() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        settings.style.buttonBarBackgroundColor = mainColor
        settings.style.buttonBarItemBackgroundColor = mainColor
        settings.style.buttonBarItemFont = UIFont(name: "Open Sans", size: 14)!
        settings.style.selectedBarBackgroundColor = backgroundColor
        settings.style.selectedBarHeight = 7
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = buttonColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = buttonColor
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
        view.backgroundColor = mainColor
        addButton.backgroundColor = mainColor
        addButton.setTitleColor(buttonColor, for: .normal)
        topBar.backgroundColor = mainColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
        return [child_1, child_2]
    }
    
    
    
}
