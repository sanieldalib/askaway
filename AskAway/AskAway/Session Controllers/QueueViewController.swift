//
//  QueueViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/22/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DGElasticPullToRefresh

class QueueViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource{
    
    var DB = db()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.queueProfile.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = queueTable.dequeueReusableCell(withIdentifier: "queueHeader") as! queueHeaderViewCell
        
        cell.titleLabel.text = "CURRENT QUEUE".uppercased()
        cell.waitingLabel.text = "(\(DB.queueProfile.count) WAITING)".uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = queueTable.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! queueCell
        
        cell.nameLabel.text = "\(DB.queueProfile[indexPath.row].firstName) \(DB.queueProfile[indexPath.row].lastName)"
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        if currentUser?.uid == session?.ownerUID{
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
            cell.addGestureRecognizer(longPressRecognizer)
        }
        
        return cell
    }
    
    
    
    @IBOutlet weak var queueTable: UITableView!
    
    var session: Session?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "QUEUE".uppercased())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queueTable.delegate = self
        queueTable.dataSource = self
        
        session = db.getCurrentSession()
        
        
        // Do any additional setup after loading the view.
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        queueTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.refresh()
            self?.queueTable.dg_stopLoading()
            }, loadingView: loadingView)
        queueTable.dg_setPullToRefreshFillColor(UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1))
        queueTable.dg_setPullToRefreshBackgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1))
        //         Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh()
    }
    
    func refresh(){
        DB.getQueue(session: session!.firebaseID) {
            self.queueTable.reloadData()
        }
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.began {
            let touchPoint = recognizer.location(in: self.view)
            if let indexPath = queueTable.indexPathForRow(at: touchPoint) {
                let alertController = UIAlertController(title: "\(DB.queueProfile[indexPath.row].firstName) \(DB.queueProfile[indexPath.row].lastName)", message: "What would you like to do?", preferredStyle: .actionSheet)
                
                let  deleteButton = UIAlertAction(title: "Remove from Queue", style: .destructive, handler: { (action) -> Void in
                    self.DB.queueProfile.remove(at: indexPath.row)
                    self.DB.queue.remove(at: indexPath.row)
                    self.DB.updateQueue(session: self.session!.firebaseID, callback: {
                        self.refresh()
                    })
                })
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                })
                
                alertController.addAction(deleteButton)
                alertController.addAction(cancelButton)
                
                self.navigationController!.present(alertController, animated: true, completion: nil)
            }
        }
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
