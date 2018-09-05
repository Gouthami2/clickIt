//
//  ViewController.swift
//  Chocolate
//
//  Created by Gouthami Reddy on 7/6/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imageView.image = userPickedimage
            guard  let ciimage = CIImage(image: userPickedimage) else {
                fatalError("could not convert to ciimage")
            }
        detect(image: ciimage)
    }
        imagePicker.dismiss(animated: true, completion: nil)
}
    func detect(image: CIImage) {
    
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loading coreml model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process")
            }
            if let firstResult = results.first {
               
                    self.navigationItem.title = firstResult.identifier
                } else {
                    self.navigationItem.title = "try again"
                
                
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
       
        present(imagePicker,animated: true,completion: nil)
    }
 
}

