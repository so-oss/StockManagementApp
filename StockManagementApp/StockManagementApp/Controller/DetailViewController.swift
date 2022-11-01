//
//  DetailViewController.swift
//  FM-Task2
//
//  Created by SoiriYuichi on 2022/09/24.
//

import UIKit

protocol PictureDelegate {
    func pictureDelegate(image: UIImage, indexPathRow: Int)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: PictureDelegate?
    var image: UIImage?
    var navigationTitle = ""
    var indexPathRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        self.navigationBar.items![0].title = navigationTitle
    }
    
    @IBAction func selectPictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }

    @IBAction func dismissDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
        guard let image = self.image else{
            return
        }
        self.delegate?.pictureDelegate(image: image, indexPathRow: indexPathRow)
        self.dismiss(animated: true)
    }

    @IBAction func deletePictureButton(_ sender: Any) {
        if let image = UIImage(named: "no_image"){
            imageView.image = image
            self.delegate?.pictureDelegate(image: image, indexPathRow: indexPathRow)
        }
    }
}

extension DetailViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        
        self.image = image
        self.dismiss(animated: true)
    }
}
