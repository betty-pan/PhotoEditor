//
//  MainViewController.swift
//  PhotoEditor
//
//  Created by Betty Pan on 2021/4/14.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    //protocol function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imageView.image = image
       
        if let editingViewController = storyboard?.instantiateViewController(identifier: "\(EditingViewController.self)", creator: { coder in EditingViewController.init(coder: coder, image: image!)
            
        }) {
            show(editingViewController, sender: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var illustrationView: UIView!
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setBtn
        addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.height/2
        addPhotoBtn.layer.shadowRadius = 8
        addPhotoBtn.layer.shadowOpacity = 0.4
        
       
    }
    func selectPhoto(sourceType:UIImagePickerController.SourceType) {
        let imageController = UIImagePickerController()
        imageController.sourceType = sourceType
        imageController.delegate = self
        present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        let sources:[(name:String, type:UIImagePickerController.SourceType)] = [
            ("Album",.photoLibrary),
            ("Camera",.camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.name, style: .default) { (_) in
                self.selectPhoto(sourceType: source.type)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
