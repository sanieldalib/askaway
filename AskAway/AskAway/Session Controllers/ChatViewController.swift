//
//  ChatViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/23/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SwiftOverlays

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentSession: Session?
    var currentQuestion: Question?
    var DB = db()
    
    @IBAction func xPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendPressed(_ sender: Any) {
        if messageField.text != ""{
        if  currentUser!.uid == currentQuestion!.ownerID || currentUser!.uid == currentSession!.ownerUID{
            let mes = [currentUser!.uid : messageField.text!]
            currentQuestion?.messages.append(mes)
            showWaitOverlayWithText("Sending your message")
            DB.updateMessages(question: currentQuestion!, session: currentSession!.firebaseID, callback: {
                removeAllOverlays()
                messageField.text = ""
                messageTable.reloadData()
            })
        }
        }
    }
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var topLabel: UILabel!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion!.messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = messageTable.dequeueReusableCell(withIdentifier: "questionHeader") as! questionHeaderViewCell
        
        cell.cellLabel.text = "MESSAGES FOR \(currentQuestion!.title)".uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message = currentQuestion!.messages[indexPath.row]
        var cell : MessageCell!
        
        if currentQuestion!.ownerID == currentUser?.uid {
            if let mes = message[currentQuestion!.ownerID]{
                let firstName = currentQuestion!.firstName
                let lastName = currentQuestion!.lastName
                cell = messageTable.dequeueReusableCell(withIdentifier: "sentMessage", for: indexPath) as! MessageCell
                cell.initialsLabel.text = "\(firstName.characters.first!)\(lastName.characters.first!)".uppercased()
                cell.nameLabel.text = "\(firstName) \(lastName)"
                cell.messageText.text = mes
            } else {
                let mes = message[currentSession!.ownerUID]
                let firstName = currentSession!.ownerProf!.firstName
                let lastName = currentSession!.ownerProf!.lastName
                
                cell = messageTable.dequeueReusableCell(withIdentifier: "recMessage", for: indexPath) as! MessageCell
                cell.initialsLabel.text = "\(firstName.characters.first!)\(lastName.characters.first!)".uppercased()
                cell.nameLabel.text = "\(firstName) \(lastName)"
                cell.messageText.text = mes
            } } else {
            if let mes = message[currentSession!.ownerUID]{
                    let firstName = currentSession!.ownerProf!.firstName
                    let lastName = currentSession!.ownerProf!.lastName

                    cell = messageTable.dequeueReusableCell(withIdentifier: "sentMessage", for: indexPath) as! MessageCell
                    cell.initialsLabel.text = "\(firstName.characters.first!)\(lastName.characters.first!)".uppercased()
                    cell.nameLabel.text = "\(firstName) \(lastName)"
                    cell.messageText.text = mes
                } else {
                        let mes = message[currentQuestion!.ownerID]
                    let firstName = currentQuestion!.firstName
                    let lastName = currentQuestion!.lastName
                        
                    cell = messageTable.dequeueReusableCell(withIdentifier: "recMessage", for: indexPath) as! MessageCell
                    cell.initialsLabel.text = "\(firstName.characters.first!)\(lastName.characters.first!)".uppercased()
                    cell.nameLabel.text = "\(firstName) \(lastName)"
                    cell.messageText.text = mes
            }
        }
        return cell
    }
    

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var messageTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTable.dataSource = self
        messageTable.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        messageTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            self?.refresh()
            // Do not forget to call dg_stopLoading() at the end
            self?.messageTable.dg_stopLoading()
            }, loadingView: loadingView)
        messageTable.dg_setPullToRefreshFillColor(UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1))
        messageTable.dg_setPullToRefreshBackgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1))
        //         Do any additional setup after loading the view, typically from a nib.
        
        messageTable.backgroundColor = backgroundColor
        
        messageTable.rowHeight = UITableViewAutomaticDimension
        topLabel.text = currentQuestion!.title
        messageTable.estimatedRowHeight = 140

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(){
        DB.updateMessages(question: currentQuestion!, session: currentSession!.firebaseID) {
            self.messageTable.reloadData()
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        messageField.resignFirstResponder()
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
