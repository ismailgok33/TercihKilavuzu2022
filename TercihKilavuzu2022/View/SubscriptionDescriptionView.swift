//
//  SubscriptionDescriptionView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import UIKit

class SubscriptionDescriptionView: UIView {

    // MARK: - Properties
    
    private let descriptorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.text = "Bir kere öde, sınırsız erişime sahip ol."
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.text = "\(SUBSCRIPTION_VALUE) TRY"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(descriptorLabel)
        addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        descriptorLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        priceLabel.anchor(top: descriptorLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
    }

}
