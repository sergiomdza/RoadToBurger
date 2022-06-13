//
//  ViewController.swift
//  RoadToBurger
//
//  Created by Computo 4  on 10/06/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var username = ""
    var password = ""

    @IBOutlet weak var pwdTXT: UITextField!
    @IBOutlet weak var usernameTXT: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func userNameEnd(_ sender: Any) {
        username = usernameTXT.text ?? ""
    }
    
    
    @IBAction func pwdChange(_ sender: Any) {
        password = pwdTXT.text ?? ""
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        let url = "http://3.145.100.233:4001/api/user/validate"
        let parameters: [String : Any] = ["username": username, "password": password]
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let JSON):
                
                let data = JSON as! NSDictionary
                
                if data["accessToken"] != nil {
                    //self.alert(title: "Success", message: "Creado con éxito")
                    
                    let userObj = data["user"] as! NSDictionary
                    let loggedIn = User(_id: (userObj["_id"] ?? "") as! String, nombre: (userObj["nombre"] ?? "") as! String)
                    UserSingleton.sharedInstance.setUser(usuario: loggedIn)
                    
                    //Send to home
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
                    DispatchQueue.main.async() {
                        self.present(nextViewController, animated: true, completion: nil)
                    }
                    
                } else {
                    self.alert(title: "Error", message: "Datos Incorrectos")
                }
                
                break
            case .failure(let error):
                print(error)
                self.alert(title: "Error", message: "Error")
            }
        }
    }
    
    

}

