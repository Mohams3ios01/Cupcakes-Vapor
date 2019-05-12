//
//  ViewController.swift
//  iOSCupcakes
//
//  Created by Mohammed Ibrahim on 2019-05-11.
//  Copyright © 2019 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var cupcakes = [Cupcake]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchData()
    }

    // MARK: - Fetch Cupcakes
    // Fetch data from local host databse method
    func fetchData() {
        let url = URL(string: "http://localhost:8080/cupcakes")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            
            // decode data from data we retrieved with "skeleton" of cupcake object
            if let cakes = try? decoder.decode([Cupcake].self, from: data) {
                DispatchQueue.main.async {
                    self.cupcakes = cakes
                    self.tableView.reloadData()
                    print("Load \(cakes.count) cupakes.")
                }
            } else {
                print("Unable to parse JSON response.")
            }
        }.resume()
    }
    
    // MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        
        let cake = cupcakes[indexPath.row]
        
        cell.textLabel?.text = "\(cake.name) - $\(cake.price)"
        cell.detailTextLabel?.text = cake.description
        print(cake.description)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cupcakes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cake = cupcakes[indexPath.row]
        
        let alert = UIAlertController(title: "Order a \(cake.name)?", message: "Please enter your name", preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Order it!", style: .default, handler: { action in
            guard let name = alert.textFields?[0].text else { return }
            self.order(cake, name: name)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Order method
    func order(_ cake: Cupcake, name: String) {
        let order = Order(cakeName: cake.name, buyerName: name)
        let url = URL(string: "http://localhost:8080/order")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(order)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let item = try? decoder.decode(Order.self, from: data) {
                    print(item.buyerName)
                } else {
                    print("Bad JSON recieved back.")
                }
            }
        }.resume()
    }
}

