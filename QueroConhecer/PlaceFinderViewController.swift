//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by EPR Exatron on 08/08/2018.
//  Copyright © 2018 Exatron. All rights reserved.
//

import UIKit
import MapKit


protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
}

class PlaceFinderViewController: UIViewController {

    
    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoading: UIView!
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0 // segurando o dedo por 2 segundo em ponto do mapa o mesmo abre o alert para salvar na lista
        mapView.addGestureRecognizer(gesture)
    }
    // ao usar o #selector o mesmo exige o @OBJC (parametro do obctive-C), pois era usado antes do swift e para utilizá-lo no swift devemos implementar o @objc antes do método.
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
         load(show: true)
            let point = gesture.location(in: mapView) //Pega a localizacao onde o usuario tocou
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                self.load(show: false)
                
                if error == nil {
                    if !self.savePlace(with: placemarks?.first){
                        self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                    }
                }else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            })
        }
    }

    
    @IBAction func findCity(_ sender: UIButton) {
        
    tfCity.resignFirstResponder()
    //recuperar dados
    let address = tfCity.text!
        load(show: true)
        
    let geoCoder = CLGeocoder()
        //placemarks informacao de um local
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.load(show: false)
            //guard let placemark = placemarks?.first else {return}
            //print(Place.getFormattedAddress(with: placemark))
            
            if error == nil {
                if !self.savePlace(with: placemarks?.first){
                self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
                }
            }else {
                    self.showMessage(type: .error("Erro desconhecido"))
                }
            }
        }
    
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
            
        }
        //print(Place.getFormattedAddress(with: placemark))
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude, address: address)
        
        //mostra a regiao para o usuario
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 3500, 3500)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        
        return true
    }
    
    //Criando alertas
    func showMessage(type: PlaceFinderMessageType) {
        let title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
            case .confirmation(let name):
                
            title = "Local encontrado"
            message = "Deseja adicionar \(name)?"
            hasConfirmation = true
            
            case .error(let errorMessage):
                
            title = "Erro"
            message = errorMessage
            
            
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.delegate?.addPlace(self.place)
                self.dismiss(animated: true, completion: nil)
                
            })
            alert.addAction(confirmAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func load(show: Bool) {
        viLoading.isHidden = !show
        
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
        
    }
    
    //fecha o dialog
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
