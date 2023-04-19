//
//  SettingsView.swift
//  TidepoolServiceKitUI
//
//  Created by Pete Schwamb on 1/27/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import SwiftUI
import TidepoolKit

@MainActor
public struct SettingsView: View {

    @State private var isEnvironmentActionSheetPresented = false
    @State private var showingDeletionConfirmation = false

    @State private var message = ""
    @State private var isLoggingIn = false
    @State private var selectedEnvironment: TEnvironment

    var session: TSession?
    let environments: [TEnvironment]
    let login: ((TEnvironment) async throws -> Void)?
    let dismiss: (() -> Void)?
    let deleteService: (() -> Void)?

    var isLoggedIn: Bool {
        return session != nil
    }

    public init(
        session: TSession?,
        defaultEnvironment: TEnvironment?,
        environments: [TEnvironment],
        login: ((TEnvironment) async throws -> Void)?,
        dismiss: (() -> Void)?,
        deleteService: (() -> Void)?)
    {
        self._selectedEnvironment = State(initialValue: session?.environment ?? defaultEnvironment ?? environments.first!)
        self.environments = environments
        self.login = login
        self.dismiss = dismiss
        self.deleteService = deleteService
    }

    public var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        HStack() {
                            Spacer()
                            closeButton
                                .padding()
                        }
                        Spacer()
                        logo
                            .padding(.horizontal, 30)
                            .padding(.bottom)
                        Text(NSLocalizedString("Environment", comment: "Label title for displaying selected Tidepool server environment."))
                            .bold()
                        Text(selectedEnvironment.description)
                        if isLoggedIn {
                            Text(NSLocalizedString("You are logged in.", comment: "LoginViewModel description text when logged in"))
                                .padding()
                        } else {
                            Text(NSLocalizedString("You are not logged in.", comment: "LoginViewModel description text when not logged in"))
                                .padding()
                        }

                        VStack(alignment: .leading) {
                            messageView
                        }
                        .padding()
                        Spacer()
                        if isLoggedIn {
                            deleteServiceButton
                        } else {
                            loginButton
                        }
                    }
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(LocalizedString("Are you sure you want to delete this service?", comment: "Confirmation message for deleting a service"), isPresented: $showingDeletionConfirmation)
        {
            Button(LocalizedString("Delete Service", comment: "Button title to delete a service"), role: .destructive) {
                deleteService?()
                dismiss?()
            }
        }

    }

    private var logo: some View {
        Image(frameworkImage: "Tidepool Logo", decorative: true)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onLongPressGesture(minimumDuration: 2) {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                isEnvironmentActionSheetPresented = true
            }
            .actionSheet(isPresented: $isEnvironmentActionSheetPresented) { environmentActionSheet }
    }

    private var environmentActionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = environments.map { environment in
            .default(Text(environment.description)) {
                selectedEnvironment = environment
            }
        }
        buttons.append(.cancel())


        return ActionSheet(title: Text(NSLocalizedString("Environment", comment: "Tidepool login environment action sheet title")),
                           message: Text(selectedEnvironment.description), buttons: buttons)
    }

    private var messageView: some View {
        Text(message)
            .font(.callout)
            .foregroundColor(.red)
    }

    private var loginButton: some View {
        Button(action: {
            loginButtonTapped()
        }) {
            if isLoggingIn {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text(NSLocalizedString("Login", comment: "Tidepool login button title"))
            }
        }
        .buttonStyle(ActionButtonStyle())
        .disabled(isLoggingIn)
    }


    private var deleteServiceButton: some View {
        Button(action: {
            showingDeletionConfirmation = true
        }) {
            Text(NSLocalizedString("Logout", comment: "Tidepool logout button title"))
        }
        .buttonStyle(ActionButtonStyle(.secondary))
        .disabled(isLoggingIn)
    }

    private func loginButtonTapped() {
        guard !isLoggingIn else {
            return
        }

        isLoggingIn = true

        Task {
            do {
                try await login?(selectedEnvironment)
                dismiss?()
            } catch {
                setError(error)
                isLoggingIn = false
            }
        }
    }

    private func setError(_ error: Error?) {
        if case .requestNotAuthenticated = error as? TError {
            self.message = NSLocalizedString("Wrong username or password.", comment: "The message for the request not authenticated error")
        } else {
            self.message = error?.localizedDescription ?? ""
        }
    }

    private var closeButton: some View {
        Button(action: {
            dismiss?()
        }) {
            Text(closeButtonTitle)
                .fontWeight(.regular)
        }
    }

    private var closeButtonTitle: String { NSLocalizedString("Close", comment: "Close navigation button title of an onboarding section page view") }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            session: nil,
            defaultEnvironment: nil,
            environments: [],
            login: nil,
            dismiss: nil,
            deleteService: nil
        )
    }
}
