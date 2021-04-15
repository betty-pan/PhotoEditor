//
//  EditingViewController.swift
//  PhotoEditor
//
//  Created by Betty Pan on 2021/4/14.
//

import UIKit

var imageStatus = ImageStatus()

class EditingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        imageBackgroundView.backgroundColor = viewController.selectedColor
    }

    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet var fullScreenView: UIView!
    
    @IBOutlet weak var ratioStackView: UIStackView!
    @IBOutlet weak var rotateStackView: UIStackView!
    
    let image:UIImage
    
    init?(coder:NSCoder, image:UIImage) {
        self.image = image
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
    }
    func setImageViewSize() {
        let width = fullScreenView.bounds.width
        imageBackgroundView.bounds.size = CGSize(width: width, height: width/4*5.5)
        selectedPhotoImageView.bounds.size = imageBackgroundView.bounds.size
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setImageViewSize()
        selectedPhotoImageView.image = image
        ratioStackView.isHidden = true
        rotateStackView.isHidden = true
        
    }
    
    @IBAction func safeImage(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: imageBackgroundView.bounds.size)
        let image = renderer.image(actions: { (context) in
            imageBackgroundView.drawHierarchy(in: imageBackgroundView.bounds, afterScreenUpdates: true)
        })
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func changeColor(_ sender: Any) {
        let controller = UIColorPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func rotateImagefromRight(_ bool:Bool) {
        if bool == true {
            imageStatus.flipCounts += 1
        }else{
            imageStatus.flipCounts -= 1
        }
        selectedPhotoImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/180)*90*CGFloat(imageStatus.flipCounts))
    }
    
    @IBAction func showRotateMode(_ sender: Any) {
        rotateStackView.isHidden = false
        ratioStackView.isHidden = true
    }
    
    @IBAction func showRatioMode(_ sender: Any) {
        rotateStackView.isHidden = true
        ratioStackView.isHidden = false
    }
    
    @IBAction func flipHorizontally(_ sender: Any) {
        if imageStatus.isMirrored {
            selectedPhotoImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageStatus.isMirrored = false
        }else{
            selectedPhotoImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            imageStatus.isMirrored = true
        }
    }
    
    @IBAction func rotateFromLeft(_ sender: Any) {
        rotateImagefromRight(false)
    }
    @IBAction func rotateFromRight(_ sender: Any) {
        rotateImagefromRight(true)
    }
    
    @IBAction func changeRatio(_ sender: UIButton) {
        let length = fullScreenView.frame.width
        let width = length
        var height: Int
        
        switch sender.currentTitle {
        case "Original":
            height = Int(length/4*5.5)
        case "Square":
            height = Int(length/1*1)
        case "16:9":
            height = Int(length/16*9)
        case "4:3":
            height = Int(length/4*3)
        default:
            height = Int(length/4*5.5)
        }
        imageBackgroundView.isHidden = false
        imageBackgroundView.bounds.size = CGSize(width: Int(width), height: height)
        selectedPhotoImageView.frame.size = imageBackgroundView.frame.size
        
    }
}

