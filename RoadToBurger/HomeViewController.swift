//
//  HomeViewController.swift
//  RoadToBurger
//
//  Created by Computo 4  on 10/06/22.
//

import UIKit
import Alamofire
import Kingfisher



class HomeViewController: UIViewController {
    var categorias: Array<Categoria> = []
    
    @IBOutlet weak var indicator2: UIActivityIndicatorView!
    @IBOutlet weak var miTabla: UITableView!

    
    func loadCategories() {
        let request = AF.request("http://3.145.100.233:4001/api/category")
        request.responseDecodable(of: Array<Categoria>.self) {response in
            guard let data = response.value else { return }
            self.categorias = data
            self.indicator2.stopAnimating()
            self.indicator2.hidesWhenStopped = true
            self.changeScrollView(data: self.categorias)
            self.miTabla.reloadData()
        }
    }
    
    func changeScrollView(data: Array<Categoria>) {
        miTabla.isHidden = false
        // categoriesSv.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator2.startAnimating()
        loadCategories()
        // Do any additional setup after loading the view.
        miTabla.dataSource = self
        miTabla.delegate = self
        miTabla.register(UINib(nibName: "TableViewCellPersonalizada", bundle: nil), forCellReuseIdentifier: "cellPersonalizado")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "SendToProductView") {
          let secondView = segue.destination as! ProductViewController
          let object = sender as! [String: Any?]
          secondView.name = object["name"] as? String
          secondView.id = object["id"] as? String
       }
    }

}


extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("categorias:", categorias.count)
        return categorias.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = miTabla.dequeueReusableCell(withIdentifier: "cellPersonalizado", for: indexPath) as? TableViewCellPersonalizada
        print(categorias[indexPath.row].nombre)
        cell?.etiqueta1.text = categorias[indexPath.row].nombre
        let url = URL(string: categorias[indexPath.row].imagen)
        cell?.imagen1.kf.setImage(with: url)
        return cell!
                
    }
    
}

extension HomeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //etiqueta1.text = frutas[indexPath.row]
        let sender: [String: Any?] = ["name": categorias[indexPath.row].nombre, "id": categorias[indexPath.row]._id]
        
        performSegue(withIdentifier: "SendToProductView", sender: sender)
    }
    
}

