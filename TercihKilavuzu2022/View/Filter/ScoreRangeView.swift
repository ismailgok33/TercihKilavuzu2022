//
//  ScoreRangeView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class ScoreRangeView: UIView {
    
    // MARK: - Properties
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Puan Aralığı"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let minScore: UITextField = {
        let tf = UITextField()
        
        let spacer = UIView()
        spacer.setDimensions(width: 12, height: 40)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(white: 1, alpha: 0.2)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 5
        tf.attributedPlaceholder = NSAttributedString(string: "Minimum", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        return tf
    }()
    
    private let maxScore: UITextField = {
        let tf = UITextField()
        
        let spacer = UIView()
        spacer.setDimensions(width: 12, height: 40)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(white: 1, alpha: 0.2)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 5
        tf.attributedPlaceholder = NSAttributedString(string: "Maximum", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
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
        backgroundColor = .filterBackgroundColor
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [minScore, maxScore])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        addSubview(stack)
        stack.anchor(top:viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
}
