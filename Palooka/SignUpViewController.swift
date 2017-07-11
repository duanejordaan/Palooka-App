//
//  SignUpViewController.swift
//  Palooka
//
//  Created by Duane Jordaan on 2017/07/08.
//  Copyright © 2017 Duane Jordaan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true    }
    
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: User?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://palooka-b4980.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    
                    let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    let ref = Database.database().reference()
                    let usersReference = ref.child("users")
                    let newUserReference = usersReference.child(uid!)
                    newUserReference.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImageUrl": profileImageUrl])
                })
            }
        })
    }
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
