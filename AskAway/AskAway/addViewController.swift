//
//  addViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import Firebase

class addViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ownerField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var questionsSwitch: UISwitch!
    @IBOutlet weak var queueSwitch: UISwitch!
    
    @IBAction func createPressed(_ sender: UIButton) {
        if (nameField.text! != "" && ownerField.text! != "" && locationField.text! != ""){
            let session1 = Session(name: nameField.text!, owner: (Auth.auth().currentUser?.uid)!, location: locationField.text!, questionsOn: questionsSwitch.isOn, queueOn: queueSwitch.isOn)
        
        db().addSessionDB(session: session1)
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        questionsSwitch.onTintColor = UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 0.91)
        questionsSwitch.thumbTintColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        questionsSwitch.tintColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        queueSwitch.onTintColor = UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 0.91)
        createButton.backgroundColor = UIColor(red: 0.22, green: 0.24, blue: 0.28, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
