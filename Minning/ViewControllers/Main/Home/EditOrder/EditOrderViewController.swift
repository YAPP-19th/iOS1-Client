//
//  EditOrderViewController.swift
//  Minning
//
//  Created by denny on 2021/10/02.
//  Copyright © 2021 Minning. All rights reserved.
//

import CommonSystem
import DesignSystem
import Foundation
import SharedAssets
import SnapKit

final class EditOrderViewController: BaseViewController {
    lazy var mainTableView: UITableView = {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.dragInteractionEnabled = true
        $0.dragDelegate = self
        $0.dropDelegate = self
        $0.contentInset = .init(top: 38, left: 0, bottom: 0, right: 0)
        $0.register(EditOrderCell.self, forCellReuseIdentifier: EditOrderCell.identifier)
        return $0
    }(UITableView())
    
    private let viewModel: EditOrderViewModel
    
    private var tempDataList = ["아침에 신문~", "모닝 커피", "달리기"]
    
    init(viewModel: EditOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
    }
    
    private func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar as? PlainUINavigationBar {
            navigationBar.titleContent = "순서 편집"
            navigationBar.removeDefaultShadowImage()
            
            navigationItem.setLeftPlainBarButtonItem(UIBarButtonItem(image: UIImage(sharedNamed: "backArrow"), style: .plain, target: self, action: #selector(onClickBackButton(_:))))
        }
    }
    
    @objc
    private func onClickBackButton(_ sender: Any?) {
        showDismissAlert()
    }
    
    @objc
    private func onClickSaveButton(_ sender: Any?) {
        print("save")
    }
    
    private func showDismissAlert() {
        showAlert(title: "순서 편집", message: "변경된 순서가 저장되지 않았습니다.\n화면을 벗어나면 순서가 초기화됩니다.") { [weak self] _ in
            self?.viewModel.goToBack()
        }
    }
    
    override func bindViewModel() {
        
    }
    
    override func setupViewLayout() {
        view.backgroundColor = .minningLightGray100
        mainTableView.backgroundColor = .clear

        [mainTableView].forEach {
            view.addSubview($0)
        }
                
        mainTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(0)
        }
    }
}

extension EditOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditOrderCell.identifier, for: indexPath) as? EditOrderCell else {
            return .init()
        }
        cell.configure(title: tempDataList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = self.tempDataList[sourceIndexPath.row]
        self.tempDataList.remove(at: sourceIndexPath.row)
        self.tempDataList.insert(moveCell, at: destinationIndexPath.row)
    }
}

extension EditOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
}

extension EditOrderViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension EditOrderViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}
