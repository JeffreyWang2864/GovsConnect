//
//  NewEditProfileViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/2.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import RSKImageCropper

class NewEditProfileViewController: UIViewController {
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var department: UILabel!
    @IBOutlet var from: UILabel!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var blurView: UIVisualEffectView!
    var imagePickerController = UIImagePickerController()
    var didChangeProfileBlock: CommonVoidBlockType?
    var data: UserDataContainer?{
        didSet{
            self.name.text = data!.name
            self.department.text = data!.department.rawValue
            self.from.text = "from " + data!.description
            let imgData = AppDataManager.shared.profileImageData[data!.uid]!
            self.profileImage.image = UIImage(data: imgData)!
            self.blurView.backgroundColor = APP_BACKGROUND_GREY
            self.blurView.clipsToBounds = true
            self.blurView.layer.cornerRadius = 20
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.width / 2
        self.changeImageButton.setTitleColor(UIColor.white, for: .normal)
        self.changeImageButton.setTitleColor(APP_THEME_COLOR, for: .selected)
        self.changeImageButton.backgroundColor = APP_THEME_COLOR
        self.changeImageButton.clipsToBounds = true
        self.changeImageButton.layer.cornerRadius = 8
        self.imagePickerController.delegate = self
    }
    
    @IBAction func changeProfileImageBtnDidClick(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a new photo", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerController.sourceType = .camera
                self.imagePickerController.allowsEditing = false
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                let alert  = UIAlertController(title: "Camera not found", message: "Unable to find camera on this device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose a photo from library", style: .default, handler: { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.allowsEditing = false
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //code
        }))
        self.navigationController!.present(alert, animated: true, completion: nil)
    }
}

extension NewEditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: false){
            var imageCropVC: RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: chosenImage, cropMode: .circle)
            imageCropVC.delegate = self
            self.navigationController!.pushViewController(imageCropVC, animated: true)
        }
    }
}

extension NewEditProfileViewController: RSKImageCropViewControllerDelegate{
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        AppIOManager.shared.changeProfileImage(newImage: croppedImage) { (isSucceed) in
            _ = self.navigationController!.popViewController(animated: true)
            if self.didChangeProfileBlock != nil{
                self.didChangeProfileBlock!()
            }
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController!.popViewController(animated: true)
    }
}
