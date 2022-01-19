//
//  MainViewController.swift
//  Canyoneer
//
//  Created by Brice Pollock on 1/6/22.
//

import Foundation
import UIKit
import RxSwift

class MainViewController: UIViewController {
    private let canyonService = RopeWikiService()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contained = MainTabBarController.make()
        self.addChild(contained)
        self.view.addSubview(contained.view)
        contained.view.constrain.top(to: self.view, atMargin: true)
        contained.view.constrain.leading(to: self.view)
        contained.view.constrain.trailing(to: self.view)
        contained.view.constrain.bottom(to: self.view, atMargin: true)
        contained.didMove(toParent: self)
        
        // load the canyon data
        self.canyonService.canyons().subscribe().disposed(by: self.bag)
        
        // preload the mapview for speed
        MainTabBarController.controller(for: .map).viewDidLoad()
    }
}
