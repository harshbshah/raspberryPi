//  NoteVC.swift
//  Notes
//
//  Created by Marcel Harvan on 2017-04-03.
//  Copyright © 2017 The Marcel's fake Company. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class NoteVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var textView: UITextView!
    
    
    var notesToEdit: Notes?
    var finalImage:UIImage?
    var temporaryView: UIImageView?
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        ad.saveContext()
        
        if notesToEdit != nil {
            loadNotes()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NoteVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let queue = DispatchQueue(label: "com.marcelharvan")
        queue.async{
            self.donePressedDispatch()
        }
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func donePressedDispatch(){
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async {
                    var notes: Notes!
                    if self.notesToEdit == nil {
                        notes = Notes(context: context)
                    } else {
                        notes = self.notesToEdit
                    }
                    if let note = self.textView.attributedText {
                        notes.note_content = note as NSAttributedString
                    }
                    if let latitude = self.locationManager.location?.coordinate.latitude{
                        notes.latitude = latitude
                        print("latitude: \(latitude)")
                    }
                    if let longitude = self.locationManager.location?.coordinate.longitude {
                        notes.longitude = longitude
                    }
                }
            }
        }
    }
    
    func loadNotes (){
        let queue = DispatchQueue(label: "com.marcelharvan")
        queue.async{
            self.looadNotesDispatch()
        }
    }
    
    func looadNotesDispatch (){
        DispatchQueue.global().async {
            do {
                DispatchQueue.main.async {
                    if let notes = self.notesToEdit {
                        self.textView.attributedText = notes.note_content as! NSAttributedString
                    }
                }
            }
        }
    }
    
    @IBAction func deleteBut(_ sender: AnyObject) {
        if notesToEdit != nil {
            context.delete(notesToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func addImage(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Source", preferredStyle: .actionSheet)
        var cameraAction = UIAlertAction()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
                print("Camera")
            })
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            print("Gallery")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            optionMenu.addAction(cameraAction)
        }
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        finalImage = image
        
        temporaryView?.image = image
        picker.dismiss(animated: true, completion: nil)
        var attributedString :NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString:textView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = finalImage
        
        let oldWidth = textAttachment.image!.size.width;
        
        let scaleFactor = oldWidth / (textView.frame.size.width - 10);
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attrStringWithImage)
        
        textView.attributedText = attributedString
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let frameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrame = frameValue.cgRectValue
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let isPortrait = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        let keyboardHeight = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width
        
        var contentInset = self.textView.contentInset
        contentInset.bottom = keyboardHeight
        
        var scrollIndicatorInsets = self.textView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = keyboardHeight
        
        UIView.animate(withDuration: animationDuration.doubleValue, animations:({
            self.textView.contentInset = contentInset
            self.textView.scrollIndicatorInsets = scrollIndicatorInsets
        })
        )
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        var contentInset = self.textView.contentInset
        contentInset.bottom = 0
        
        var scrollIndicatorInsets = self.textView.scrollIndicatorInsets
        scrollIndicatorInsets.bottom = 0
        
        UIView.animate(withDuration: animationDuration.doubleValue, animations:({
            self.textView.contentInset = contentInset
            self.textView.scrollIndicatorInsets = scrollIndicatorInsets
        })
        )
    }
    
}
