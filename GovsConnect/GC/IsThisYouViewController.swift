//
//  IsThisYouViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/1.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import GoogleSignIn

class IsThisYouViewController: UIViewController {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var cardView: UIView!
    var uid: String?{
        didSet{
            let data = AppDataManager.shared.users[uid!]!
            self.profileImageView.image = UIImage.init(data: AppDataManager.shared.profileImageData[self.uid!]!)!
            let spaceIndex = data.name.firstIndex(of: " ")!
            self.firstNameLabel.text = "\(data.name.prefix(upTo: spaceIndex))"
            self.lastNameLabel.text = "\(data.name.suffix(from: data.name.index(after: spaceIndex)))"
            self.confirmButton.setTitle("Yes, login as \(data.name)", for: .normal)
            self.confirmButton.setTitle("Yes, login as \(data.name)", for: .selected)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APP_BACKGROUND_GREY
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.clipsToBounds = true
        self.confirmButton.backgroundColor = APP_THEME_COLOR
        self.confirmButton.setTitleColor(UIColor.white, for: .normal)
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderColor = APP_THEME_COLOR.cgColor
        self.cancelButton.layer.borderWidth = 1
        self.cancelButton.clipsToBounds = true
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.width / 2
        self.cardView.backgroundColor = UIColor.white
        self.cardView.layer.cornerRadius = 20
        self.cardView.clipsToBounds = true
    }

    @IBAction func confirmButtonDidClick(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: "Logging you in...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
        AppIOManager.shared.loginSuccessful(target_uid: self.uid!, {(isAgreeToTerms: Bool) in
            if !isAgreeToTerms{
                alert.dismiss(animated: true, completion: {
                    let termsAlert = UIAlertController(title: "Important things before posting", message: "The posting function of Govs Connect allows everyone to freely post and instantly share ideas with the entire Govs community. However, some contents are not allowed to be presented on the platform, including but not limited to: terrorism, violence, pornography and etc. Also, your posts and replies must follow the school rules. Please be nice to each others. To proceed using our service, please tap \"I agree\" below.", preferredStyle: .alert)
                    termsAlert.addAction(UIAlertAction(title: "Screw you, I don't agree", style: .default, handler: { (alertAction) in
                        //don't agree action
                        AppDataManager.shared.currentPersonID = ""
                        self.cancelButtonDidClick(self.cancelButton)
                    }))
                    termsAlert.addAction(UIAlertAction(title: "I agree", style: .cancel, handler: { (alertAction) in
                        //agree action
                        let alertAgain = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                        loadingIndicator.hidesWhenStopped = true
                        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                        loadingIndicator.startAnimating();
                        alertAgain.view.addSubview(loadingIndicator)
                        self.present(alertAgain, animated: true, completion: nil)
                        AppIOManager.shared.userAgree(uid: AppDataManager.shared.currentPersonID, {
                            //completion handler
                           NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alertAgain.dismiss(animated: true, completion: {
                                    NotificationCenter.default.post(Notification(name: AppIOManager.loginActionNotificationName))
                                })
                            }
                        }, { (errStr) in
                            //error handler
                            alertAgain.dismiss(animated: true, completion: {
                                let errorAlert = UIAlertController(title: "Error when agreeing with services", message: errStr, preferredStyle: .alert)
                                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                                self.present(errorAlert, animated: true, completion: nil)
                            })
                        })
                    }))
                    self.present(termsAlert, animated: true, completion: nil)
                })
                return
            }
            AppDataManager.shared.currentPersonID = self.uid!
            NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(Notification(name: AppIOManager.loginActionNotificationName))
                })
            }
        }) { (errStr) in
            alert.dismiss(animated: true){
                let errorAlert = UIAlertController(title: "Error when logging you in", message: errStr, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonDidClick(_ sender: UIButton){
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: true) {
            //code
        }
    }
}
