//
//  CTLoginViewController.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 30/11/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class CTLoginViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var backLeftButtonNavigationBar: UIBarButtonItem!
    
    @IBOutlet weak var viewFieldsLogin: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    //MARK: Variables
    var dictFacebook : [String : AnyObject]!
    let passwordHard : String = "123456"
    var emailLogin : String? = ""
    let autenticateClient = AuthenticationServices()
    var validateFields : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleItensViews()
        
    }
    
    
    //MARK: Life cicle and methods
    func styleItensViews(){
        //Button
        self.confirmButton.layer.cornerRadius = 2.5
        self.confirmButton.layer.masksToBounds = true
        self.confirmButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.confirmButton.alpha = 0.85
        self.confirmButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.7), for: .normal)
        
        self.registerButton.layer.cornerRadius = 2.5
        self.registerButton.layer.masksToBounds = true
        self.registerButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.registerButton.alpha = 0.85
        self.registerButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.7), for: .normal)
        
        
        //Placeholders
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Email",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"Senha",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        
        //View
        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "background"))
        self.view.backgroundColor?.withAlphaComponent(0.7)
        
        //View Login
        self.viewFieldsLogin.layer.cornerRadius = 2.5
        self.viewFieldsLogin.layer.masksToBounds = true
        
        
        
        //Navigation bar
        self.navigationItem.title = "Entrar"
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "72DEFF")
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-MediumItalic", size: 18)!,
            NSForegroundColorAttributeName : UIColor.darkGray.withAlphaComponent(0.7)
        ]
        
        self.alertLabel.isHidden = true
        
    }

    
    //Facebook methods
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dictFacebook = result as! [String : AnyObject]
                    self.emailTextField.text = self.dictFacebook["email"] as? String
                    print(self.dictFacebook)
                    
                }
            })
        }
    }
    
    func createRegisterRequest() -> UserAuthenticationResponseRequest?{
        
        //ler dos textfield e validar
        let user = UserAuthenticationResponseRequest()
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        
        return user
        
    }
    
    
    func alertError(){
        self.emailTextField.layer.borderColor = UIColor.red.cgColor
        self.emailTextField.layer.borderWidth = 1.5
        self.alertLabel.isHidden = false

    }
    
    //MARK: Actions
    @IBAction func performForgotPasswordTapGesture(_ sender: Any) {
    }
    
    @IBAction func performConfirmButton(_ sender: Any) {
        let userRequest = createRegisterRequest()
        if let sUserRequest = userRequest {
            autenticateClient.sendRequestLogin(user: userRequest!, completion: {(response : UserAuthenticationResponseRequest?) -> Void in
                if let sResponse = response {
                    if let sToken = sResponse.token {
                        if let sUser = AuthenticationManager.setCurrentUser(user: sResponse) {
                            let storyboard = UIStoryboard(name: "First", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "CTFirstViewController")
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                }else{
                    self.alertError()
                }
                
            })
        }
    }
    
    @IBAction func performRegisterButton(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "rootViewController") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func performLoginFacebook(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                        
                    }
                }
            }
        }
    }
    
    @IBAction func performBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
