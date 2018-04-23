//
//  child1ViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/18/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DGElasticPullToRefresh
import Firebase
import SwiftOverlays
import PopupDialog

class child1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider{
    
    var DB = db()
    
    @IBOutlet weak var sessionsTable: UITableView!
    
    var passwordVC: PasswordModalViewController?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL Sessions".uppercased())
    }
    
    
    override func viewDidLoad() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        super.viewDidLoad()
        
        DB.sessions.removeAll()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        passwordVC = PasswordModalViewController(nibName: "PasswordModalViewController", bundle: nil)
        loadingView.tintColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        sessionsTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            self?.refresh()
            // Do not forget to call dg_stopLoading() at the end
            self?.sessionsTable.dg_stopLoading()
            }, loadingView: loadingView)
        sessionsTable.dg_setPullToRefreshFillColor(UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1))
        sessionsTable.dg_setPullToRefreshBackgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1))
        //         Do any additional setup after loading the view, typically from a nib.
        
        sessionsTable.backgroundColor = backgroundColor
        sessionsTable.delegate = self
        sessionsTable.dataSource = self
        
        if Auth.auth().currentUser != nil {
            showWaitOverlay()
            if currentUser == nil {
                self.DB.getUser(uid: Auth.auth().currentUser!.uid)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil{
            performSegue(withIdentifier: "toSignIn", sender: self)
            print("No one sighed in")
        } else {
            refresh()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "questionHeader") as! questionHeaderViewCell
        
        switch section{
        case 0:
            cell.cellLabel.text = "Available Sessions".uppercased()
        default:
            cell.cellLabel.text = "Available Sessions".uppercased()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! sessionCustomCell
        
        cell.nameLabel.text = DB.sessions[indexPath.row]!.name.uppercased()
        cell.ownerLabel.text = "\(DB.sessions[indexPath.row]!.ownerProf!.firstName) \(DB.sessions[indexPath.row]!.ownerProf!.lastName)"
        cell.locationLabel.text = DB.sessions[indexPath.row]!.location
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if DB.sessions[indexPath.row]?.passcode == "" || (DB.sessions[indexPath.row]?.members.contains(currentUser!.uid))! {
            performSegue(withIdentifier: "toSession", sender: self)
        } else{
            let session = DB.sessions[indexPath.row]
            let popup = PopupDialog(viewController: passwordVC!, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
            passwordVC?.passwordField.text = ""
            
            CancelButton.appearance().buttonColor = primaryColor
            let buttonOne = CancelButton(title: "CANCEL", action: nil)
            
            DefaultButton.appearance().buttonColor = primaryColor
            let buttonTwo = DefaultButton(title: "SUBMIT", dismissOnTap: false, action: {
                self.passwordVC!.activityIndicator.startAnimating()
                if let passwordText = self.passwordVC!.passwordField.text{
                    if passwordText == session?.passcode{
                        self.DB.addMembertoSession(session: session!, personUID: currentUser!.uid, callback: {
                            self.passwordVC!.activityIndicator.stopAnimating()
                            popup.dismiss(animated: true, completion: {
                                self.performSegue(withIdentifier: "toSession", sender: self)
                            })
                        })
                    } else {
                        self.passwordVC!.activityIndicator.stopAnimating()
                        popup.shake()
                    }
                } else {
                    self.passwordVC!.activityIndicator.stopAnimating()
                    popup.shake()
                }
            })
            
            popup.addButtons([buttonOne, buttonTwo])
            
            present(popup, animated: true, completion: {
                print("yo")
            })
        }
    }
    
    func refresh() {
        DB.getSessions {
            self.sessionsTable.reloadData()
            self.removeAllOverlays()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sessionsTable.indexPathForSelectedRow{
            let row = index.row
            if let navVC = segue.destination as? UINavigationController{
                let sessionVC = navVC.viewControllers.first as! SessionHomeViewController
                db.setCurrentSession(session: DB.sessions[row]!)
                sessionVC.currentSession = DB.sessions[row]
            }
        }
    }
}

