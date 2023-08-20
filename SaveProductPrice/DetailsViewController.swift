//
//  DetailsViewController.swift
//  SaveProductPrice
//
//  Created by mustafa deveci on 20.08.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var SelectedProductName = ""
    var SelectedProductUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SelectedProductName != ""  {
            
            SaveButton.isHidden = true
            
            if let uuidString = SelectedProductUUID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                
                do{
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject] {
                            
                            if let name = result.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            
                            if let price = result.value(forKey: "price") as? Int {
                                priceTextField.text = (String)(price)
                            }
                            
                            if let date = result.value(forKey: "date") as? Date {
                                datePicker.date = date
                            }
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                        }
                    }
                }catch {
                    print("error")
                }
            }
            
        } else {
            SaveButton.isHidden = false
            SaveButton.isEnabled = false
            nameTextField.text = ""
            priceTextField.text = ""
            let currentDate = Date()
            datePicker.date = currentDate
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        SaveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
        
        product.setValue(nameTextField.text!, forKey: "name")
        product.setValue(datePicker.date, forKey: "date")
        
        if let price = Int(priceTextField.text!) {
            product.setValue(price, forKey: "price")
        }
        
        product.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.7)
        product.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("saved")
        }catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addedData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}


