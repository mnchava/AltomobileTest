//
//  ListViewController.swift
//  test2
//
//  Created by ChavaFerrer on 14/01/20.
//  Copyright © 2020 ChavaFerrer. All rights reserved.
//

import UIKit

class animalCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var animalLabel: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    var animalLife = 1
    var animalName = "Animal"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ListViewController: UITableViewController {
    var animales: [animalConFoto] = []
    var actualizarLista: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        let animalData = downloader()
        
        actualizarLista = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.tableView.reloadData()
            self.animales = animalData.getAnimal()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animales.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! animalCell

        let animal = animales[indexPath.row]
        cell.animalName = animal.animal.name
        cell.animalLife = animal.animal.life
        if animal.animal.name == "Altomobile" {
            cell.animalImage.image = animal.image
            cell.animalImage.layer.frame = (CGRect(x: 24, y: 1, width: 366, height: 68))
            cell.animalLabel.text = ""
        }else{
            cell.animalImage.layer.masksToBounds = false
            cell.animalImage.layer.cornerRadius = cell.animalImage.frame.height/2
            cell.animalImage.clipsToBounds = true
            cell.animalImage.contentMode = .scaleAspectFill
            cell.animalLabel.text = animal.animal.name
            cell.animalImage.image = animal.image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animal = animales[indexPath.row]
        
        if animal.animal.name == "Altomobile" {
            let alert = UIAlertController(
                title: "\(animal.animal.name)",
                message: "\(animal.animal.name) was founded in \(animal.animal.life).",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(
                title: "Life for \(animal.animal.name)",
                message: "\(animal.animal.name) lives for \(animal.animal.life) years.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
