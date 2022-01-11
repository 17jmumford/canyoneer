//
//  CanyonViewController.swift
//  Canyoneer
//
//  Created by Brice Pollock on 1/6/22.
//

import Foundation
import UIKit

class CanyonViewController: ScrollableStackViewController {
    enum Strings {
        static func name(with name: String) -> String {
            return "Canyon: \(name)"
        }
    }

    private let name = UILabel()
    private let detailView = CanyonDetailView()
    private let storage = UserPreferencesStorage.favorites
    
    private let canyon: Canyon
    
    init(canyon: Canyon) {
        self.canyon = canyon
        super.init(insets: .init(all: .medium), atMargin: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        self.masterStackView.axis = .vertical
        self.masterStackView.spacing = Grid.medium
        self.masterStackView.addArrangedSubview(self.name)
        self.masterStackView.addArrangedSubview(self.detailView)
        
        self.title = Strings.name(with: canyon.name)
        self.navigationItem.backButtonTitle = ""
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(self.didRequestShare))
        
        let favoriteImage = UserPreferencesStorage.isFavorite(canyon: canyon) ? "star.fill" : "star"
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: favoriteImage), style: .plain, target: self, action: #selector(self.didRequestFavoriteToggle))
        self.navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
        self.detailView.configure(with: canyon)
    }
    
    @objc func didRequestShare() {
        let to = ""
        let subject = "Check out this cool canyon: \(self.canyon.name)"
        var body = "I found '\(self.canyon.name) \(CanyonDetailView.Strings.summaryDetails(for: canyon))' on the 'Canyoneer' app."
        if let ropeWikiString = self.canyon.ropeWikiURL?.absoluteString {
            body += " Check out the canyon on Ropewiki: \(ropeWikiString)"
        }
        
        guard let urlString = "mailto:\(to)?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            Global.logger.error("Unable to open url: \(url)")
        }
    }
    
    @objc func didRequestFavoriteToggle() {
        let isFavorited = UserPreferencesStorage.isFavorite(canyon: self.canyon)
        if isFavorited {
            UserPreferencesStorage.removeFavorite(canyon: canyon)
            self.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "star")
        } else {
            UserPreferencesStorage.addFavorite(canyon: canyon)
            self.navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "star.fill")
        }
    }
}
