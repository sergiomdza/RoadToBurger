//
//  ProfileViewController.swift
//  RoadToBurger
//
//  Created by Ingenieria on 13/06/22.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
        
    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var apellidoLbl: UILabel!
    @IBOutlet weak var mitabla: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var confimarBtn: UIButton!
    
    var user = Usuario()
    var cart: [CartProduct] = []
    
    func loadUserData (id: String) {
        let string = "http://3.145.100.233:4001/api/user/" + id
        let request = AF.request(string, method: .get)
               
        request.responseDecodable(of: Usuario.self) {response in
            guard let data = response.value else { return }
            self.user = data
            //self.indicator.stopAnimating()
            //self.indicator.hidesWhenStopped = true
            //self.changeScrollView(data: self.productos)
            //self.miTabla.reloadData()
            self.nombreLbl.text = "Nombre:  " + self.user.nombre
            self.apellidoLbl.text = "Apellido:  " + self.user.apellido
        }
        
    }
    
    func loadCarritoData(id: String) {
        let parameters = [
            "query" : "{\"userID\":\"\(id ?? "")\"}"
            ]
        let string = "http://3.145.100.233:4001/api/cart"
        let request = AF.request(string, method: .get, parameters: parameters)
             
        request.responseDecodable(of: [CartProduct].self) {response in
            print("QUE PASA:", request.response)
            guard let data = response.value else { return }
            self.cart = data
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.changeScrollView(data: self.cart)
            self.mitabla.reloadData()
        }
    }
    
    func changeScrollView(data: [CartProduct]) {
        mitabla.isHidden = false
        // categoriesSv.subviews.forEach({ $0.removeFromSuperview() })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = UserSingleton.sharedInstance._id
        loadUserData(id: userID)
        loadCarritoData(id: userID)
        
        mitabla.dataSource = self
        mitabla.delegate = self
        mitabla.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cellPersonalizado")
        // Do any additional setup after loading the view.
    }
    
}

extension ProfileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Cart:", cart.count)
        return cart.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mitabla.dequeueReusableCell(withIdentifier: "cellPersonalizado", for: indexPath) as? CartTableViewCell
        print(cart[indexPath.row].nombre)
        cell?.productName.text = cart[indexPath.row].nombre
        //cell?.productQuant.text = String(cart[indexPath.row].cantidad)
        cell?.totalPrice.text = String(cart[indexPath.row].precio)
        let url = URL(string: cart[indexPath.row].imagen)
        cell?.imagen1.kf.setImage(with: url)
        return cell!
                
    }
    
}

extension ProfileViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //etiqueta1.text = frutas[indexPath.row]
        
    }
    
}
