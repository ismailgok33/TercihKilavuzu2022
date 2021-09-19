//
//  ActionSheetLauncher.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 17.09.2021.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelectOption(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var window: UIWindow?
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    private var viewModel = ActionSheetViewModel()
    
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Sırala"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private lazy var headerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vazgeç", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        //let height = window.frame.height / 2

        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
//            self.tableView.frame.origin.y += 500
            self.showTableView(false)
        }
    }
    
    
    // MARK: - Helpers
    func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = window.frame.height / 2
        tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
//            self.tableView.frame.origin.y -= height
            self.showTableView(true)
        }
    }
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let heigth = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - heigth : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        tableView.rowHeight = 40
//        tableView.layer.cornerRadius = 5
//        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func setTableViewCheckmark(_ cell: ActionSheetCell) -> ActionSheetCell {
        switch viewModel.selectedOption {
        case .nameAsc:
            if cell.option == .nameAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .nameDesc:
            if cell.option == .nameDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .minScoreAsc:
            if cell.option == .minScoreAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .minScoreDesc:
            if cell.option == .minScoreDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .placementAsc:
            if cell.option == .placementAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .placementDesc:
            if cell.option == .placementDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .departmentAsc:
            if cell.option == .departmentAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .departmenDesc:
            if cell.option == .departmenDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .cityAsc:
            if cell.option == .cityAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .cityDesc:
            if cell.option == .cityDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .quotaAsc:
            if cell.option == .quotaAsc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        case .quotaDesc:
            if cell.option == .quotaDesc {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
                
            }
        }
        
        return cell
    }
    
   
    
}

// MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        cell.accessoryType = setTableViewCheckmark(cell).accessoryType
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        headerView.backgroundColor = .white
        
        headerView.addSubview(headerLabel)
        headerLabel.centerY(inView: headerView)
        headerLabel.centerX(inView: headerView)
//        headerLabel.frame = CGRect.init(x: headerView.frame.width / 2 - 20, y: 20, width: 100, height: 60 / 2)
    
        headerView.addSubview(headerButton)
        headerButton.centerY(inView: headerView)
        headerButton.anchor(right: headerView.rightAnchor, paddingRight: 20)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        viewModel.selectedOption = option
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelectOption(option: option)
        }
        
    }
}
