//
//  LoadingView.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

final class LoadingView: UIView {
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func show(in view: UIView) {
        activityIndicator.frame = view.bounds
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        view.addSubview(self)
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        removeFromSuperview()
    }
}
