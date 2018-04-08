//
//  ViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var names = ["Daniel", "Min", "Jeffrey"]
    var sessions = ["CIS 160 OFFICE HOURS", "CIS 120 OFFICE HOURS", "CIS 110 OFFICE HOURS"]

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sessionsTable: UITableView!
    
    @IBAction func addPressed(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        view.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1)
        sessionsTable.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        
        sessionsTable.delegate = self
        sessionsTable.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(3)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! sessionCustomCell
        
        cell.nameLabel.text = sessions[indexPath.row]
        cell.ownerLabel.text = names[indexPath.row]
        cell.locationLabel.text = "University of Pennsylvania"        
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        return cell
    }
    
    


}

