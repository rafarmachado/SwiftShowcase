//
//  CTFirstViewController.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 06/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import UIKit
import Crashlytics
import FrostedSidebar

import UIKit

class CTFirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        var frostedSidebar: FrostedSidebar = FrostedSidebar(images: imageArray, colors: colorArray, selectionStyle: chosenSelectionStyle)
        
        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "background"))
        self.view.backgroundColor?.withAlphaComponent(0.7)
        
    }
    
    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    //MARK:Tableview delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "performCollectionSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as! MainTableViewCell
        
        cell.imageViewCell.image = UIImage(named: "LogoImage")
        cell.titleLabelCell.text = "Collection View"
        cell.titleLabelCell.textAlignment = .center
        cell.descriptionTextView.text = "Uso de bibliotecas de imagem"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let title = UILabel()
        title.font = UIFont(name: "Helvetica", size: 16)!
        title.textColor = UIColor.lightGray
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return "Section 1"
    }
    
    
    
    
    
    
}
