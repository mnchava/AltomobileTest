import UIKit
import Alamofire
import SwiftyJSON

struct Animal: Hashable, Codable, Identifiable {
    var id: Int
    var life: Int
    var name: String
    var pictureURL: String
}

struct animalConFoto: Identifiable{
    var animal: Animal
    var id: Int
    var image: UIImage
}

class downloader{
    var arrayAnimal: [Animal] = []
    let decoder = JSONDecoder()
    var arrayConFotos: [animalConFoto] = [animalConFoto(animal: Animal(id: 5000, life: 2015, name: "Altomobile", pictureURL: URL(fileReferenceLiteralResourceName: "logo.png").absoluteString), id: 5000, image: UIImage(imageLiteralResourceName: "logo.png"))]
    let jsonURL = "https://flavioruben.herokuapp.com/data.json"
    var completionTime = 0.0

    
    init() {
        downloadJSON()
    }
    
    func downloadJSON(){
        print("\nse comenzo a descargar data.json")
        Alamofire.request(jsonURL)
            .responseJSON { response in
                if JSONSerialization.isValidJSONObject(response.result.value as Any){
                    do {
                        print("se comenzo a guardar data.json")
                        let fileURL = try FileManager.default
                            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                            .appendingPathComponent("data.json")
                        try JSONSerialization.data(withJSONObject: response.result.value as Any)
                            .write(to: fileURL)
                        print("se termino de guardar data.json")
                        self.leerJSON()
                        self.getPhotos()
                    } catch {
                        print("Error guardando data.json: \(error)")
                    }
                }
            }
    }
    
    func leerJSON(){
        let data: Data
        let fileURL: URL
        do{
            fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("data.json")
            do {
                data = try Data(contentsOf: fileURL)
                do {
                    self.arrayAnimal =  try decoder.decode([Animal].self, from: data)
                    //print("Datos leidos de data.json: \n\(self.arrayAnimal)\n")
                } catch {
                    print("Error al leer datos.json: \(error)")
                }
            } catch {
                fatalError("Error cargando data:\n\(error)")
            }
        }catch{
            print("No se encontro data.json:\(error)")
        }
    }
    
    func getAnimal()->[animalConFoto]{
        return self.arrayConFotos
    }
    
    func getPhotos(){
        for animal in self.arrayAnimal{
            do{
                if animal.pictureURL.isEmpty {
                    self.arrayConFotos.append(animalConFoto(animal: Animal(id: animal.id, life: animal.life, name: animal.name, pictureURL: animal.pictureURL), id: animal.id, image: UIImage(imageLiteralResourceName: "default.png")))
                }else{
                    Alamofire.request(try animal.pictureURL.asURL()).responseData{ response in
                        if let data = response.value {
                            self.arrayConFotos.append(animalConFoto(animal: Animal(id: animal.id, life: animal.life, name: animal.name, pictureURL: animal.pictureURL), id: animal.id, image: UIImage(data: data)!))
                        }
                    }
                }
            }catch{
                print("no se pudo obtener imagen de: \(animal.name)\n\(error)")
            }
        }
    }
}
