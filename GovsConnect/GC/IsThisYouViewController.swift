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
        AppDataManager.shared.currentPersonID = self.uid!
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
    }
    
    @IBAction func cancelButtonDidClick(_ sender: UIButton){
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: true) {
            //code
        }
    }
}
