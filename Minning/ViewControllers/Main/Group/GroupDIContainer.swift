//
//  GroupDIContainer.swift
//  Minning
//
//  Created by denny on 2021/10/01.
//  Copyright © 2021 Minning. All rights reserved.
//

import DesignSystem
import Foundation

final class GroupDIContainer {
    func createDetail(_ coordinator: GroupCoordinator) -> GroupDetailViewController {
        let viewModel = GroupDetailViewModel(coordinator: coordinator)
        let detailVC = GroupDetailViewController(viewModel: viewModel)
        return detailVC
    }
    
    func createJoinGroup(_ coordinator: GroupCoordinator) -> JoinGroupViewController {
        let viewModel = JoinGroupViewModel(coordinator: coordinator)
        let joinGroupVC = JoinGroupViewController(viewModel: viewModel)
        return joinGroupVC
    }
    
    func createPhotoGrid(_ coordinator: GroupCoordinator) -> PhotoGridViewController {
        let viewModel = PhotoGridViewModel(coordinator: coordinator)
        let photoGridVC = PhotoGridViewController(viewModel: viewModel)
        return photoGridVC
    }
}
