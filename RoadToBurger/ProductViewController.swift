//
//  ProductViewController.swift
//  RoadToBurger
//
//  Created by Ingenieria on 10/06/22.
//

import UIKit
import Alamofire
import Kingfisher


class ProductViewController: UIViewController {
    var productos: [Producto] = []
    var name: String?
    var id: String?

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var miTabla: UITableView!
    
    func loadProducts() {
        let parameters = [
            "query" : "{\"categoria\":\"\(id ?? "")\"}"
        	]
        
        let string = "http://3.145.100.233:4001/api/product"
        let request = AF.request(string, method: .get, parameters: parameters)
               
        request.responseDecodable(of: [Producto].self) {response in
        
            guard let data = response.value else { return }
            self.productos = data
        
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            self.changeScrollView(data: self.productos)
            self.miTabla.reloadData()
        }
    }
    
    func changeScrollView(data: [Producto]) {
        miTabla.isHidden = false
        // categoriesSv.subviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("name:", name)
        print("id:", id)
        
        indicator.startAnimating()
        loadProducts()
        
        miTabla.dataSource = self
        miTabla.delegate = self
        miTabla.register(UINib(nibName: "TableViewCellPersonalizada", bundle: nil), forCellReuseIdentifier: "cellPersonalizado")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "SendToDetailsView") {
          let secondView = segue.destination as! DetailViewController
          let object = sender as! [String: Any?]
          secondView.id = object["id"] as? String
       }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("productos:", productos.count)
        return productos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = miTabla.dequeueReusableCell(withIdentifier: "cellPersonalizado", for: indexPath) as? TableViewCellPersonalizada
        print(productos[indexPath.row].nombre)
        cell?.etiqueta1.text = productos[indexPath.row].nombre
        let url = URL(string: productos[indexPath.row].imagen)
        cell?.imagen1.kf.setImage(with: url)
        return cell!
                
    }
    
}

extension ProductViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //etiqueta1.text = frutas[indexPath.row]
        let sender: [String: Any?] = ["id": productos[indexPath.row]._id]
        
        performSegue(withIdentifier: "SendToDetailsView", sender: sender)
    }
    
}
