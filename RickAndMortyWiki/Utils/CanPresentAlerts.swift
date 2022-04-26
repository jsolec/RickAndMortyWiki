//
//  CanPresentAlerts.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 26/4/22.
//

import UIKit

protocol CanPresentAlerts: UIViewController {
    func presentInfoAlert(title: String, message: String, dismissTitle: String)
}

extension CanPresentAlerts {
    
    //Specific Alert conveniences
    func presentInfoAlert(title: String, message: String, dismissTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
