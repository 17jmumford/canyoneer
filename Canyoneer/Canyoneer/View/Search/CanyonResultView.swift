//
//  CanyonResultView.swift
//  Canyoneer
//
//  Created by Brice Pollock on 1/6/22.
//

import Foundation
import UIKit
import RxSwift

class CanyonResultView: UIView {
    
    enum Strings {
        static func name(with name: String) -> String {
            return "\(name) (canyon)"
        }
        static func rapCount(count: Int) -> String {
            return "\(count) raps"
        }
        static func rapLength(feet: Int) -> String {
            return "\(feet) ft"
        }
    }
    
    public let didSelect: Observable<Void>
    private let didSelectSubject: PublishSubject<Void>
    
    private let masterStackView = UIStackView()
    // RHS details
    private let detailStackView = UIStackView()
    
    private let name = UILabel()
    private let rappels = UILabel()
    private let maxRappelLength = UILabel()
    
    init() {
        self.didSelectSubject = PublishSubject()
        self.didSelect = self.didSelectSubject.asObservable()
        
        super.init(frame: .zero)
    
        self.addSubview(self.masterStackView)
        self.masterStackView.constrain.fillSuperview()
        
        self.masterStackView.axis = .horizontal
        self.masterStackView.spacing = Grid.medium
        self.masterStackView.addArrangedSubview(self.name)
        self.masterStackView.addArrangedSubview(self.detailStackView)
        
        self.detailStackView.axis = .vertical
        self.detailStackView.spacing = Grid.medium
        self.detailStackView.addArrangedSubview(self.rappels)
        self.detailStackView.addArrangedSubview(self.maxRappelLength)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with result: SearchResult) {
        guard let canyon = result.canyonDetails else {
            return
        }
        
        self.name.text = Strings.name(with: canyon.name)
        self.rappels.text = Strings.rapCount(count: canyon.numRaps)
        self.maxRappelLength.text = Strings.rapLength(feet: canyon.maxRapLength)
    }
    
    @objc func didTap() {
        self.didSelectSubject.onNext(())
    }
}
