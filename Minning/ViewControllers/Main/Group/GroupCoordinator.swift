//
//  GroupCoordinator.swift
//  Minning
//
//  Created by denny on 2021/10/01.
//  Copyright © 2021 Minning. All rights reserved.
//

import DesignSystem
import Foundation

protocol GroupRoute {
    func showDetail()
    func showJoinGroup(completion: (() -> Void)?)
    func goToNewGroup()
    
    func goToBack()
    func dismissVC()
}

class GroupCoordinator {
    let navigationController: UINavigationController
    
    private let dependencies: GroupDIContainer
    private let coordinator: MainCoordinator
    
    init(navigationController: UINavigationController,
         dependencies: GroupDIContainer,
         coordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    func start() {
        let viewModel = GroupViewModel(coordinator: self)
        let reportVC = GroupViewController(viewModel: viewModel)
        navigationController.setViewControllers([reportVC], animated: false)
    }
}

extension GroupCoordinator: GroupRoute {
    func showDetail() {
        let detailVC = dependencies.createDetail(self)
        detailVC.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(detailVC, animated: true, completion: nil)
    }
    
    func showJoinGroup(completion: (() -> Void)?) {
        let joinGroupVC = dependencies.createJoinGroup(self)
        joinGroupVC.modalPresentationStyle = .overCurrentContext
        joinGroupVC.completion = completion
        navigationController.topViewController?.presentedViewController?.present(joinGroupVC, animated: true, completion: nil)
    }
    
    func goToNewGroup() {
        let newGroupVC = dependencies.createNewGroup(self)
        newGroupVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(newGroupVC, animated: true)
    }
    
    func goToBack() {
        navigationController.popViewController(animated: true)
    }
    
    func dismissVC() {
        navigationController.topViewController?.dismiss(animated: true, completion: nil)
    }
}
