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
        
        guard let image = imageView?.image, cgimg = image.CGImage else {
            print("imageView doesn't have an image!")
            return
        }
        
        let openGLContext = EAGLContext(API: .OpenGLES2)
        let context = CIContext(EAGLContext: openGLContext!)
        
        let coreImage = CIImage(CGImage: cgimg)
        
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(coreImage, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(1, forKey: kCIInputIntensityKey)
        
        if let sepiaOutput = sepiaFilter?.valueForKey(kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            exposureFilter?.setValue(1, forKey: kCIInputEVKey)
            
            if let exposureOutput = exposureFilter?.valueForKey(kCIOutputImageKey) as? CIImage {
                let output = context.createCGImage(exposureOutput, fromRect: exposureOutput.extent)
                let result = UIImage(CGImage: output)
                imageView?.image = result
            }
        }
    }
    
    @IBAction func originalBtn(sender: UIButton) {
        imageView.image = UIImage(CGImage: originalImage!)
    }
    
    @IBAction func finishBtn(sender: UIButton) {
        let destination = self.navigationController!.viewControllers[1] as! MenuDetailViewController
        destination.loadedImage = imageView.image
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = CGImageCreateCopy(loadedImage!.CGImage)
        imageView.image = loadedImage
    }

}
