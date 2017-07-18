//
//  SubmitViewController.swift
//  Palooka
//
//  Created by Duane Jordaan on 2017/07/08.
//  Copyright © 2017 Duane Jordaan. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class SubmitViewController: UIViewController {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var photoAlbum: UIImageView!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var gross: UITextField!
    @IBOutlet weak var score: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dateTimeInterval: TimeInterval = 0
    
    
    @IBAction func datePicked(_ sender: Any) {
        dateTimeInterval = datePicker.date.timeIntervalSinceNow
     //   ref.setValue["date": dateTimeInterval]
    }
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            self.submitButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.submitButton.backgroundColor = UIColor(red: 0.0/255.0, green: 152.0/255.0, blue: 103.0/255.0,
                                                        alpha: 1.0)
        } else {
            self.submitButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.submitButton.backgroundColor = .lightGray
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        photoAlbum.isHidden = true
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "placeholder-photo")
        self.photoAlbum.isHidden = false
        self.selectedImage = nil
        self.courseName.text = ""
    }
    
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }

    @IBAction func submitButton_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!)
            })
        } else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
   
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!, "courseName": courseName.text!, "date": dateTimeInterval ,"gross": gross.text!, "score": score.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        })
    }
    
}
extension SubmitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

