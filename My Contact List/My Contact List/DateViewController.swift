//
//  DateViewController.swift
//  My Contact List
//
//  Created by Samir Alyateem on 4/17/19.
//  Copyright © 2019 Samir Alyateem. All rights reserved.
//

import UIKit

protocol DateControllerDelegate: class {
    func dateChanged (date:Date)
}

class DateViewController: UIViewController {
    @IBOutlet weak var dtpDate: UIDatePicker!
    weak var delegate: DateControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let saveButton: UIBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick a Birthdate"
        
    }
    
    @objc func saveDate(){
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
