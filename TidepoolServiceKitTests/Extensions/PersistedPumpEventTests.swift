//
//  PersistedPumpEventTests.swift
//  TidepoolServiceKitTests
//
//  Created by Darin Krauss on 1/12/22.
//  Copyright © 2022 LoopKit Authors. All rights reserved.
//

import XCTest
import Foundation
import LoopKit
@testable import TidepoolServiceKit

class PersistedPumpEventTests: XCTestCase {
    func testDataAlarm() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: nil,
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarm,
                                           automatic: true,
                                           alarmType: .other("Test Alarm"))
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "alarmType" : "other",
    "id" : "a07718a631a79cbe9dfafdc7aa3bc227",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/alarm",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "otherAlarmType" : "Test Alarm",
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "alarm",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataAlarmWithSuspend() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(suspendDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarm,
                                           automatic: true,
                                           alarmType: .other("Test Alarm"))
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "suspended" : "automatic"
    },
    "status" : "suspended",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "alarmType" : "other",
    "id" : "a07718a631a79cbe9dfafdc7aa3bc227",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/alarm",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "otherAlarmType" : "Test Alarm",
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "alarm",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataAlarmWithResume() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(resumeDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarm,
                                           automatic: true,
                                           alarmType: .other("Test Alarm"))
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "alarmType" : "other",
    "id" : "a07718a631a79cbe9dfafdc7aa3bc227",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/alarm",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "otherAlarmType" : "Test Alarm",
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "alarm",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "resumed" : "automatic"
    },
    "status" : "resumed",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataAlarmClear() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: nil,
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarmClear)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertTrue(data.isEmpty)
    }

    func testDataAlarmClearWithSuspend() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(suspendDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarmClear)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "suspended" : "automatic"
    },
    "status" : "suspended",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataAlarmClearWithResume() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(resumeDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .alarmClear)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "resumed" : "automatic"
    },
    "status" : "resumed",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataBasal() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(type: .basal,
                                                           startDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           endDate: Self.dateFormatter.date(from: "2020-01-02T03:25:23Z")!,
                                                           value: 0.75,
                                                           unit: .units,
                                                           doseId: nil,
                                                           deliveredUnits: nil,
                                                           description: "Test Basal Dose",
                                                           syncIdentifier: "18CF3948-0B3D-4B12-8BFE-14986B0E6784",
                                                           scheduledBasalRate: LoopQuantity(unit: .internationalUnitsPerHour, doubleValue: 2.0),
                                                           insulinType: .novolog,
                                                           automatic: true,
                                                           manuallyEntered: false),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .basal,
                                           automatic: true)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[

]
"""
        )
    }

    func testDataBolus() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(type: .bolus,
                                                           startDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           endDate: Self.dateFormatter.date(from: "2020-01-02T03:00:53Z")!,
                                                           value: 4.25,
                                                           unit: .units,
                                                           doseId: nil,
                                                           deliveredUnits: 3.5,
                                                           description: "Test Bolus Dose",
                                                           syncIdentifier: "18CF3948-0B3D-4B12-8BFE-14986B0E6784",
                                                           scheduledBasalRate: nil,
                                                           insulinType: .apidra,
                                                           automatic: false,
                                                           manuallyEntered: false),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .basal,
                                           automatic: false)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[

]
"""
        )
    }

    func testDataPrime() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: nil,
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .prime)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "00e23a994ef6b0393a8c31db6bc5b264",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/prime",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "primeTarget" : "tubing",
    "subType" : "prime",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataPrimeWithSuspend() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(suspendDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .prime)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "suspended" : "automatic"
    },
    "status" : "suspended",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "id" : "00e23a994ef6b0393a8c31db6bc5b264",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/prime",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "primeTarget" : "tubing",
    "subType" : "prime",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataPrimeWithResume() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(resumeDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .prime)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "00e23a994ef6b0393a8c31db6bc5b264",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/prime",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "primeTarget" : "tubing",
    "subType" : "prime",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "resumed" : "automatic"
    },
    "status" : "resumed",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataResume() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(resumeDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .resume)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "resumed" : "manual"
    },
    "status" : "resumed",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataRewind() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: nil,
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .rewind)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "16d248ca92e6a625d0fc0b344916bee7",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/reservoirChange",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "reservoirChange",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataRewindWithSuspend() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(suspendDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .rewind)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "suspended" : "automatic"
    },
    "status" : "suspended",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "id" : "16d248ca92e6a625d0fc0b344916bee7",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/reservoirChange",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "reservoirChange",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataRewindWithResume() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(resumeDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .rewind)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "16d248ca92e6a625d0fc0b344916bee7",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/reservoirChange",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "subType" : "reservoirChange",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  },
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "resumed" : "automatic"
    },
    "status" : "resumed",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataSuspend() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(suspendDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           automatic: true),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .suspend,
                                           automatic: true)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[
  {
    "id" : "383e8a915ae51534a2907f9d9a527e5b",
    "origin" : {
      "id" : "ab0a722d639669875017a899a5214677:deviceEvent/status",
      "name" : "Loop",
      "type" : "application",
      "version" : "1.2.3"
    },
    "payload" : {
      "syncIdentifier" : "ab0a722d639669875017a899a5214677"
    },
    "reason" : {
      "suspended" : "automatic"
    },
    "status" : "suspended",
    "subType" : "status",
    "time" : "2020-01-02T03:00:23.000Z",
    "type" : "deviceEvent"
  }
]
"""
        )
    }

    func testDataTempBasal() {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: DoseEntry(type: .tempBasal,
                                                           startDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                                           endDate: Self.dateFormatter.date(from: "2020-01-02T03:20:23Z")!,
                                                           value: 1.5,
                                                           unit: .unitsPerHour,
                                                           doseId: nil,
                                                           deliveredUnits: 0.5,
                                                           description: "Test Temp Basal Dose",
                                                           syncIdentifier: "18CF3948-0B3D-4B12-8BFE-14986B0E6784",
                                                           scheduledBasalRate: LoopQuantity(unit: .internationalUnitsPerHour, doubleValue: 2.0),
                                                           insulinType: .fiasp,
                                                           automatic: true,
                                                           manuallyEntered: false),
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: nil,
                                           type: .tempBasal,
                                           automatic: true)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        XCTAssertEqual(String(data: try! Self.encoder.encode(data), encoding: .utf8), """
[

]
"""
        )
    }

    private func replaceComponentData(_ componentType: ReplaceableComponent, replacement: ComponentReplacement? = nil) throws -> [[String: Any]] {
        let pumpEvent = PersistedPumpEvent(date: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           persistedDate: Self.dateFormatter.date(from: "2020-01-02T03:00:23Z")!,
                                           dose: nil,
                                           isUploaded: false,
                                           objectIDURL: URL(string: "x-coredata:///PumpEvent/18CF3948-0B3D-4B12-8BFE-14986B0E6784")!,
                                           raw: "18CF3948-0B3D-4B12-8BFE-14986B0E6784".data(using: .utf8),
                                           title: "Pod Change (Omnipod DASH)",
                                           type: .replaceComponent(componentType: componentType),
                                           componentReplacement: replacement)
        let data = pumpEvent.data(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011", hostIdentifier: "Loop", hostVersion: "1.2.3")
        return try XCTUnwrap(JSONSerialization.jsonObject(with: Self.encoder.encode(data)) as? [[String: Any]])
    }

    func testDataReplacePumpWithDetails() throws {
        let replacement = ComponentReplacement(previous: .init(stopDate: Self.dateFormatter.date(from: "2020-01-02T02:00:00Z")!,
                                                               remainingUnits: 23.5,
                                                               reason: .fault(code: "0x5C")),
                                               primes: [.init(target: .tubing, volume: 2.6), .init(target: .cannula, volume: 0.5)],
                                               expirationDate: Self.dateFormatter.date(from: "2020-01-05T03:00:23Z")!,
                                               componentIdentifier: "43620-560313")
        let data = try replaceComponentData(.pump, replacement: replacement)

        XCTAssertEqual(data.map { $0["subType"] as? String }, ["reservoirChange", "prime", "prime"])
        XCTAssertEqual(data[1]["primeTarget"] as? String, "tubing")
        XCTAssertEqual(data[1]["volume"] as? Double, 2.6)
        XCTAssertEqual(data[2]["primeTarget"] as? String, "cannula")
        XCTAssertEqual(data[2]["volume"] as? Double, 0.5)
        XCTAssertEqual(Set(data.compactMap { $0["id"] as? String }).count, 3)
        for datum in data {
            let payload = try XCTUnwrap(datum["payload"] as? [String: Any])
            XCTAssertEqual(payload["reason"] as? String, "fault")
            XCTAssertEqual(payload["faultCode"] as? String, "0x5C")
            XCTAssertEqual(payload["previousStopTime"] as? String, "2020-01-02T02:00:00Z")
            XCTAssertEqual(payload["previousRemainingUnits"] as? Double, 23.5)
            XCTAssertEqual(payload["expirationTime"] as? String, "2020-01-05T03:00:23Z")
            XCTAssertEqual(payload["componentId"] as? String, "43620-560313")
            XCTAssertEqual(datum["time"] as? String, "2020-01-02T03:00:23.000Z")
        }
    }

    func testDataReplacePumpWithoutDetails() throws {
        let data = try replaceComponentData(.pump)

        XCTAssertEqual(data.map { $0["subType"] as? String }, ["reservoirChange", "prime"])
        XCTAssertEqual(data[1]["primeTarget"] as? String, "cannula")
        XCTAssertNil(data[1]["volume"])
        XCTAssertEqual((data[0]["payload"] as? [String: Any])?.keys.sorted(), ["syncIdentifier"])
    }

    func testDataReplaceReservoir() throws {
        let data = try replaceComponentData(.reservoir)
        XCTAssertEqual(data.map { $0["subType"] as? String }, ["reservoirChange"])
    }

    func testDataReplaceInfusionSet() throws {
        let data = try replaceComponentData(.infusionSet)
        XCTAssertEqual(data.map { $0["subType"] as? String }, ["prime"])
        XCTAssertEqual(data[0]["primeTarget"] as? String, "cannula")
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder.tidepool
        encoder.outputFormatting.insert(.prettyPrinted)
        return encoder
    }()

    private static let dateFormatter = ISO8601DateFormatter()
}
