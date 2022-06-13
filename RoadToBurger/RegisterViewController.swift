//
//  RegisterViewController.swift
//  RoadToBurger
//
//  Created by Ingenieria on 10/06/22.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    @IBOutlet weak var registoBtn: UIButton!
    @IBOutlet weak var nombreTxt: UITextField!
    
    @IBOutlet weak var pwdTxt: UITextField! 
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var apellidoTxt: UITextField!
    
    var username = ""
    var password = ""
    var nombre = ""
    var apellido = ""
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func register() {
        
        let url = "http://3.145.100.233:4001/api/user"
        let parameters: [String : Any] = ["nombre": nombre, "apellido": apellido, "username": username, "password": password]
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let JSON):
                self.alert(title: "Success", message: "Creado con éxito")

                break
            case .failure(let error):
                print(error)
                self.alert(title: "Error", message: "Error")
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onNameChange(_ sender: Any) {
        nombre = nombreTxt.text ?? ""
        print("Nombre:", nombre)
    }
    @IBAction func onLastNameChange(_ sender: Any) {
        apellido = apellidoTxt.text ?? ""
        print("Apellido:", apellido)
    }
    @IBAction func onUserNameChange(_ sender: Any) {
        username = usernameTxt.text ?? ""
        print("User:", username)
    }
    
    
    @IBAction func onPwdChange(_ sender: Any) {
        password = pwdTxt.text ?? ""
        print("PWD:", password)
    }
    
    @IBAction func onPressRegister(_ sender: Any) {
        print(nombre, apellido, username, password)
        register()
    }
        
    
}
