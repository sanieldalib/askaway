//
//  SessionHomeViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/22/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import PopupDialog

class SessionHomeViewController: ButtonBarPagerTabStripViewController {

    var currentSession: Session?
    
    let DB = db()
    
    @IBOutlet weak var topBarLabel: UILabel!
    @IBOutlet weak var topBar: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func xPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func queuePressed(_ sender: Any) {
        DB.addUsertoQueue(user: currentUser!.uid, session: currentSession!.firebaseID) {
            let queueVC: QueueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "queue") as! QueueViewController
            queueVC.refresh()
        }
    }
    @IBAction func questionPressed(_ sender: UIButton) {
        let modalVC = QuestionModalViewController(nibName: "QuestionModalViewController", bundle: nil)
        let popup = PopupDialog(viewController: modalVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        CancelButton.appearance().buttonColor = primaryColor
        let buttonOne = CancelButton(title: "CANCEL", action: nil)
        
        DefaultButton.appearance().buttonColor = primaryColor
        let buttonTwo = DefaultButton(title: "SUBMIT", dismissOnTap: false, action: {
            if let title = modalVC.titleField.text, let questionText = modalVC.questionField.text{
                if title != "" && questionText != ""{
                    modalVC.activityIndicator.startAnimating()
                    var question = Question(title: title, owner: currentUser!.uid, message: questionText)
                    self.DB.addQuestion(question: question, session: self.currentSession!.firebaseID, callback: { (qid) in
                        question.questionID = qid
                        popup.dismiss()
                    })
                } else{
                    popup.shake()
                }
        }
        })
        
        popup.addButtons([buttonOne, buttonTwo])
        
        present(popup, animated: true, completion: {
            print("yo")
        })
    }
    
    @IBOutlet weak var gearButton: UIButton!
    @IBAction func gearPressed(_ sender: Any) {
        let alertController = UIAlertController(title: currentSession!.name, message: "What would you like to do?", preferredStyle: .actionSheet)
        let  deleteButton = UIAlertAction(title: "Delete Session", style: .destructive, handler: { (action) -> Void in
            self.DB.removeSession(session: self.currentSession!.firebaseID, callback: {
                self.dismiss(animated: true, completion: nil)
            })
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    @IBOutlet weak var menuBar: ButtonBarView!
    
    override func viewDidLoad() {
        gearButton.isHidden = currentUser!.uid != currentSession!.ownerUID
        settings.style.buttonBarBackgroundColor = mainColor
        settings.style.buttonBarItemBackgroundColor = mainColor
        //        settings.style.selectedBarBackgroundColor = .white
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
        topBar.backgroundColor = mainColor
        topBarLabel.text = currentSession!.name.uppercased()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "questions")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "queue")
        return [child_1, child_2]
    }
    
    
    
}
