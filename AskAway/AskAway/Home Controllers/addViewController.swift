//
//  addViewController.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit
import Firebase
import SwiftyShadow
import CoreLocation

class addViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var sessionField: UITextField!
    @IBOutlet weak var passwordSwitch: UISwitch!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func passwordSwitchPressed(_ sender: Any) {
        passwordField.isEnabled = passwordSwitch.isOn
    }
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var questionsSwitch: UISwitch!
    @IBOutlet weak var queueSwitch: UISwitch!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cardView: SwiftyInnerShadowView!
    
    let manager = CLLocationManager()
    let DB = db()
    var sessionLocation: CLLocation?
    var geoCoder = CLGeocoder()
    var continueButton: UIButton!
    var activityView: UIActivityIndicatorView!
    var formFilled = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        cardView.backgroundColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        continueButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        continueButton.setBackgroundColor(color: primaryColor, forUIControlState: .normal)
        continueButton.setBackgroundColor(color: primaryColor, forUIControlState: .disabled)
        continueButton.setTitle("CREATE SESSION", for: .normal)
        continueButton.setTitleColor(disabledColor, for: .disabled)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - 25)
        continueButton.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        view.addSubview(continueButton)
        cardView.layer.cornerRadius = 4
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize.zero
        cardView.layer.shadowOpacity = 0.5
        continueButton.isEnabled = false
        passwordSwitch.setOn(false, animated: false)
        passwordField.isEnabled = false
        
        let tapSwitchGestureRecognier = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapSwitchGestureRecognier.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapSwitchGestureRecognier)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
//        activityView.center = createButton.center
        view.addSubview(activityView)
        
        sessionField.delegate = self
        passwordField.delegate = self
        locationField.delegate = self
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        sessionField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        locationField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if geoCoder.isGeocoding{
            geoCoder.cancelGeocode()
        }
        activityView.stopAnimating()
        sessionField.resignFirstResponder()
        passwordField.resignFirstResponder()
        locationField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldChanged(){
        let sessionName = sessionField.text
        let password = passwordField.text
        let location = locationField.text
        
        if passwordSwitch.isOn {
            formFilled = sessionName != "" && password != "" && location != ""
        } else{
            formFilled = sessionName != "" && location != ""
        }
        continueButton.isEnabled = formFilled
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case sessionField:
            if passwordSwitch.isOn{
                sessionField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            } else {
                sessionField.resignFirstResponder()
                locationField.becomeFirstResponder()
            }
            break
        case passwordField:
            passwordField.resignFirstResponder()
            locationField.becomeFirstResponder()
            break
        case locationField:
            continueButton.sendActions(for: .touchUpInside)
            break
        default:
            break
        }
        return true
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    func keyboardWillDisappear(){
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - 25)
        activityView.center = continueButton.center
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            sessionLocation = location
            toAddress(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func toAddress(location: CLLocation){
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            if error == nil && placemark != nil {
                self.setLocationField(location: (placemark?.first?.name)!)
            } else {
                print(error!)
            }
        }
    }
    
    func setLocationField(location: String){
        locationField.text = location
    }
    
    @objc func handleCreate(){
        continueButton.isEnabled = false
        continueButton.setTitle("", for: .disabled)
        activityView.startAnimating()
        
        if let currentUser = Auth.auth().currentUser{
            var session: Session?
        if sessionLocation != nil && !passwordSwitch.isOn{
            session = Session(name: sessionField.text!, owner: currentUser.uid, location: locationField.text!, locationCL: sessionLocation!)
        } else if sessionLocation != nil && passwordSwitch.isOn{
            session = Session(name: sessionField.text!, owner: currentUser.uid, passcode: passwordField.text!, location: locationField.text!, locationCL: sessionLocation!)
        } else if passwordSwitch.isOn {
            session = Session(name: sessionField.text!, owner: currentUser.uid, passcode: passwordField.text!, location: locationField.text!)
        } else {
            session = Session(name: sessionField.text!, owner: currentUser.uid, location: locationField.text!)
        }
            DB.addSessionDB(session: session!, callback: { (idkey) in
                session?.addID(firebaseID: idkey)
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer){
        sessionField.resignFirstResponder()
        passwordField.resignFirstResponder()
        locationField.resignFirstResponder()
        keyboardWillDisappear()
    }

}
