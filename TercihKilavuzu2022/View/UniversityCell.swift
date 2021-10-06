//
//  UniversityCell.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import GoogleMobileAds

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
        label.numberOfLines = 0
        return label
    }()
    
    private let departmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Bölümü (İngilizce)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var minScoreLabel: UILabel = createLowerLabels(name: "Taban Puanı")
    
    private lazy var minScoreValue: UILabel = createLowerLabelValue(value: 0)
    
    private lazy var placementLabel: UILabel = createLowerLabels(name: "Sıralaması")
    
    private lazy var placementValue: UILabel = createLowerLabelValue(value: 0)
    
    private lazy var quotaLabel: UILabel = createLowerLabels(name: "Kontenjanı")
    
    private lazy var quotaValue: UILabel = createLowerLabelValue(value: 0)
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .systemPink
//        button.setDimensions(width: 50, height: 50)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let typeLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAY", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .green
//        button.setDimensions(width: 30, height: 10)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        configureCellUI()
        addTapGestureForLiking()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleFavoriteButtonTapped() {
        delegate?.handleFavoriteTapped(self)
        animate()
    }
    
    @objc func handleDoubleTap() {
        delegate?.handleFavoriteTapped(self)
        animate()
    }
    
    // MARK: - Helpers
    
    func configureCellUI() {
        backgroundColor = .white
        
        addSubview(universityNameLabel)
        universityNameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        addSubview(departmentLabel)
        departmentLabel.anchor(top: universityNameLabel.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(favoriteButton)
        favoriteButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 30, paddingRight: 20)
        
        let minScoreStack = createLowerStackViews(subviews: [minScoreLabel, minScoreValue])
        
        let placementStack = createLowerStackViews(subviews: [placementLabel, placementValue])
        
        let quotaStack = createLowerStackViews(subviews: [quotaLabel, quotaValue])
        
        let bottomStack = UIStackView(arrangedSubviews: [minScoreStack, placementStack, quotaStack])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        addSubview(typeLabel)
//        typeLabel.anchor(top: departmentLabel.bottomAnchor, right: rightAnchor, paddingTop: 24 + 50 / 2, paddingRight: 12)
        typeLabel.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 12, paddingRight: 12)
        typeLabel.setDimensions(width: 50, height: 25)
        
        addSubview(bottomStack)
        bottomStack.anchor(top: departmentLabel.bottomAnchor, left: leftAnchor, right: typeLabel.leftAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        
    }
    
    private func createLowerLabels(name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }
    
    private func createLowerLabelValue(value: Int) -> UILabel {
        let label = UILabel()
        label.text = String(value)
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
        minScoreValue.text = String(university.minScore)
        placementValue.text = String(university.placement)
        quotaValue.text = String(university.quota)
        favoriteButton.setImage(viewModel.favoriteButtonImage, for: .normal)
        favoriteButton.tintColor = viewModel.favoriteButtonColor
        typeLabel.setTitle(university.type, for: .normal)
        typeLabel.backgroundColor = viewModel.typeColor
    }
    
    private func addTapGestureForLiking() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    private func animate() {
        guard let university = university else { return }
        let viewModel = UniversityViewModel(university: university)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = self.favoriteButton.transform.scaledBy(x: viewModel.favoriteButtonScale, y: viewModel.favoriteButtonScale)
        }, completion: { _ in
          UIView.animate(withDuration: 0.1, animations: {
            self.favoriteButton.transform = CGAffineTransform.identity
          })
        })
      }
}
