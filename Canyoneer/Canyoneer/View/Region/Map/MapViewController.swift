//
//  MapViewController.swift
//  Canyoneer
//
//  Created by Brice Pollock on 1/6/22.
//

import Foundation
import MapKit
import RxSwift

class CanyonAnnotation: MKPointAnnotation {
    public let canyon: Canyon
    
    init(canyon: Canyon) {
        self.canyon = canyon
        super.init()
        self.title = canyon.name
        self.coordinate = canyon.coordinate
    }
}

class MapViewController: UIViewController {
    private let mapView = MKMapView()
    private let viewModel = MapViewModel()
    private let bag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mapView)
        self.mapView.constrain.fillSuperview()
        self.mapView.delegate = self
        
        let utahCenter = CLLocationCoordinate2D(latitude: 39.3210, longitude: -111.0937)
        self.mapView.region = MKCoordinateRegion(center: utahCenter, span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        
        self.viewModel.canyons().subscribe { [weak self] canyons in
            canyons.forEach { canyon in
                let annotation = CanyonAnnotation(canyon: canyon)
                self?.mapView.addAnnotation(annotation)
            }
        } onFailure: { error in
            Global.logger.error("Failed to load canyon data for map")
        }.disposed(by: self.bag)
    }
}
