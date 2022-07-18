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
    public let events: [String]
}

public struct FLOATEventMetadata: Decodable, Hashable, Identifiable {
    public let claimable: Bool
    public let dateCreated: String
    public let description: String
    public let eventId: String
    public let host: String
    public let image: String
    public let name: String
    public let totalSupply: String
    public let transferrable: Bool
    public let url: String
    public let id: String
}
