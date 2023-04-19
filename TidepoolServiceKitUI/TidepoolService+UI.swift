//
//  TidepoolService+UI.swift
//  TidepoolServiceKitUI
//
//  Created by Darin Krauss on 7/23/19.
//  Copyright © 2019 Tidepool Project. All rights reserved.
//

import SwiftUI
import LoopKit
import LoopKitUI
import TidepoolServiceKit

extension TidepoolService: ServiceUI {
    public static var image: UIImage? {
        UIImage(named: "Tidepool Logo", in: Bundle(for: TidepoolServiceSettingsHostController.self), compatibleWith: nil)!
    }

    public static func setupViewController(colorPalette: LoopUIColorPalette, pluginHost: PluginHost) -> SetupUIResult<ServiceViewController, ServiceUI> {


        let navController = ServiceNavigationController()
        navController.isNavigationBarHidden = true

        Task {
            let service = TidepoolService(hostIdentifier: pluginHost.hostIdentifier, hostVersion: pluginHost.hostVersion)

            let tapi = service.tapi
            let session = await tapi.session
            let environments = await tapi.environments

            var presentingViewController: UIViewController!

            let settingsView = await SettingsView(session: session, defaultEnvironment: tapi.defaultEnvironment, environments: environments, login: { env throws in
                try await tapi.login(environment: env, presenting: presentingViewController)
                await navController.notifyServiceCreatedAndOnboarded(service)
            }, dismiss: {
                Task {
                    await navController.notifyComplete()
                }
            }, deleteService: {
                service.serviceDelegate?.serviceWantsDeletion(service)
            })

            let hostingController = await TidepoolServiceSettingsHostController(rootView: settingsView, service: service)
            presentingViewController = hostingController
            await navController.pushViewController(hostingController, animated: false)
        }
        
        return .userInteractionRequired(navController)
    }

    public func settingsViewController(colorPalette: LoopUIColorPalette) -> ServiceViewController {

        let navController = ServiceNavigationController()
        navController.isNavigationBarHidden = true

        Task {
            let session = await tapi.session
            let environments = await tapi.environments

            var presentingViewController: UIViewController!
            let view = await SettingsView(session: session, defaultEnvironment: tapi.defaultEnvironment, environments: environments, login: { env throws in
                try await self.tapi.login(environment: env, presenting: presentingViewController)
            }, dismiss: {
                Task {
                    await navController.notifyComplete()
                }
            }, deleteService: {
                self.serviceDelegate?.serviceWantsDeletion(self)
            })

            let hostingController = await TidepoolServiceSettingsHostController(rootView: view, service: self)
            presentingViewController = hostingController

            await navController.pushViewController(hostingController, animated: false)
        }

        return navController
    }
}
