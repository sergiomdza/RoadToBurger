//
//  DetailViewController.swift
//  RoadToBurger
//
//  Created by Ingenieria on 13/06/22.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    var id: String?
    var count = 1
    var totalPrice = 0
    var producto = Producto()
    var individualPrice = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imagenCompo: UIImageView!
    @IBOutlet weak var cantidadLbl: UILabel!
    @IBOutlet weak var countStepper: UIStepper!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    
    func alert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        
        DispatchQueue.main.async() {
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func loadProducts() {
        let string = "http://3.145.100.233:4001/api/product/\(id ?? "")"
        	let request = AF.request(string, method: .get)
               
        request.responseDecodable(of: Producto.self) {response in
        
            guard let data = response.value else { return }
            print("DATAAA", data)
            self.producto = data
            self.titleLabel.text = data.nombre
            self.descLabel.text = data.descripcion
            let url = URL(string: data.imagen)
            self.imagenCompo.kf.setImage(with: url)
            self.priceLbl.text = "Precio: " + data.precio
            
            let newList = data.precio.components(separatedBy: "$")
            print(newList[newList.count-1])
            
            self.totalPrice = Int(Double(newList[newList.count-1]) ?? 0.0)
            self.individualPrice = Int(Double(newList[newList.count-1]) ?? 0.0)
            print("PRECIOO:", self.totalPrice)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LLEGOO", id ?? "")
        loadProducts()
        countStepper.maximumValue = 10
        countStepper.minimumValue = 1
        countStepper.value = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func stepperHandle(_ sender: Any) {
        cantidadLbl.text = "Cantidad: " + String(Int(countStepper.value))
        totalPrice = Int(countStepper.value) * individualPrice
        priceLbl.text = "Precio: " + String(totalPrice)
    }
    
    func addToCart() {
        let url = "http://3.145.100.233:4001/api/cart"
        let userID = UserSingleton.sharedInstance._id
        let parameters: [String : Any] = ["userID": userID, "productID": producto._id, "cantidad": count, "precio": totalPrice, "nombre": producto.nombre, "imagen": producto.imagen]
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let JSON):
                self.alert(title: "Success", message: "Agregado con éxito")

                break
            case .failure(let error):
                print(error)
                self.alert(title: "Error", message: "Error")
            }
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        addToCart()
    }
}
