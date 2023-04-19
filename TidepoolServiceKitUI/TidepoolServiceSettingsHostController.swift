//
//  TidepoolServiceSetupViewController.swift
//  TidepoolServiceKitUI
//
//  Created by Darin Krauss on 7/24/19.
//  Copyright © 2019 Tidepool Project. All rights reserved.
//

import LoopKitUI
import TidepoolKit
import TidepoolServiceKit
import SwiftUI


final class TidepoolServiceSettingsHostController: UIHostingController<SettingsView>, CompletionNotifying {

    var serviceOnboardingDelegate: ServiceOnboardingDelegate?
    var completionDelegate: CompletionDelegate?

    private let service: TidepoolService

    init(rootView: SettingsView, service: TidepoolService) {
        self.service = service

        super.init(rootView: rootView)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("Here")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TidepoolServiceSettingsHostController {
    func loginSignupDidComplete(completion: @escaping (Error?) -> Void) {
        service.completeCreate { error in
            guard error == nil else {
                completion(error)
                return
            }
            DispatchQueue.main.async {
                if let serviceNavigationController = self.navigationController as? ServiceNavigationController {
                    serviceNavigationController.notifyServiceCreatedAndOnboarded(self.service)
                    serviceNavigationController.notifyComplete()
                }
                completion(nil)
            }
        }
    }

    func loginSignupCancelled() {
        DispatchQueue.main.async {
            if let serviceNavigationController = self.navigationController as? ServiceNavigationController {
                serviceNavigationController.notifyComplete()
            }
        }
    }
}
