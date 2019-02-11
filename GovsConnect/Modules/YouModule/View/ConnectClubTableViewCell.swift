//
//  ConnectClubTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/5.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class ConnectClubTableViewCell: UITableViewCell {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var disconnectButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.connectButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.connectButton.addTarget(self, action: #selector(self.connectButtonDidClick(_:)), for: .touchDown)
        self.disconnectButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.disconnectButton.addTarget(self, action: #selector(self.disconnectButtonDidClick(_:)), for: .touchDown)
        self.collectionView.clipsToBounds = true
        self.collectionView.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.collectionView.layer.cornerRadius = 10
        self.collectionView.register(UINib.init(nibName: "MultiMediaCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MULTI_MEDIA_COLLECTIONVIEW_CELL_ID")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc func connectButtonDidClick(_ sender: UIButton){
        let alert = UIAlertController(title: "Connect to an organization", message: "Please enter the passphrase that designates to the organization. If you don't know, please contact the head of the organization.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "passphrase"
            textField.keyboardType = .asciiCapable
        })
        alert.addAction(UIAlertAction(title: "connect", style: .default, handler: { (alertController) in
            let passphrase = alert.textFields!.first!.text!
            let loadingAlert = UIAlertController(title: nil, message: "Connecting...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            loadingAlert.view.addSubview(loadingIndicator)
            UIApplication.shared.keyWindow!.rootViewController!.present(loadingAlert, animated: true, completion: nil)
            AppIOManager.shared.connectToOrganization(passphrase: passphrase, { (pass, uid) in
                if pass{
                    if AppDataManager.shared.currentUserConnections.contains(uid!){
                        loadingAlert.dismiss(animated: true, completion: {
                            makeMessageViaAlert(title: "You have already connected to \(AppDataManager.shared.users[uid!]!.name)", message: "")
                        })
                        return
                    }
                    AppDataManager.shared.currentUserConnections.append(uid!)
                    self.collectionView.reloadData()
                    loadingAlert.dismiss(animated: true, completion: nil)
                    return
                }
                //passphrase error, not passed
                loadingAlert.dismiss(animated: true, completion: {
                    makeMessageViaAlert(title: "Passphrase is incorrect", message: "please try again")
                })
            }, { (errText) in
                loadingAlert.dismiss(animated: true, completion: {
                    makeMessageViaAlert(title: "Error when connecting to an organization", message: errText)
                })
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true) {
            //code
        }
    }
    
    @objc func disconnectButtonDidClick(_ sender: UIButton){
        guard AppDataManager.shared.currentUserConnections.count > 0 else{
            makeMessageViaAlert(title: "You have no organization to disconnect", message: "")
            return
        }
        let optionsAlert = UIAlertController(title: "Disconnet to", message: nil, preferredStyle: .actionSheet)
        let alertOptionHandler = { (index: Int) in
            { (action: UIAlertAction!) -> Void in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
                    let loadingAlert = UIAlertController(title: nil, message: "Disconnecting...", preferredStyle: .alert)
                    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                    loadingIndicator.hidesWhenStopped = true
                    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                    loadingIndicator.startAnimating();
                    loadingAlert.view.addSubview(loadingIndicator)
                    UIApplication.shared.keyWindow!.rootViewController!.present(loadingAlert, animated: true, completion: nil)
                    AppIOManager.shared.disconnectToOrganization(org: AppDataManager.shared.currentUserConnections[index], { (pass) in
                        //completion
                        if pass{
                            AppDataManager.shared.currentUserConnections.remove(at: index)
                            self.collectionView.reloadData()
                            loadingAlert.dismiss(animated: true, completion: nil)
                            return
                        }
                        loadingAlert.dismiss(animated: true){
                            makeMessageViaAlert(title: "Disconnect failed", message: "please try again later")
                        }
                    }, { (errorStr) in
                        //err completion
                        loadingAlert.dismiss(animated: true){
                            makeMessageViaAlert(title: "Error when disconnecting", message: errorStr)
                        }
                    })
                }
            }
        }
        for i in stride(from: 0, to: AppDataManager.shared.currentUserConnections.count, by: 1){
            let cur_org_id = AppDataManager.shared.currentUserConnections[i]
            let action = UIAlertAction(title: AppDataManager.shared.users[cur_org_id]!.name, style: .default, handler: alertOptionHandler(i))
            optionsAlert.addAction(action)
        }
        optionsAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow!.rootViewController!.present(optionsAlert, animated: true) {
            //completion code
        }
    }
}

extension ConnectClubTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.titleLabel.text = "Organizations you have connected to: \(AppDataManager.shared.currentUserConnections.count)"
        return AppDataManager.shared.currentUserConnections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MULTI_MEDIA_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MultiMediaCollectionViewCell
        let data = AppDataManager.shared.users[AppDataManager.shared.currentUserConnections[indexPath.item]]!
        cell.centerImageView.image = UIImage.init(data: AppDataManager.shared.profileImageData[data.uid]!)!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}
