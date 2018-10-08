//
//  GCLoginViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/8/29.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class GCLoginViewController: UIViewController {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var feedbackLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    private var keyboardDismisser: UITapGestureRecognizer?
    var currentCombination: (username: String, password: String, uid: String) = ("", "", "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APP_BACKGROUND_GREY
        self.loginButton.isEnabled = false
        self.usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.loginButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.loginButton.setTitleColor(APP_BACKGROUND_GREY, for: .disabled)
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func addKeyboardDismisser(){
        guard self.keyboardDismisser == nil else {
            return
        }
         self.keyboardDismisser = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        self.view.addGestureRecognizer(self.keyboardDismisser!)
    }
    
    func removeKeyboardDismisser(){
        guard self.keyboardDismisser != nil else{
            return
        }
        self.view.removeGestureRecognizer(self.keyboardDismisser!)
        self.keyboardDismisser = nil
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        self.removeKeyboardDismisser()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if !isValidEmail(self.usernameTextField.text ?? ""){
            self.feedbackLabel.text = "*username is not valid"
            self.loginButton.isEnabled = false
            return
        }
        if self.passwordTextField.text!.count > 0{
            self.feedbackLabel.text = ""
            self.loginButton.isEnabled = true
            return
        }
        self.feedbackLabel.text = "*password cannot be empty"
        self.loginButton.isEnabled = false
    }
    
    @IBAction func cancelButtonDidClick(_ sender: UIButton){
        self.dismiss(animated: true) {
            //code
        }
    }
    
    @IBAction func loginButtonDidClick(_ sender: UIButton){
        if self.usernameTextField.text! != self.currentCombination.username{
            //enter a differnt email. need online verification
            AppIOManager.shared.getLogin(email: self.usernameTextField.text!) { (password, uid) in
                if password == nil{
                    //email wrong
                    self.feedbackLabel.text = "the email/password is incorrect"
                }else{
                    self.currentCombination = (self.usernameTextField.text!, password!, uid!)
                    self.authenticate()
                }
            }
            return
        }
        //only local verafication needed
        self.authenticate()
    }
    
    private func authenticate(){
        assert(self.usernameTextField.text! == self.currentCombination.username)
        assert(self.currentCombination.uid != "")
        if self.passwordTextField.text! != self.currentCombination.password{
            //password is wrong
            self.feedbackLabel.text = "the email/password is incorrect"
            return
        }
        //password is correct
        AppDataManager.shared.currentPersonID = self.currentCombination.uid
        //AppIOManager.shared.loginSuccessful()
        NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
        NotificationCenter.default.post(Notification(name: AppIOManager.loginActionNotificationName))
    }
    
    @IBAction func whatISButtonDidClick(_ sender: UIButton){
        let alert = UIAlertController(title: "What is my username/password?", message: "Your username/password is the same as your Veracross username/password. If you would like to change your username/password, please change it on Veracross (and it will automatically changes here).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension GCLoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addKeyboardDismisser()
    }
}
