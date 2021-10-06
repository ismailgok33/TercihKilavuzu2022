//
//  CityListView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class CityListView: UIView {
    
    // MARK: - Properties
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Şehirler"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var selectedCitiesField: UITextField = {
        let tf = UITextField()
        tf.attributedText = NSAttributedString(string: "Şehir seçilmedi...")
//        tf.font = .systemFont(ofSize: 12, weight: .semibold)
        tf.font = UIFont.italicSystemFont(ofSize: 12)
        tf.textColor = .white
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        
        addSubview(viewTitle)
//        viewTitle.centerY(inView: self)
        viewTitle.anchor(top:topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(selectedCitiesField)
        selectedCitiesField.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
    }
}
