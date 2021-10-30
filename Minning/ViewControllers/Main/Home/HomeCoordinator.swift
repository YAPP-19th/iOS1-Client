//
//  HomeCoordinator.swift
//  Minning
//
//  Created by denny on 2021/10/01.
//  Copyright © 2021 Minning. All rights reserved.
//

import DesignSystem
import Foundation

protocol HomeRoute {
    func goToPhrase()
    func goToRecommend()
    func goToAdd()
    func goToReview()
    func goToEditOrder()
    func goToNotification()
    func goToMyPage()
    func goToNotice()
    func goToBack()
}

class HomeCoordinator {
    let navigationController: UINavigationController
    
    private let dependencies: HomeDIContainer
    private let coordinator: MainCoordinator
    
    init(navigationController: UINavigationController,
         dependencies: HomeDIContainer,
         coordinator: MainCoordinator) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let homeVC = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([homeVC], animated: false)
    }
}

extension HomeCoordinator: HomeRoute {
    func goToPhrase() {
        let phraseVC = dependencies.createPhrase(self)
        navigationController.topViewController?.present(phraseVC, animated: true, completion: nil)
    }
    
    func goToRecommend() {
        let recommendVC = dependencies.createRecommend(self)
        navigationController.topViewController?.present(recommendVC, animated: true, completion: nil)
    }
    
    func goToAdd() {
        let addVC = dependencies.createAdd(self)
        navigationController.pushViewController(addVC, animated: true)
    }
    
    func goToReview() {
        let reviewVC = dependencies.createReview(self)
        reviewVC.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(reviewVC, animated: true, completion: nil)
    }
    
    func goToEditOrder() {
        let editVC = dependencies.createEditOrder(self)
        navigationController.pushViewController(editVC, animated: true)
    }
    
    func goToNotification() {
        let notificationVC = dependencies.createNotification(self)
        notificationVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(notificationVC, animated: true)
    }
    
    func goToMyPage() {
        let myPageVC = dependencies.createMyPage(self)
        navigationController.pushViewController(myPageVC, animated: true)
    }
    
    func goToNotice() {
        let noticeVC = dependencies.createNotice(self)
        navigationController.pushViewController(noticeVC, animated: true)
    }
    
    func goToBack() {
        navigationController.popViewController(animated: true)
    }
}
