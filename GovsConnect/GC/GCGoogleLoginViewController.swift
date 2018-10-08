//
//  GCGoogleLoginViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/1.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google

class GCGoogleLoginViewController: UIViewController{
    @IBOutlet var googleLoginButton: GIDSignInButton!
    @IBOutlet var accessCodeTextField: UITextField!
    @IBOutlet var interactionLabel: UILabel!
    @IBOutlet var verifyButton: UIButton!
    var signInError: NSError?
    private var keyboardDismisser: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        GGLContext.sharedInstance()!.configureWithError(self.signInError as! NSErrorPointer)
        if self.signInError != nil{
            NSLog("\(self.signInError!.localizedDescription)")
        }
        GIDSignIn.sharedInstance()!.uiDelegate = self
        self.view.backgroundColor = APP_BACKGROUND_GREY
        self.accessCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.accessCodeTextField.text = ""
        self.accessCodeTextField.delegate = self
        self.interactionLabel.text = ""
        self.verifyButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.verifyButton.setTitleColor(UIColor.gray, for: .disabled)
        self.verifyButton.isEnabled = self.accessCodeTextField.text == "" ? false : true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.accessCodeTextField.text = ""
        self.interactionLabel.text = ""
        self.verifyButton.isEnabled = false
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
    
    @objc func textFieldDidChange(_ sender: UITextField){
        self.verifyButton.isEnabled = sender.text == "" ? false : true
    }
    
    @IBAction func cancelButtonDidClick(_ sender: UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func signInButtonDidClick(_ sender: GIDSignInButton){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cancelButtonDidClick(UIButton())
        }
    }
    
    @IBAction func verifyButtonDidClick(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "Checking access code...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
        AppIOManager.shared.getAccessCodeStatus(accessCode: self.accessCodeTextField.text!, { (isPassed) in
            if isPassed{
                alert.title = "Logging you in as Guest..."
                AppDataManager.shared.currentPersonID = "ranpe001"
                AppIOManager.shared.loginSuccessful({
                    NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        alert.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(Notification(name: AppIOManager.loginActionNotificationName))
                        })
                    }
                }) { (errStr) in
                    alert.dismiss(animated: true){
                        makeMessageViaAlert(title: "Error when logging you in", message: errStr)
                    }
                }
            }else{
                alert.dismiss(animated: false, completion: {
                    //code
                })
                self.interactionLabel.text = "*access code is incorrect"
            }
        }) {
            alert.dismiss(animated: false, completion: {
                self.interactionLabel.text = "*network error"
            })
        }
    }
}

extension GCGoogleLoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addKeyboardDismisser()
    }
}

extension GCGoogleLoginViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
