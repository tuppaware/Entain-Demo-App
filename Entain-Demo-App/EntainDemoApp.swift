//
//  EntainDemoApp.swift
//  Entain-Demo-App
//
//  Created by Adam Ware on 4/11/2024.
//

import SwiftUI
import NetworkingManager

@main
struct EntainDemoApp: App {
    var body: some Scene {
        WindowGroup {
            let interactor = NextoGoInteractor(networkService: NetworkingManager())
            let viewModel = NextToGoViewModel(interactor: interactor)
            NextToGoView(viewModel: viewModel)
        }
    }
}
