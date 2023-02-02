//  GyroData - ViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class MeasureListViewController: UIViewController {
    
    private enum Constant {
        static let title = "목록"
        static let measureButtonTitle = "측정"
        static let playSwipeAction = "Play"
        static let deleteSwipeAction = "Delete"
    }
    
    enum Schedule: Hashable {
        case main
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Schedule, MotionData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Schedule, MotionData>
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.register(MeasureTableViewCell.self,
                           forCellReuseIdentifier: MeasureTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var dataSource: DataSource?
    private var measureListViewModel = MeasureListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = setupTableViewDataSource()
        setupNavigation()
        setupViews()
        tableView.delegate = self
        bind()
    }
    
    private func bind() {
        measureListViewModel.model.bind { [weak self] item in
            self?.appendData(item: item)
        }
    }
    
    private func setupNavigation() {
        let pushMeasureViewAction = UIAction { _ in
            let measureViewController = MeasureViewController()
            self.push(viewController: measureViewController)
        }
        
        navigationItem.title = Constant.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.measureButtonTitle,
                                                            primaryAction: pushMeasureViewAction)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableViewDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MeasureTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? MeasureTableViewCell else { return UITableViewCell() }
            
            cell.configure(createdAt: item.createdAt,
                           sensorType: item.sensorType.rawValue,
                           runtime: item.runtime)
            
            return cell
        }
        
        return dataSource
    }
    
    private func appendData(item: [MotionData]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        dataSource?.apply(snapshot)
    }
    
    private func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MeasureListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController = DetailViewController()
        push(viewController: detailViewController)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal,
                                            title: Constant.playSwipeAction) { (_, _, success) in
            
        }
        playAction.backgroundColor = .systemGreen
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: Constant.deleteSwipeAction) { (_, _, success) in
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction,playAction])
    }
}