//
//  ViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import Firebase
import DGElasticPullToRefresh

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate{

    var DB = db()

    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sessionsTable: UITableView!
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "toSignIn", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseApp.configure()
        
        
        
        if Auth.auth().currentUser != nil{
            performSegue(withIdentifier: "toSignIn", sender: self)
        }
        
        view.backgroundColor = backgroundColor
        addButton.backgroundColor = mainColor
        addButton.setTitleColor(buttonColor, for: .normal)
        sessionsTable.backgroundColor = backgroundColor
        sessionsTable.delegate = self
        sessionsTable.dataSource = self
        topBar.backgroundColor = mainColor

//        navBar.titleTextAttributes = font
        
//        let topBarView = UILabel()
//        topBarView.frame = CGRect(x: 0, y: 0, width: 375, height: 75)
//        topBarView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
//       view.addSubview(topBarView)
//
//
//        let layer1 = CALayer()
//        layer1.backgroundColor = UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1).cgColor
//        layer1.bounds = topBarView.bounds
//        layer1.position = topBarView.center
//        topBarView.layer.addSublayer(layer1)
//
//
//       self.view.addSubview(topBarView)
//        topBarView.translatesAutoresizingMaskIntoConstraints = false

        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        sessionsTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            DispatchQueue.global(qos:.userInitiated).async {
                self?.DB.getSessions {
                    self?.sessionsTable.reloadData()
                    print("Called")
                }
//                print(self?.DB.sessions.count)
            }
            // Do not forget to call dg_stopLoading() at the end
            self?.sessionsTable.dg_stopLoading()
            }, loadingView: loadingView)
        sessionsTable.dg_setPullToRefreshFillColor(UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1))
        sessionsTable.dg_setPullToRefreshBackgroundColor(UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1))
//         Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DB.sessions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(25)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sessions Near You"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sessionsTable.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! sessionCustomCell
        
        cell.nameLabel.text = DB.sessions[indexPath.row]!.name
//        cell.ownerLabel.text = DB.sessions[indexPath.row]!.owner.
        cell.locationLabel.text = DB.sessions[indexPath.row]!.location
        cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        
        return cell
    }

    
    


}

