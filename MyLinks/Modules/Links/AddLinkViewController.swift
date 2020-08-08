//
//  AddLinkViewController.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/4/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class AddLinkViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    //MARK: - Variables
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.text = ""
        titleTextField.text = ""
    }
    
    //MARK: - Actions
    @IBAction func saveButtonClick(_ sender: Any) {
        if(urlTextField.text != nil && urlTextField.text!.replacingOccurrences(of: " ", with: "").count > 0) {
            let urlText = urlTextField.text!.replacingOccurrences(of: " ", with: "")
            let titleText = titleTextField.text?.trimmingCharacters(in: .whitespaces)
            
            //add link to database
            let linkEntity = DataModels.linksDataModel.links.create()
            if(titleText != nil && !titleText!.isEmpty) {
                linkEntity.title = titleText
            }
            linkEntity.url = urlText
            let added = DataModels.linksDataModel.saveContext()
            
            if(added) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshLinks"), object: nil)
                dismiss(animated: true, completion: nil)
            }
            else { // failed to save to database
                Dialogs.showDialog(viewController: self, title: "Couldn't Save Link")
            }
        }
        else { // empty or invalid url
            Dialogs.showDialog(viewController: self, title: "Please Enter a Link")
        }
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
