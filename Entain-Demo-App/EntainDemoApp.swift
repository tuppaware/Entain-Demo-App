//
//  EntainDemoApp.swift
//  Entain-Demo-App
//
//  Created by Adam Ware on 4/11/2024.
//

import SwiftUI

@main
struct EntainDemoApp: App {
    var body: some Scene {
        WindowGroup {
            let interactor = NextoGoInteractor(networkService: NetworkManager())
            let viewModel = NextToGoViewModel(interactor: interactor)
            NextToGoView(viewModel: viewModel)
        }
    }
}
