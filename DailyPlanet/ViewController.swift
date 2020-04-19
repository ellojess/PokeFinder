//
//  ViewController.swift
//  DailyPlanet
//
//  Created by Thomas Vandegriff on 2/7/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let cellId = "cellId"
    var pokemon: [Pokemon] = []
    let url = "https://pokeapi.co/api/v2/pokemon/"
    var count = 964 // total count from API TODO: access count dynamically
    var nextURL: String? = "https://pokeapi.co/api/v2/pokemon/?offset=40&limit=20"
    var nextBatch: String? = nil
    

    @IBOutlet weak var nasaDailyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHeaderData()
        fetchPokemonName(url: url)
        setupTableView()
    }

    //MARK: Data Fetch functions
    
    func fetchHeaderData() {
        
        let defaultSession = URLSession(configuration: .default)
        
        // Create URL
        let url = URL(string: "https://httpbin.org/headers")
        
        // Create Request
        let request = URLRequest(url: url!)
        
        // Create Data Task
        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            print("data is: ", data!)
            print("response is: ", response!)
            
        })
        dataTask.resume()
    }
    
    
     // CODE BASE for In-Class Activity I
    func fetchPokemonName(url: String) {
        
        //TODO: Create session configuration here
        let defaultSession = URLSession(configuration: .default)

        //TODO: Create URL (...and send request and process response in closure...)
        if let url = URL(string: url) {
            
           //TODO: Create Request here
            let request = URLRequest(url: url)
            
            // Create Data Task...
            let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                print("data is: ", data!)
                print("response is: ", response!)
                
                // handle error
                if let error = error {
                    print("failed to fetch, error: ", error.localizedDescription)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print(json)
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let pokemans = try decoder.decode(List.self, from: data)
                    self.pokemon.append(contentsOf: pokemans.results)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    self.nextBatch = pokemans.next!
                    
                } catch {
                    print("JSON error: ", error.localizedDescription)
                }
                
            })
            
            dataTask.resume()
        }
    }

    
    func setupTableView() {
      view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pokemon.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    cell.textLabel?.text = pokemon[indexPath.row].name
    
    if indexPath.row == pokemon.count - 1 { // last cell
        if count > pokemon.count { // only fetch more when there's more in the API
            fetchPokemonName(url: nextURL!)
//            loadMorePokemon()
        }
    }
    
    return cell
  }
}
