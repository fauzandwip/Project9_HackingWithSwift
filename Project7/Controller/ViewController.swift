//
//  ViewController.swift
//  Project7
//
//  Created by Fauzan Dwi Prasetyo on 30/04/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var backUpPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
    }
    
    func submit(_ word: String) {
        petitions.removeAll()
        
        for filter in backUpPetitions {
            if filter.title.contains(word) {
                petitions.append(filter)
                continue
            }
            if filter.body.contains(word) {
                petitions.append(filter)
            }
        }
        
        tableView.reloadData()
    }

    func getData() {
        var urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            backUpPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }

}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petition = petitions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailPetition = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
