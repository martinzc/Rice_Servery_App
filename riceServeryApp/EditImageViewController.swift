//
//  EditImageViewController.swift
//  riceServeryApp
//
//  Created by Martin Zhou on 11/28/16.
//  Copyright © 2016 Martin Zhou. All rights reserved.
//

import UIKit
import CoreImage

class EditImageViewController: UIViewController {
    
    var loadedImage:UIImage?
    var originalImage:CGImage?
    
    private var sideSize: CGFloat!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func surpriseBtn(sender: UIButton) {
        
        let coreImage = CIImage(image: imageView!.image!)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(2, forKey: kCIInputIntensityKey)
        
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(filter!.outputImage!, fromRect: coreImage!.extent)
        imageView?.image = UIImage(CGImage: imageRef)
    
    }
    
    @IBAction func saveBnt(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
        let alertController = UIAlertController(title: "Success", message: "Image is saved", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)

    }
    @IBAction func originalBtn(sender: UIButton) {
        imageView.image = UIImage(CGImage: originalImage!)
    }
    
    @IBAction func finishBtn(sender: UIButton) {
        let destination = self.navigationController!.viewControllers[1] as! MenuDetailViewController
        destination.loadedImage = imageView.image
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = CGImageCreateCopy(loadedImage!.CGImage)
        imageView.image = loadedImage
    }
    

}
