//
//  QuestionsViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/22/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import DGElasticPullToRefresh
import SwiftOverlays

class QuestionsViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTable: UITableView!
    
    var DB = db()
    var session: Session?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return DB.answered.count
        default:
            return DB.unanswered.count
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section{
//        case 1:
//            return "Answered Questions"
//        default:
//            return "Unanswered Questions"
//        }
//    }
//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = questionTable.dequeueReusableCell(withIdentifier: "questionHeader") as! questionHeaderViewCell
        
        switch section{
        case 0:
            cell.cellLabel.text = "Answered Questions".uppercased()
        default:
            cell.cellLabel.text = "Unanswered Questions".uppercased()
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTable.delegate = self
        questionTable.dataSource = self
        
        session = db.getCurrentSession()
        
        // Do any additional setup after loading the view.
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        questionTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self!.refresh()
            self?.questionTable.dg_stopLoading()
            }, loadingView: loadingView)
        questionTable.dg_setPullToRefreshFillColor(UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1))
        questionTable.dg_setPullToRefreshBackgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1))
        //         Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionTable.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! sessionCustomCell
        
        switch indexPath.section{
            case 0:
            cell.nameLabel.text = DB.answered[indexPath.row].title
            cell.ownerLabel.text = "\(DB.answered[indexPath.row].firstName) \(DB.answered[indexPath.row].lastName)"
        default:
            cell.nameLabel.text = DB.unanswered[indexPath.row].title
            cell.ownerLabel.text = "\(DB.unanswered[indexPath.row].firstName) \(DB.unanswered[indexPath.row].lastName)"
        }
        
        if currentUser?.uid == session?.ownerUID{
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
            cell.addGestureRecognizer(longPressRecognizer)
        }
        
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        return cell
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "QUESTIONS".uppercased())
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
        DB.getQuestions(session: session!.firebaseID) {
            self.questionTable.reloadData()
        }
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.began {
            let touchPoint = recognizer.location(in: self.view)
            if let indexPath = questionTable.indexPathForRow(at: touchPoint) {
                
                var alertController: UIAlertController?
                var question : Question?
                
                if indexPath.section == 0{
                    alertController = UIAlertController(title: DB.answered[indexPath.row].title, message: "What would you like to do?", preferredStyle: .actionSheet)
                    question = DB.answered[indexPath.row]
                } else {
                    alertController = UIAlertController(title: DB.unanswered[indexPath.row].title, message: "What would you like to do?", preferredStyle: .actionSheet)
                    question = DB.unanswered[indexPath.row]
                }
                

                let  deleteButton = UIAlertAction(title: "Remove Question", style: .destructive, handler: { (action) -> Void in
                    self.DB.removeQuestion(session: self.session!.firebaseID, question: question!.questionID, callback: {
                        self.refresh()
                    })
                })
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                })
                
                alertController!.addAction(deleteButton)
                alertController!.addAction(cancelButton)
                
                self.navigationController!.present(alertController!, animated: true, completion: nil)
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
