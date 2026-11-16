//
//  StoredWorkoutTests.swift
//  TidepoolServiceKitTests
//
//  Copyright © 2026 LoopKit Authors. All rights reserved.
//

import XCTest
import HealthKit
import TidepoolKit
import LoopKit
@testable import TidepoolServiceKit

class StoredWorkoutDatumTests: XCTestCase {
    func testRunningWorkout() {
        let start = ISO8601DateFormatter().date(from: "2026-10-31T14:00:00Z")!
        let workout = StoredWorkout(
            uuid: UUID(uuidString: "2A67A303-1234-4CB8-8263-79498265368E")!,
            startDate: start,
            endDate: start.addingTimeInterval(.minutes(45)),
            duration: .minutes(42),
            activityType: .running,
            totalEnergyBurned: 410.5,
            totalDistance: 7200,
            averageHeartRate: 151,
            minimumHeartRate: 92,
            maximumHeartRate: 178,
            source: StoredWorkout.Source(bundleIdentifier: "com.apple.health.81A1B2C3", name: "Apple Watch", version: "11.1", productType: "Watch7,1", operatingSystemVersion: "11.1.0"),
            device: StoredWorkout.Device(name: "Apple Watch", model: "Watch", manufacturer: "Apple Inc."),
            events: [StoredWorkout.Event(type: .pause, startDate: start.addingTimeInterval(.minutes(20)), duration: 0)],
            metadata: [
                HKMetadataKeyTimeZone: .string("America/Chicago"),
                HKMetadataKeyIndoorWorkout: .bool(false),
                HKMetadataKeyAverageMETs: .string("9.8 kcal/hr·kg"),
            ]
        )
        let datum = workout.datum(for: "2B03D96C-6F5D-4140-99CD-80C3E64D6011")
        XCTAssertEqual(String(data: try! Self.encoder.encode(datum), encoding: .utf8), """
{
  "activityType" : "running",
  "distance" : {
    "units" : "meters",
    "value" : 7200
  },
  "duration" : {
    "units" : "seconds",
    "value" : 2520
  },
  "energy" : {
    "units" : "kilocalories",
    "value" : 410.5
  },
  "id" : "332e6adc6287f638138b8d186dd5bd41",
  "name" : "Running",
  "origin" : {
    "id" : "2A67A303-1234-4CB8-8263-79498265368E",
    "name" : "com.apple.HealthKit",
    "payload" : {
      "device" : {
        "manufacturer" : "Apple Inc.",
        "model" : "Watch",
        "name" : "Apple Watch"
      },
      "sourceRevision" : {
        "operatingSystemVersion" : "11.1.0",
        "productType" : "Watch7,1",
        "source" : {
          "bundleIdentifier" : "com.apple.health.81A1B2C3",
          "name" : "Apple Watch"
        },
        "version" : "11.1"
      }
    },
    "type" : "service"
  },
  "payload" : {
    "HKAverageMETs" : "9.8 kcal/hr·kg",
    "HKIndoorWorkout" : false,
    "HKTimeZone" : "America/Chicago",
    "HKWorkoutActivityType" : 37,
    "heartRate" : {
      "average" : 151,
      "maximum" : 178,
      "minimum" : 92,
      "units" : "bpm"
    },
    "workoutEvents" : [
      {
        "duration" : 0,
        "time" : "2026-10-31T14:20:00.000Z",
        "type" : 1
      }
    ]
  },
  "time" : "2026-10-31T14:00:00.000Z",
  "timezone" : "America/Chicago",
  "timezoneOffset" : -300,
  "type" : "physicalActivity"
}
"""
        )
    }

    func testUnmappedActivityTypeIsOther() {
        let start = Date()
        let workout = StoredWorkout(uuid: UUID(), startDate: start, endDate: start, duration: 0, activityType: .pickleball, source: StoredWorkout.Source(bundleIdentifier: "b", name: "n", operatingSystemVersion: "1.0.0"))
        let datum = workout.datum(for: "user")
        XCTAssertEqual(datum.activityType, .other)
        XCTAssertEqual(datum.activityTypeOther, "HKWorkoutActivityType \(HKWorkoutActivityType.pickleball.rawValue)")
        XCTAssertEqual(datum.name, "Other")
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder.tidepool
        encoder.outputFormatting.insert(.prettyPrinted)
        return encoder
    }()
}
