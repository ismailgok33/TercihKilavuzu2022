//
//  UniversityCell.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit

protocol UniversityCellDelegate: AnyObject {
    func handleFavoriteTapped(_ cell: UniversityCell)
}

class UniversityCell: UITableViewCell {

    // MARK: - Properties
    
    var university: University? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: UniversityCellDelegate?
    
    private let universityNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Universitesi (Ankara)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let departmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Bölümü (İngilizce)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var minScoreLabel: UILabel = createLowerLabels(name: "Taban Puanı")
    
    private lazy var minScoreValue: UILabel = createLowerLabels(name: "00000")
    
    private lazy var placementLabel: UILabel = createLowerLabels(name: "Sıralaması")
    
    private lazy var placementValue: UILabel = createLowerLabels(name: "00000")
    
    private lazy var quotaLabel: UILabel = createLowerLabels(name: "Kontenjanı")
    
    private lazy var quotaValue: UILabel = createLowerLabels(name: "00")
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .systemPink
        button.setDimensions(width: 50, height: 50)
        button.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleFavoriteButtonTapped() {
        delegate?.handleFavoriteTapped(self)
    }
    
    // MARK: - Helpers
    
    func configureCellUI() {        
        addSubview(universityNameLabel)
        universityNameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        addSubview(departmentLabel)
        departmentLabel.anchor(top: universityNameLabel.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(favoriteButton)
        favoriteButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 30, paddingRight: 12)
        
        let minScoreStack = createLowerStackViews(subviews: [minScoreLabel, minScoreValue])
        
        let placementStack = createLowerStackViews(subviews: [placementLabel, placementValue])
        
        let quotaStack = createLowerStackViews(subviews: [quotaLabel, quotaValue])
        
        let bottomStack = UIStackView(arrangedSubviews: [minScoreStack, placementStack, quotaStack])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        addSubview(bottomStack)
        bottomStack.anchor(top: departmentLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
    }
    
    private func createLowerLabels(name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }
    
    private func createLowerStackViews(subviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return stack
    }
    
    private func configure() {
        guard let university = university else { return }
        let viewModel = UniversityViewModel(university: university)
                        
        universityNameLabel.attributedText = viewModel.universityNameLabel
        departmentLabel.attributedText = viewModel.departmentLabel
        minScoreValue.text = university.minScore
        placementValue.text = university.placement
        quotaValue.text = university.quota
        favoriteButton.setImage(viewModel.favoriteButtonImage, for: .normal)
    }
}
