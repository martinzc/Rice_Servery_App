//
//  MenuDetailViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 11/28/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit
import Social

class MenuDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    var inDish: String = ""
    
    @IBAction func commentBtn(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dishName.text = inDish
    }

    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showShareOptions(sender: AnyObject) {
        // Dismiss the keyboard if it's visible.
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        
        let actionSheet = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Configure a new action for sharing the note in Twitter.
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            // Check if sharing to Twitter is possible.
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                // Initialize the default view controller for sharing the post.
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                // Set the note text as the default post message.
                if self.textField.text!.characters.count <= 140 {
                    twitterComposeVC.setInitialText("\(self.textField.text!)")
                }
                else {
                    let index = self.textField.text!.startIndex.advancedBy(140)
                    let subText = self.textField.text!.substringToIndex(index)
                    twitterComposeVC.setInitialText("\(subText)")
                }
                
                // Display the compose view controller.
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged in to your Twitter account.")
            }
            
            
        }
        
        
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC.setInitialText("\(self.textField.text!)")
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not connected to your Facebook account.")
            }
            
        }
        
        // Configure a new action to show the UIActivityViewController
        let moreAction = UIAlertAction(title: "More", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let activityViewController = UIActivityViewController(activityItems: [self.textField.text!], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [UIActivityTypeMail]
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
