//
//  NewPostViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/12.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    @IBOutlet var postButton: UIButton!
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var postTitleTextBox: UITextView!
    @IBOutlet var postBodyTextBox: UITextView!
    @IBOutlet var titleCounterLabel: UILabel!
    @IBOutlet var imageCounterLabel: UILabel!
    @IBOutlet var multiMediaCollectionView: UICollectionView!
    @IBOutlet var selectImageButton: UIButton!
    @IBOutlet var takeImageButton: UIButton!
    var pendingImages = Array<UIImage>()
    var previousLine = 1
    var imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorImage.image = UIImage.init(named: AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.profilePictureName)
        self.postButton.layer.backgroundColor = APP_THEME_COLOR.cgColor
        self.postButton.layer.cornerRadius = 13
        self.postButton.tintColor = UIColor.white
        self.postButton.setAttributedTitle(NSAttributedString(string: "Post", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
        self.postButton.isEnabled = false
        self.postButton.alpha = 0.6
        self.postTitleTextBox.delegate = self
        self.postTitleTextBox.textContainer.lineBreakMode = .byTruncatingTail
        self.postTitleTextBox.textContainer.maximumNumberOfLines = 0
        self.postBodyTextBox.textContainer.lineBreakMode = .byTruncatingTail
        self.postBodyTextBox.textContainer.maximumNumberOfLines = 0
        self.postBodyTextBox.delegate = self
        if AppDataManager.shared.newPostDraft != nil{
            self.postTitleTextBox.text = AppDataManager.shared.newPostDraft!.0
            self.postBodyTextBox.text = AppDataManager.shared.newPostDraft!.1
            self.pendingImages = AppDataManager.shared.newPostDraft!.2
            AppDataManager.shared.newPostDraft = nil
        }else{
            self.postTitleTextBox.text = "Your Title Here"
            self.postBodyTextBox.text = "What's Happening?"
            self.postTitleTextBox.textColor = UIColor.lightGray
            self.postBodyTextBox.textColor = UIColor.lightGray
        }
        self.multiMediaCollectionView.register(UINib.init(nibName: "MultiMediaCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MULTI_MEDIA_COLLECTIONVIEW_CELL_ID")
        let layout = self.multiMediaCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 45, height: 45)
        self.multiMediaCollectionView.delegate = self
        self.multiMediaCollectionView.dataSource = self
        self.multiMediaCollectionView.allowsSelection = true
        self.multiMediaCollectionView.allowsMultipleSelection = false
        self.selectImageButton.layer.cornerRadius = 15
        self.takeImageButton.layer.cornerRadius = 15
        self.selectImageButton.clipsToBounds = true
        self.takeImageButton.clipsToBounds = true
        self.imagePickerController.delegate = self
        self.updateImageCounterLabel()
        self.setPostButtonState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func goToPreviousView(){
        self.dismiss(animated: true) {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func updateImageCounterLabel(){
        let count = self.pendingImages.count
        self.imageCounterLabel.text = "\(count)/9"
        if count == 9{
            self.selectImageButton.isEnabled = false
            self.takeImageButton.isEnabled = false
        }else{
            self.selectImageButton.isEnabled = true
            self.takeImageButton.isEnabled = true
        }
    }
    
    func setPostButtonState(){
        if self.postTitleTextBox.text == "Your Title Here" || self.postBodyTextBox.text == "What's Happening?"{
            self.postButton.isEnabled = false
            self.postButton.alpha = 0.6
            return
        }
        if self.postTitleTextBox.text.count <= 0 || self.postTitleTextBox.text.count > 80 || self.postBodyTextBox.text.count <= 0{
            self.postButton.isEnabled = false
            self.postButton.alpha = 0.6
            self.titleCounterLabel.textColor = APP_THEME_COLOR
            return
        }
        self.postButton.isEnabled = true
        self.postButton.alpha = 1.0
        self.titleCounterLabel.textColor = UIColor.lightGray
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .`default`
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonDidClick(_ sender: UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (a) in
            self.view.endEditing(true)
            self.goToPreviousView()
        }))
        alert.addAction(UIAlertAction(title: "Save Draft", style: .default, handler: { (a) in
            AppDataManager.shared.newPostDraft = (self.postTitleTextBox.text, self.postBodyTextBox.text, self.pendingImages)
            self.view.endEditing(true)
            self.goToPreviousView()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postButtonDidClick(_ sender: UIButton){
        let postData: [String: String] = [
            "sender_uid": AppDataManager.shared.currentPersonID,
            "title": self.postTitleTextBox.text,
            "body": self.postBodyTextBox.text
            ]
    
        AppIOManager.shared.addPost(parameters: postData, images: self.pendingImages) { (isSucceed) in
            self.goToPreviousView()
            NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
        }
    }
    
    @IBAction func takePhotoButtonDidClick(_ sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.allowsEditing = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Camera not found", message: "Unable to find camera on this device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePhotoButtonDidClick(_ sender: UIButton){
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = false
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
}

extension NewPostViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView === self.postTitleTextBox{
            let curCharCount = textView.text.count
            self.titleCounterLabel.text = "\(curCharCount)/80"
            let requireLines = min(5, numberOfVisibleLines(textView))
            if self.previousLine != requireLines{
                self.changeCommentBoxHeight(toFit: requireLines)
            }
        }
        self.setPostButtonState()
    }
    
    func changeCommentBoxHeight(toFit lines: Int){
        let lineHeight = self.postTitleTextBox.font!.lineHeight
        let addingHeight = CGFloat(lines - self.previousLine) * lineHeight
        let c = self.postTitleTextBox.constraints[0]
        c.constant += addingHeight
        self.previousLine = lines
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == "Your Title Here" || textView.text == "What's Happening?"){
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            if textView === self.postTitleTextBox{
                textView.text = "Your Title Here"
            }else{
                textView.text = "What's Happening?"
            }
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

extension NewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pendingImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MULTI_MEDIA_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MultiMediaCollectionViewCell
        cell.centerImageView.image = self.pendingImages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert) in
            self.pendingImages.remove(at: indexPath.item)
            self.updateImageCounterLabel()
            self.multiMediaCollectionView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        NSLog("original: \(originalIndexPath)\n new: \(proposedIndexPath)")
        return proposedIndexPath
    }
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage = UIImage()
        if self.imagePickerController.sourceType == .camera{
            chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        self.pendingImages.append(chosenImage)
        self.multiMediaCollectionView.reloadData()
        self.updateImageCounterLabel()
        self.dismiss(animated: true, completion: nil)
    }
}
