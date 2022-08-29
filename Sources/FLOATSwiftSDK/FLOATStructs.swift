//
//  FLOATStructs.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/14/22.
//

import Foundation

public struct FloatGroup: Decodable, Hashable, Identifiable {
    public let id: UInt64
    public let uuid: UInt64
    public let name: String
    public let image: String
    public let description: String
    public let events: [String: Bool]
}

public struct FLOATEventMetadata: Decodable, Hashable {
    public let claimable: Bool
    public let dateCreated: Double
    public let description: String
    public let eventId: UInt64
    public let groups: [String]
    public let host: String
    public let image: String
    public let name: String
    public let totalSupply: UInt64
    public let transferrable: Bool
    public let url: String
}

extension FLOATEventMetadata: Identifiable {
    public var id: UInt64 { eventId }
}

public struct CombinedFloatMetadata: Decodable, Hashable {
    public let float: FLOAT
    public let totalSupply: UInt64
    public let transferrable: Bool
}

extension CombinedFloatMetadata: Identifiable {
    public var id: UInt64 { float.id }
}

public struct FLOAT: Decodable, Hashable, Identifiable {
    public let uuid: UInt64
    public let id: UInt64
    public let dateReceived: Double
    public let eventDescription: String
    public let eventHost: String
    public let eventId: UInt64
    public let eventImage: String
    public let eventName: String
    public let originalRecipient: String
    public let serial: UInt64
}
