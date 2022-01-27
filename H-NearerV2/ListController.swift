//
//  AddEditController.swift
//  H-NearerV2
//
//  Created by Clement Rays on 01/01/2022.
//  Copyright © 2022 Clement Rays. All rights reserved.
//

import UIKit
import CoreLocation

class ListController: UIViewController,  UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var table: UITableView!
    var points: [Point] = []
    var selectedPoint = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellPoint")
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            PointManager.fetchPoint() {
                results in self.points = results
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = table.dequeueReusableCell(withIdentifier: "cellPoint", for: indexPath)
        cell.textLabel!.text = "\(points[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") {
            [weak self] (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self?.deletePoint(name: (cell?.textLabel?.text)!)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Editer") {
            [weak self] (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath)
            self!.selectedPoint = cell?.textLabel?.text as! String
            self?.editPoint()
            completionHandler(true)
        }
        editAction.backgroundColor = .systemOrange
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfig
    }
    
    func deletePoint(name: String) {
        let alert = UIAlertController(title: "Supprimer le point", message: "Souhaitez vous supprimer le point définitivement ?", preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default))
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.destructive, handler: { (_) in
            let group1 = DispatchGroup()
            group1.enter()
            DispatchQueue.main.async {
                PointManager.deletePoint(name: name)
                group1.leave()
            }
            group1.notify(queue: .main) {
                let alert = UIAlertController(title: "Point Supprimé", message: "Le point a été supprimé", preferredStyle:UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) in
                    let group = DispatchGroup()
                    group.enter()
                    DispatchQueue.main.async {
                        PointManager.fetchPoint() {
                            results in self.points = results
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.table.reloadData()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editPoint() {
        performSegue(withIdentifier: "EditView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditView" {
            let passed = segue.destination as! EditViewController
            passed.tvName = selectedPoint
            passed.points = points
        }
    }
    @IBAction func refresh(_ sender: Any) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            PointManager.fetchPoint() {
                results in self.points = results
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.table.reloadData()
        }
    }
}
