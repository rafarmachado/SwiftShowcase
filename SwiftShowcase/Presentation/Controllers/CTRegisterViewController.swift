//
//  CTRegisterViewController.swift
//  SwiftShowcase
//
//  Created by cedro_nds on 24/11/16.
//  Copyright © 2016 Rafael Rezende Machado. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import ObjectMapper
import Photos
import MobileCoreServices



class CTRegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Mark: Outlets
    
    @IBOutlet weak var selectPhotoLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personalInfoView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: FBSDKButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthViewPersonalInfosConstraint: NSLayoutConstraint!
    @IBOutlet weak var facebookMessageLabel: UILabel!
    @IBOutlet weak var widthImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthLabelImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    //Mark: Variables
    var dictFacebook : [String : AnyObject]!
    var urlPhotoFacebook : NSURL!
    var facebookUsing = false
    let authenticationClient = AuthenticationServices()
    let picker = UIImagePickerController()
    var stringBase64 : String = ""
    var fieldsValidation : Bool = true
    
    //Mark: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboard()
        
        self.styleItensViews()
        
        picker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        
        self.introAnimation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func styleItensViews(){
        //Button
        self.confirmButton.layer.cornerRadius = 5.5
        self.confirmButton.layer.masksToBounds = true
        self.confirmButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.confirmButton.alpha = 0.85
        self.confirmButton.setTitleColor(UIColor.darkGray.withAlphaComponent(0.7), for: .normal)
        
        //Image
        self.profileImageView.layer.cornerRadius = 5.5
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.layer.borderColor = UIColor(hexString: "72DEFF").withAlphaComponent(0.1).cgColor
        self.profileImageView.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.profileImageView.alpha = 0.85
        self.selectPhotoLabel.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        
        //Placeholders
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        nameTextField.attributedPlaceholder = NSAttributedString(string:"Nome",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Sobrenome",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Senha",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.darkGray.withAlphaComponent(0.55)])
        
        //View Infos
        self.personalInfoView.layer.cornerRadius = 5.5
        self.personalInfoView.clipsToBounds = true
        self.confirmButton.layer.backgroundColor = UIColor(hexString: "72DEFF").cgColor
        self.confirmButton.alpha = 0.85
        self.facebookMessageLabel.textColor = UIColor.darkGray.withAlphaComponent(0.7)
        
        //View
        self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "background"))
        self.view.backgroundColor?.withAlphaComponent(0.7)
        
        
        //Navigation bar
        self.navigationItem.title = "Cadastre-se"
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "72DEFF")
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-MediumItalic", size: 18)!,
            NSForegroundColorAttributeName : UIColor.darkGray.withAlphaComponent(0.7)
        ]
        self.backButton.tintColor = UIColor.darkGray.withAlphaComponent(0.7)
        
        
    }
    
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 100)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 100)
        
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        
        UIView.commitAnimations()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        let email = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let imageView = UIImageView();
        let image = UIImage(named: "Alert");
        imageView.image = image;
        imageView.frame = CGRect(x: 10, y: 10, width: 25, height: 20)
        
        
        if isValidEmail(testStr: email){
            //imageView.alpha = 0
            textField.rightView = nil
        } else {
            textField.rightViewMode = UITextFieldViewMode.always
            textField.rightView = imageView
            
        }
        return true
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
        
    }
    
    
    func introAnimation(){
        setAlphaOutlets(alpha: 0)
        widthViewPersonalInfosConstraint.constant = 20
        widthImageViewConstraint.constant = 5
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: {
            self.widthViewPersonalInfosConstraint.constant = 270
            self.widthImageViewConstraint.constant = 100
            self.personalInfoView.layoutIfNeeded()
            self.profileImageView.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveLinear, animations: {
            self.widthViewPersonalInfosConstraint.constant = 250
            self.widthImageViewConstraint.constant = 20
            self.personalInfoView.layoutIfNeeded()
            self.profileImageView.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, delay: 0.6, options: .curveLinear, animations: {
            self.widthViewPersonalInfosConstraint.constant = 270
            self.widthImageViewConstraint.constant = 100
            self.personalInfoView.layoutIfNeeded()
            self.profileImageView.layoutIfNeeded()
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.7, options: .curveLinear, animations: {
            self.personalInfoView.layoutIfNeeded()
            self.profileImageView.layoutIfNeeded()
            self.setAlphaOutlets(alpha: 1)
            
        }, completion: nil)
        
    }
    
    func setAlphaOutlets(alpha: CGFloat){
        emailTextField.alpha = alpha
        nameTextField.alpha = alpha
        lastNameTextField.alpha = alpha
        facebookLoginButton.alpha = alpha
        facebookMessageLabel.alpha = alpha
        passwordTextField.alpha = alpha
        selectPhotoLabel.alpha = alpha
        
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dictFacebook = result as! [String : AnyObject]
                    self.placeDatasFBUser()
                    print(self.dictFacebook)
                    
                }
            })
        }
    }
    
    func placeDatasFBUser(){
        self.nameTextField.text = String(describing: self.dictFacebook["first_name"]!)
        self.lastNameTextField.text = String(describing: self.dictFacebook["last_name"]!)
        self.emailTextField.text = String(describing: self.dictFacebook["email"]!)
        let facebookID = self.dictFacebook["id"] as? String
        urlPhotoFacebook = NSURL(string: "https://graph.facebook.com/\(facebookID!)/picture?type=large&return_ssl_resources=1")
        self.profileImageView.image = UIImage(data: NSData(contentsOf: urlPhotoFacebook! as URL)! as Data)
        self.facebookUsing = true
        self.selectPhotoLabel.isHidden = true
        
    }
    
    
    //    MARK: Methods For PreRegisterInServer
    func createRegisterRequest() -> UserAuthenticationResponseRequest?{
        
        //ler dos textfield e validar
        
        let user = UserAuthenticationResponseRequest()
        user.name = self.nameTextField.text
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.profileURL = String(describing: self.urlPhotoFacebook)
        user.isUsingFB = self.facebookUsing
        user.photoBase64 = self.stringBase64
        
        
        return user
        
    }
    
    func CameraOptions(valor : Int){
        if (valor == 1) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.selectPhotoLabel.isHidden = true
            
        } else if(valor == 2) {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.selectPhotoLabel.isHidden = true
            
        }
        
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImageView.contentMode = .scaleToFill
        self.profileImageView.image = chosenImage
        
        let profileImageData : UIImage = self.profileImageView.image!
        
        stringBase64 =  convertImageToBase64(image: profileImageData)
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImagePNGRepresentation(image)
        
        let base64String = imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
        
        return base64String!
        
    }

    //MARK: Actions
    @IBAction func performExitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func performSelectPhotoTapGesture(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let showCamera = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.CameraOptions(valor: 1)
        })
        let showLibrary = UIAlertAction(title: "Library Images", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.CameraOptions(valor: 2)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(showCamera)
        optionMenu.addAction(showLibrary)
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func performFacebookRegisterButton(_ sender: Any) {
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
    
    @IBAction func performConfirmButton(_ sender: Any) {
        let request = createRegisterRequest()
        
        if let sRequest = request {
            let request = createRegisterRequest()
            if let request = request{
                authenticationClient.registerToServer(request: request, completion: {(response: UserAuthenticationResponseRequest?) -> Void in
                    if let sResponse = response{
                        if let sToken = response?.token{
                            if let saveUser = AuthenticationManager.setCurrentUser(user: sResponse){
                                let storyboard = UIStoryboard(name: "First", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "CTFirstViewController")
                                self.present(controller, animated: true, completion: nil)
                            }
                        }
                    }
                    
                })
            }else{
                print("error")
            }
            
            
        }
        
    }
    
}
