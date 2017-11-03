//
//  CameraViewController.swift
//  unifyFacialIOSChallenge
//
//  Sources: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift
//
//  Created by Juliette Hainline on 11/3/17.
//  Copyright © 2017 Juliette Hainline. All rights reserved.
//

import UIKit
import Security

final class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [UIImage]()
    var timer = Timer()
    var count = 0
    
    var pickerController = UIImagePickerController()
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBAction func takePhotoAction(_ sender: Any) {
        self.take10Pictures()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Took picture")
        if (self.count < 10) {
            print(self.count)
            if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                photos.append(selectedImage)
            }
        } else {
            self.count = 0
            dismiss(animated:true, completion: nil)
            for photo in photos {
                KeychainService.savePhoto(token: photo)
            }
            photos.removeAll()
        }
        self.count = self.count + 1
    }
    
    public func take10Pictures() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.showsCameraControls = false
            pickerController.allowsEditing = true
            self.present(self.pickerController, animated: true) {
                if (self.count < 8) {
                    self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.takePicture), userInfo: nil, repeats: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "You cannot take a photo", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc public func takePicture() {
        self.pickerController.takePicture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
