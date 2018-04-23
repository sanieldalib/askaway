//
//  child2ViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/18/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DGElasticPullToRefresh

class child2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider{
    
    var DB = db()
    
    var isFirstLoad = true
    
    
    @IBOutlet weak var sessionsTable: UITableView!
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "My sessions".uppercased())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad{
            showWaitOverlay()
        }
        isFirstLoad = false
        refresh()
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
        
        cell.cellLabel.text = "My sessions".uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(DB.userSessions.count)
        return DB.userSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! sessionCustomCell
        
        cell.nameLabel.text = DB.userSessions[indexPath.row].name.uppercased()
        cell.ownerLabel.text = "\(DB.userSessions[indexPath.row].ownerProf!.firstName) \(DB.userSessions[indexPath.row].ownerProf!.lastName)"
        cell.locationLabel.text = DB.userSessions[indexPath.row].location
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        return cell
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let index = sessionsTable.indexPathForSelectedRow{
    //            let row = index.row
    //            print("pressed")
    //            let sessionVC = segue.destination as? SessionHomeViewController
    //            sessionVC?.currentSession = DB.sessions[row]
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toSession", sender: self)
    }
    
    func refresh() {
        DB.getUserRooms {
            self.sessionsTable.reloadData()
            self.removeAllOverlays()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sessionsTable.indexPathForSelectedRow{
            let row = index.row
            if let navVC = segue.destination as? UINavigationController{
                let sessionVC = navVC.viewControllers.first as! SessionHomeViewController
                db.setCurrentSession(session: DB.userSessions[row])
                sessionVC.currentSession = DB.userSessions[row]
            }
        }
    }
}


