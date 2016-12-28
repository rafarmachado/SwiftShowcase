//
//  DetailsLanguageCollectionViewController.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 08/12/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SCLAlertView

class DetailsLanguageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    let languageCliente = LanguageServices()
    var arrayLanguages : [ProgramingLanguageResponse]?
    var activityIndicator = CTLoadView()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var languageDescription = [String]()
    
    
    //MARK: Methods and lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
        self.loadLanguages()
        //View
        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "background"))
        self.view.backgroundColor?.withAlphaComponent(0.7)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startActivityIndicator()
    }
    
    
    
    func loadLanguages(){
        self.languageCliente.languagesGet(completion: {(response : ProgramingLanguageDTO?) -> Void in
            if let sResponse = response {
                self.arrayLanguages = sResponse.programingLanguageResponseRequest
                self.collectionView.reloadData()
                self.stopActivityIndicator()
            }else{
                self.alertError()
                self.stopActivityIndicator()
                
            }
            
        })
    }
    
    func startActivityIndicator(){
        activityIndicator.createLoadView(message:"Carregando", view:self.view, position:"center")
        
    }
    
    func stopActivityIndicator(){
        activityIndicator.removeLoadView(view: self.view)
        
    }
    
    func alertError(){
        let alert = UIAlertController(title: "Atenção", message: "ERRO", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showDescription(string: String?){
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true,
            contentViewColor: UIColor(hexString: "72DEFF").withAlphaComponent(0.85),
            titleColor: UIColor.white
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "LogoImage")
        alertView.showInfo("Descrição", subTitle: string!, circleIconImage: alertViewIcon)
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //        return (arrayLanguages?.count)!
        return arrayLanguages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let cellSquareSize: CGFloat = screenWidth / 2.0
        return CGSize(width: cellSquareSize, height: cellSquareSize);
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0.0, 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProgrammingLanguageCollectionViewCell", for: indexPath) as! ProgrammingLanguageCollectionViewCell
        
        let datasource = self.arrayLanguages?[indexPath.row]
        
        cell.titleLabel.text = datasource?.name
//        languageDescription[indexPath.row] = datasource?.desc
        cell.languageImageView.sd_setImage(with: NSURL(string: (datasource?.imageURL)!) as URL!)
        
        //Style itens cell
        cell.cardViewCell.layer.cornerRadius = 5.5
        cell.cardViewCell.layer.masksToBounds = true
        cell.cardViewCell.layer.borderWidth = 2.0
        cell.cardViewCell.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        cell.languageImageView.layer.cornerRadius = 5.5
        cell.languageImageView.layer.masksToBounds = true
        cell.languageImageView.contentMode = .scaleToFill ;
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let datasource = self.arrayLanguages?[indexPath.row]
        
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showInfo((datasource?.name)! , subTitle: (datasource?.desc)!)
           
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
