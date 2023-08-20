//
//  ViewController.swift
//  SaveProductPrice
//
//  Created by mustafa deveci on 20.08.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
    }
    
    @objc func addButton() {
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    


}

