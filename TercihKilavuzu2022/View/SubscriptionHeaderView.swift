//
//  SubscriptionHeaderView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import UIKit

class SubscriptionHeaderView: UIView {

    // MARK: - Properties
    
    let headerImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "crown.fill"))
        iv.frame = CGRect(x: 0, y: 0, width: 110, height: 110)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPink
        clipsToBounds = true
        addSubview(headerImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = CGRect(x: frame.width / 2 - 55, y: frame.height / 2 - 55, width: 110, height: 110)
    }

}
