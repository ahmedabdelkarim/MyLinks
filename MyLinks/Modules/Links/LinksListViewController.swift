//
//  ViewController.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/4/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class LinksListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLinksStackView: UIStackView!
    
    //MARK: - Variables
    private let searchController = UISearchController(searchResultsController: nil)
    private var links:[LinkEntity]!
    private var filteredLinks:[LinkEntity]!
    
    //MARK: - Properties
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        registerTableCell()
        observeRefreshLinks()
        loadLinksFromDatabase()
        //force update navigation bar to show large title when app launches (fix for issue: must scroll tableview to convert from small to large title in navigation bar)
        navigationController?.navigationBar.sizeToFit()
    }
    
    //MARK: - Functions
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Links"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func registerTableCell() {
        let nib = UINib(nibName: "LinkCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LinkCell")
    }
    
    func observeRefreshLinks() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadLinksFromDatabase), name: NSNotification.Name(rawValue: "refreshLinks"), object: nil)
    }
    
    @objc func loadLinksFromDatabase() {
        DataModels.linksDataModel.links.fetchFromDatabase()
        
        if(DataModels.linksDataModel.links == nil) {
            //errorIndicator.isHidden = false // can show error indicator
            return
        }
        
        if(DataModels.linksDataModel.links.count == 0) {
            noLinksStackView.isHidden = false
            tableView.isHidden = true
            return
        }
        
        noLinksStackView.isHidden = true
        tableView.isHidden = false
        
        //take a copy for UI purposes and manipulate it
        links = DataModels.linksDataModel.links.copy()
        links = links.reversed()
        
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func clearButtonClick(_ sender: Any) {
        Dialogs.showConfirmationDialog(viewController: self, question: "Clear All Links?", message: "All links will be deleted", action1Title: "Cancel", action1Style: .cancel, action2Title: "Clear", action2Style: .destructive, action1Selected: {
            self.dismiss(animated: true, completion: nil)
        }, action2Selected: {
            let cleared = DataModels.linksDataModel.links.clear()
            
            if(cleared) {
                self.loadLinksFromDatabase()
            }
            else {
                Dialogs.showDialog(viewController: self, title: "Couldn't Clear Links")
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredLinks != nil ? filteredLinks.count : 0
        }
        
        return links != nil ? links.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell") as! LinkCell
        
        let link = isFiltering ? filteredLinks[indexPath.row] : links[indexPath.row]
        cell.setup(link: link)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = isFiltering ? filteredLinks[indexPath.row] : links[indexPath.row]
        let url = URL(string: link.url!)
        
        if(url != nil && url?.scheme != nil) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(done) in
                if(done == false) {
                    DispatchQueue.main.async {
                        Dialogs.showDialog(viewController: self, title: "Couldn't Open Link")
                    }
                }
            })
        }
        else {
            DispatchQueue.main.async {
                Dialogs.showDialog(viewController: self, title: "Invalid Link")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            tableView.beginUpdates()
            
            let link = isFiltering ? filteredLinks[indexPath.row] : links[indexPath.row]
            let deleted = DataModels.linksDataModel.links.delete(item: link)
            let saved = DataModels.linksDataModel.saveContext()
            
            if(deleted && saved) {
                if(isFiltering) {
                    filteredLinks.remove(at: indexPath.row)
                    let index = links.firstIndex { $0 === link }
                    links.remove(at: index!)
                }
                else {
                    links.remove(at: indexPath.row)
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if(links.count == 0) {
                    noLinksStackView.isHidden = false
                    tableView.isHidden = true
                }
            }
            else {
                Dialogs.showDialog(viewController: self, title: "Couldn't Delete Link")
            }
            
            tableView.endUpdates()
        }
    }
    
    //MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        if(links == nil) {
            return
        }
        
        filteredLinks = links.filter { (link: LinkEntity) -> Bool in
            return link.title?.lowercased().contains(searchController.searchBar.text!.lowercased().trimmingCharacters(in: .whitespaces)) ?? false
        }
        
        tableView.reloadData()
    }
    
}
