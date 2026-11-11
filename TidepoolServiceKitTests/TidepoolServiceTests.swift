//
//  TidepoolServiceTests.swift
//  TidepoolServiceKitTests
//
//  Created by Darin Krauss on 11/15/21.
//  Copyright © 2021 LoopKit Authors. All rights reserved.
//

import XCTest
import HealthKit
import LoopKit
import TidepoolKit
@testable import TidepoolServiceKit

class TidepoolServiceTests: XCTestCase {
    var tidepoolService: TidepoolService!
    var userID: String!
    
    override func setUp() {
        super.setUp()
        
        tidepoolService = TidepoolService(hostIdentifier: "Loop", hostVersion: "1.2.3")
        userID = "1234567890"
    }

    func testCalculateDosingDecisionData() {
        let dosingDecisions = [StoredDosingDecision(reason: "Test",
                                                    controllerStatus: StoredDosingDecision.ControllerStatus(batteryLevel: 0.5),
                                                    pumpManagerStatus: PumpManagerStatus(timeZone: TimeZone(secondsFromGMT: TimeZone(identifier: "America/Phoenix")!.secondsFromGMT())!,
                                                                                         device: HKDevice(name: "Pump #1"),
                                                                                         pumpBatteryChargeRemaining: 0.75,
                                                                                         basalDeliveryState: nil,
                                                                                         bolusState: .noBolus,
                                                                                         insulinType: nil))]
        let created = tidepoolService.calculateDosingDecisionData(dosingDecisions, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 3)
        XCTAssertEqual((created[0] as! TDosingDecisionDatum).reason, "Test")
        XCTAssertEqual((created[0] as! TDosingDecisionDatum).associations!.count, 2)
        XCTAssertEqual((created[0] as! TDosingDecisionDatum).associations![0].id, created[1].id)
        XCTAssertEqual((created[0] as! TDosingDecisionDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[1] as! TControllerStatusDatum).battery!.remaining, 0.5)
        XCTAssertEqual((created[1] as! TControllerStatusDatum).associations!.count, 2)
        XCTAssertEqual((created[1] as! TControllerStatusDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[1] as! TControllerStatusDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[2] as! TPumpStatusDatum).battery!.remaining, 0.75)
        XCTAssertEqual((created[2] as! TPumpStatusDatum).associations!.count, 2)
        XCTAssertEqual((created[2] as! TPumpStatusDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[2] as! TPumpStatusDatum).associations![1].id, created[1].id)
    }
    
    func testCalculateSettingsDataIndividual() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 3)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).associations![0].id, created[1].id)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).associations![1].id, created[1].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[0].id)
        XCTAssertEqual(lastCGMSettings!.id, created[1].id)
        XCTAssertEqual(lastPumpSettings!.id, created[2].id)
    }
    
    func testCalculateSettingsDataUpdateControllerSettings() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #2"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 4)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).device!.name, "Controller #2")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![0].id, created[1].id)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![1].id, created[2].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[3].id)
        XCTAssertEqual(lastCGMSettings!.id, created[1].id)
        XCTAssertEqual(lastPumpSettings!.id, created[2].id)
    }
    
    func testCalculateSettingsDataUpdateCGMSettings() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #2"),
                                       pumpDevice: HKDevice(name: "Pump #1"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 4)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[3] as! TCGMSettingsDatum).name, "CGM #2")
        XCTAssertEqual((created[3] as! TCGMSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[3] as! TCGMSettingsDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[3] as! TCGMSettingsDatum).associations![1].id, created[2].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[0].id)
        XCTAssertEqual(lastCGMSettings!.id, created[3].id)
        XCTAssertEqual(lastPumpSettings!.id, created[2].id)
    }
    
    func testCalculateSettingsDataUpdatePumpSettings() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #2"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 4)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[3] as! TPumpSettingsDatum).name, "Pump #2")
        XCTAssertEqual((created[3] as! TPumpSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[3] as! TPumpSettingsDatum).associations![0].id, created[0].id)
        XCTAssertEqual((created[3] as! TPumpSettingsDatum).associations![1].id, created[1].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[0].id)
        XCTAssertEqual(lastCGMSettings!.id, created[1].id)
        XCTAssertEqual(lastPumpSettings!.id, created[3].id)
    }
    
    func testCalculateSettingsDataUpdateMultipleOne() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #2"),
                                       cgmDevice: HKDevice(name: "CGM #2"),
                                       pumpDevice: HKDevice(name: "Pump #2"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 6)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).device!.name, "Controller #2")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![0].id, created[4].id)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![1].id, created[5].id)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).name, "CGM #2")
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations![0].id, created[3].id)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations![1].id, created[5].id)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).name, "Pump #2")
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations![0].id, created[3].id)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations![1].id, created[4].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[3].id)
        XCTAssertEqual(lastCGMSettings!.id, created[4].id)
        XCTAssertEqual(lastPumpSettings!.id, created[5].id)
    }
    
    func testCalculateSettingsDataUpdateMultipleMultiple() {
        let settings = [StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #1"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #2"),
                                       cgmDevice: HKDevice(name: "CGM #1"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #2"),
                                       cgmDevice: HKDevice(name: "CGM #2"),
                                       pumpDevice: HKDevice(name: "Pump #1")),
                        StoredSettings(controllerDevice: StoredSettings.ControllerDevice(name: "Controller #2"),
                                       cgmDevice: HKDevice(name: "CGM #2"),
                                       pumpDevice: HKDevice(name: "Pump #2"))]
        let (created, updated, lastControllerSettings, lastCGMSettings, lastPumpSettings) = tidepoolService.calculateSettingsData(settings, for: userID, hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(created.count, 6)
        XCTAssertEqual((created[0] as! TControllerSettingsDatum).device!.name, "Controller #1")
        XCTAssertEqual((created[1] as! TCGMSettingsDatum).name, "CGM #1")
        XCTAssertEqual((created[2] as! TPumpSettingsDatum).name, "Pump #1")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).device!.name, "Controller #2")
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![0].id, created[1].id)
        XCTAssertEqual((created[3] as! TControllerSettingsDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).name, "CGM #2")
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations![0].id, created[3].id)
        XCTAssertEqual((created[4] as! TCGMSettingsDatum).associations![1].id, created[2].id)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).name, "Pump #2")
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations!.count, 2)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations![0].id, created[3].id)
        XCTAssertEqual((created[5] as! TPumpSettingsDatum).associations![1].id, created[4].id)
        XCTAssertTrue(updated.isEmpty)
        XCTAssertEqual(lastControllerSettings!.id, created[3].id)
        XCTAssertEqual(lastCGMSettings!.id, created[4].id)
        XCTAssertEqual(lastPumpSettings!.id, created[5].id)
    }

}

@MainActor
class TidepoolServiceSessionTests: XCTestCase {
    private var tidepoolService: TidepoolService!
    private var serviceDelegate: MockServiceDelegate!
    private let session = TSession(environment: TEnvironment(host: "test.tidepool.org", port: 443), accessToken: "access", accessTokenExpiration: nil, refreshToken: "refresh", userId: "1234567890", username: "test@test.com", userRoles: [])

    override func setUp() {
        super.setUp()
        serviceDelegate = MockServiceDelegate()
        tidepoolService = TidepoolService(hostIdentifier: "Loop", hostVersion: "1.2.3")
        tidepoolService.sessionStorage = MockSessionStorage()
        tidepoolService.serviceDelegate = serviceDelegate
    }

    func testLoggingOutIssuesAuthenticationAlert() async {
        tidepoolService.apiDidUpdateSession(session)
        await serviceDelegate.waitForRetracted(count: 1)

        tidepoolService.apiDidUpdateSession(nil)
        await serviceDelegate.waitForIssued(count: 1)

        XCTAssertEqual(serviceDelegate.issued.first?.alertIdentifier, "authentication-needed")
    }

    func testLoggingBackInRetractsAuthenticationAlert() async {
        tidepoolService.apiDidUpdateSession(session)
        tidepoolService.apiDidUpdateSession(nil)
        await serviceDelegate.waitForIssued(count: 1)

        tidepoolService.apiDidUpdateSession(session)
        await serviceDelegate.waitForRetracted(count: 2)

        XCTAssertEqual(serviceDelegate.retracted.last?.alertIdentifier, "authentication-needed")
    }

    func testRefreshingSessionDoesNotRetract() async {
        tidepoolService.apiDidUpdateSession(session)
        await serviceDelegate.waitForRetracted(count: 1)

        let refreshed = TSession(environment: session.environment, accessToken: "access2", accessTokenExpiration: nil, refreshToken: "refresh2", userId: session.userId, username: session.username, userRoles: [])
        tidepoolService.apiDidUpdateSession(refreshed)
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(serviceDelegate.retracted.count, 1)
    }
}

private class MockSessionStorage: SessionStorage {
    var sessions: [String: TSession] = [:]

    func setSession(_ session: TSession?, for service: String) throws {
        sessions[service] = session
    }

    func getSession(for service: String) throws -> TSession? {
        sessions[service]
    }
}

private class MockServiceDelegate: ServiceDelegate {
    let hostIdentifier = "Loop"
    let hostVersion = "1.2.3"

    @MainActor var issued: [Alert.Identifier] = []
    @MainActor var retracted: [Alert.Identifier] = []

    @MainActor func issueAlert(_ alert: Alert) async {
        issued.append(alert.identifier)
    }

    @MainActor func retractAlert(identifier: Alert.Identifier) async {
        retracted.append(identifier)
    }

    @MainActor func waitForIssued(count: Int) async {
        for _ in 0..<100 where issued.count < count {
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }

    @MainActor func waitForRetracted(count: Int) async {
        for _ in 0..<100 where retracted.count < count {
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }

    func enactRemoteOverride(name: String, durationTime: TimeInterval?, remoteAddress: String) async throws {}
    func cancelRemoteOverride() async throws {}
    func deliverRemoteCarbs(amountInGrams: Double, absorptionTime: TimeInterval?, foodType: String?, startDate: Date?) async throws {}
    func deliverRemoteBolus(amountInUnits: Double, decisionId: UUID?) async throws {}
    func switchRemoteTherapyProfile(name: String, expectedFingerprint: String) async throws {}
    func saveRemoteTherapyProfile(_ profile: TherapyProfile, originalName: String?, expectedFingerprint: String?) async throws {}
    func deleteRemoteTherapyProfile(name: String, expectedFingerprint: String) async throws {}
    func saveRemoteScheduledProfileSwitches(_ entries: [ScheduledProfileSwitch], expectedFingerprint: String) async throws {}
}

fileprivate extension StoredSettings.ControllerDevice {
    init(name: String) {
        self.init(name: name, systemName: "", systemVersion: "", model: "", modelIdentifier: "")
    }
}

fileprivate extension HKDevice {
    convenience init(name: String) {
        self.init(name: name, manufacturer: nil, model: nil, hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
    }
}

