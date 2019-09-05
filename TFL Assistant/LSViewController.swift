//
//  LSViewController.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 23/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//

import UIKit

struct Line : Decodable {
    let name : String
    let lineStatuses : [Status]
}

struct Status : Decodable {
    let statusSeverityDescription : String
    
    private enum CodingKeys : String, CodingKey {
        case statusSeverityDescription = "statusSeverityDescription"
    }
    
}

class LSViewController: UIViewController, UITableViewDelegate{
    
    var Statuses = [Line]()

    @IBOutlet weak var lineStatusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineStatusTableView.delegate = self
        lineStatusTableView.dataSource = self
        
        self.lineStatusTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        fetchJSON()
        self.lineStatusTableView.reloadData()
        
    }
    

    
    fileprivate func fetchJSON() {
        
        let url = URL(string: "https://api.tfl.gov.uk/Line/Mode/tube/Status?detail=true&app_id=c2354f12&app_key=561f202075aab38b2ed13479dff97241")!
        
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            
            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }
            
            
            if let Statuses = try? JSONDecoder().decode([Line].self, from: data) {
                
                self.Statuses = Statuses
                
                self.lineStatusTableView.reloadData()
                
                print(self.Statuses)
            }
            
            
            print(data)
            
            } .resume()
    }

}

extension LSViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Statuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let status = Statuses[indexPath.item]
        cell.textLabel?.font = UIFont(name:"Futura", size:20)
        cell.detailTextLabel?.font = UIFont(name:"Futura", size:14)
        cell.textLabel?.text = status.name
        cell.detailTextLabel?.text = status.lineStatuses[0].statusSeverityDescription
        
        if status.name == "Bakerloo" {
            cell.backgroundColor = UIColor(red: 137.0/255, green: 78.0/255, blue: 36.0/255, alpha: 1.0)
        } else if status.name == "Central" {
            cell.backgroundColor = UIColor(red: 220.0/255, green: 36.0/255, blue: 31.0/255, alpha: 1.0)
        } else if status.name == "Circle" {
            cell.backgroundColor = UIColor(red: 255.0/255, green: 206.0/255, blue: 0.0, alpha: 1.0)
        } else if status.name == "District" {
            cell.backgroundColor = UIColor(red: 0.0, green: 114.0/255, blue: 41.0/255, alpha: 1.0)
        } else if status.name == "Hammersmith & City" {
            cell.backgroundColor = UIColor(red: 215.0/255, green: 153.0/255, blue: 175.0/255, alpha: 1.0)
        } else if status.name == "Jubilee" {
            cell.backgroundColor = UIColor(red: 134.0/255, green: 143.0/255, blue: 152.0/255, alpha: 1.0)
        } else if status.name == "Metropolitan" {
            cell.backgroundColor = UIColor(red: 117.0/255, green: 16.0/255, blue: 86.0/255, alpha: 1.0)
        } else if status.name == "Northern" {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.textLabel?.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
            cell.detailTextLabel?.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        } else if status.name == "Piccadilly" {
            cell.backgroundColor = UIColor(red: 0.0/255, green: 25.0/255, blue: 168.0/255, alpha: 1.0)
            cell.textLabel?.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
            cell.detailTextLabel?.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        } else if status.name == "Victoria" {
            cell.backgroundColor = UIColor(red: 0.0/255, green: 160.0/255, blue: 226.0/255, alpha: 1.0)
        } else if status.name == "Waterloo & City" {
            cell.backgroundColor = UIColor(red: 118.0/255, green: 208.0/255, blue: 189.0/255, alpha: 1.0)
        }
        
        
        return cell
    }
}
