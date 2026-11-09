//
//  StoredWorkout.swift
//  TidepoolServiceKit
//
//  Copyright © 2026 LoopKit Authors. All rights reserved.
//

import HealthKit
import LoopKit
import TidepoolKit

// Matches the physicalActivity records written by tidepool-org/healthkit-uploader (origin, payload),
// adding activityType and heart rate so donated data has one shape.
extension StoredWorkout {
    func datum(for userId: String) -> TPhysicalActivityDatum {
        let activityType = tidepoolActivityType
        let datum = TPhysicalActivityDatum(
            time: startDate,
            name: activityType.map(\.displayName) ?? "Other",
            activityType: activityType ?? .other,
            activityTypeOther: activityType == nil ? "HKWorkoutActivityType \(self.activityType.rawValue)" : nil,
            duration: TPhysicalActivityDatum.Duration(duration, .seconds),
            distance: totalDistance.map { TPhysicalActivityDatum.Distance($0, .meters) },
            energy: totalEnergyBurned.map { TPhysicalActivityDatum.Energy($0, .kilocalories) }
        )
        return datum.adornWith(
            id: "\(userId):\(uuid.uuidString)".md5hash,
            timeZone: timeZone,
            timeZoneOffset: timeZone.map { TimeInterval($0.secondsFromGMT(for: startDate)) },
            payload: datumPayload,
            origin: datumOrigin
        )
    }

    static func selector(for uuid: UUID) -> TDatum.Selector {
        TDatum.Selector(origin: TDatum.Selector.Origin(id: uuid.uuidString))
    }

    private var datumOrigin: TOrigin {
        var sourceRevision: [String: Any] = [
            "source": ["bundleIdentifier": source.bundleIdentifier, "name": source.name],
            "operatingSystemVersion": source.operatingSystemVersion,
        ]
        sourceRevision["version"] = source.version
        sourceRevision["productType"] = source.productType

        var payload: [String: Any] = ["sourceRevision": sourceRevision]
        if let device {
            let fields: [String: String?] = [
                "name": device.name,
                "model": device.model,
                "manufacturer": device.manufacturer,
                "udiDeviceIdentifier": device.udiDeviceIdentifier,
                "localIdentifier": device.localIdentifier,
                "firmwareVersion": device.firmwareVersion,
                "hardwareVersion": device.hardwareVersion,
                "softwareVersion": device.softwareVersion,
            ]
            let deviceDictionary = fields.compactMapValues { $0 }
            if !deviceDictionary.isEmpty {
                payload["device"] = deviceDictionary
            }
        }
        return TOrigin(id: uuid.uuidString, name: "com.apple.HealthKit", type: .service, payload: TDictionary(payload))
    }

    private var datumPayload: TDictionary {
        var payload: [String: Any] = metadata.mapValues { value -> Any in
            switch value {
            case .string(let string): return string
            case .number(let number): return number
            case .bool(let bool): return bool
            }
        }
        payload["HKWorkoutActivityType"] = Int(activityType.rawValue)
        if let averageHeartRate {
            var heartRate: [String: Any] = ["units": "bpm", "average": averageHeartRate]
            heartRate["minimum"] = minimumHeartRate
            heartRate["maximum"] = maximumHeartRate
            payload["heartRate"] = heartRate
        }
        if !events.isEmpty {
            payload["workoutEvents"] = events.map {
                ["type": $0.type.rawValue, "time": $0.startDate.timeString, "duration": $0.duration] as [String: Any]
            }
        }
        if activities.count > 1 {
            payload["workoutActivities"] = activities.map {
                var activity: [String: Any] = ["HKWorkoutActivityType": Int($0.activityType.rawValue), "time": $0.startDate.timeString]
                activity["endTime"] = $0.endDate?.timeString
                return activity
            }
        }
        return TDictionary(payload)
    }

    private var tidepoolActivityType: TPhysicalActivityDatum.ActivityType? {
        switch activityType {
        case .americanFootball: .americanFootball
        case .archery: .archery
        case .australianFootball: .australianFootball
        case .badminton: .badminton
        case .barre: .barre
        case .baseball: .baseball
        case .basketball: .basketball
        case .bowling: .bowling
        case .boxing: .boxing
        case .climbing: .climbing
        case .coreTraining: .coreTraining
        case .cricket: .cricket
        case .crossCountrySkiing: .crossCountrySkiing
        case .crossTraining: .crossTraining
        case .curling: .curling
        case .cycling: .cycling
        case .downhillSkiing: .downhillSkiing
        case .elliptical: .elliptical
        case .equestrianSports: .equestrianSports
        case .fencing: .fencing
        case .fishing: .fishing
        case .flexibility: .flexibility
        case .functionalStrengthTraining: .functionalStrengthTraining
        case .golf: .golf
        case .gymnastics: .gymnastics
        case .handball: .handball
        case .handCycling: .handCycling
        case .highIntensityIntervalTraining: .highIntensityIntervalTraining
        case .hiking: .hiking
        case .hockey: .hockey
        case .hunting: .hunting
        case .jumpRope: .jumpRope
        case .kickboxing: .kickboxing
        case .lacrosse: .lacrosse
        case .martialArts: .martialArts
        case .mindAndBody: .mindAndBody
        case .mixedCardio: .mixedCardio
        case .paddleSports: .paddleSports
        case .pilates: .pilates
        case .play: .play
        case .preparationAndRecovery: .preparationAndRecovery
        case .racquetball: .racquetball
        case .rowing: .rowing
        case .rugby: .rugby
        case .running: .running
        case .sailing: .sailing
        case .skatingSports: .skatingSports
        case .snowboarding: .snowboarding
        case .snowSports: .snowSports
        case .soccer: .soccer
        case .softball: .softball
        case .squash: .squash
        case .stairClimbing: .stairClimbing
        case .stairs: .stairs
        case .stepTraining: .stepTraining
        case .surfingSports: .surfingSports
        case .swimming: .swimming
        case .tableTennis: .tableTennis
        case .taiChi: .taiChi
        case .tennis: .tennis
        case .trackAndField: .trackAndField
        case .traditionalStrengthTraining: .traditionalStrengthTraining
        case .volleyball: .volleyball
        case .walking: .walking
        case .waterFitness: .waterFitness
        case .waterPolo: .waterPolo
        case .waterSports: .waterSports
        case .wheelchairRunPace: .wheelchairRunPace
        case .wheelchairWalkPace: .wheelchairWalkPace
        case .wrestling: .wrestling
        case .yoga: .yoga
        default: nil
        }
    }
}

private extension TPhysicalActivityDatum.ActivityType {
    var displayName: String {
        rawValue.reduce(into: "") { name, character in
            if character.isUppercase, !name.isEmpty {
                name.append(" ")
            }
            name.append(name.isEmpty ? Character(character.uppercased()) : character)
        }
    }
}
