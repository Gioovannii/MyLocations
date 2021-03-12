//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Giovanni Gaffé on 2021/3/11.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    var selectedCategoryName = ""

    let categories = [
        "No Categories",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
