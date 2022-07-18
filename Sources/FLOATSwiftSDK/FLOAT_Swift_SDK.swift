//
//  FLOAT_Swift_SDK.swift
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation
import Combine
import FCL
import Flow
import BigInt
import CryptoKit
import SwiftUI

public let float = FLOAT_Swift_SDK.shared

public class FLOAT_Swift_SDK {
    public static let shared = FLOAT_Swift_SDK()
    private var cancellables = Set<AnyCancellable>()
    private var floatSetup = false
    public var groups: [FloatGroup] = []
    public var events: [FLOATEventMetadata] = []

    public init() {

    }

    public func isSetup() -> Bool {
        return self.floatSetup
    }

    public func setupFloatAccount() async {
        do {
            let txId = try await fcl.send([
                .transaction(FloatTransactions.setupAccountTx.rawValue),
                .limit(1000),
            ]).hex
            await MainActor.run {
                self.floatSetup = true

                // TODO: Transaction Monitoring
                print(txId)
            }
        } catch {
            // TODO: Error Handling
            print(error)
        }
    }

    public func floatIsSetup() async {
        if (fcl.currentUser != nil) {
            if fcl.currentUser!.loggedIn {
                do {
                    let block = try await fcl.query {
                        cadence {
                            FloatScripts.isSetup.rawValue
                        }

                        arguments {
                            [.address(fcl.currentUser!.addr)]
                        }

                        gasLimit {
                            1000
                        }
                    }.decode()
                    await MainActor.run {
                        if let setup = block {
                            self.floatSetup = setup as? Bool ?? false
                        }
                    }
                } catch {
                    // TODO: Error Handling
                    print(error)
                }
            } else {
                // TODO: Error Handling
                print("Error - Not Logged In")
            }
        } else {
            // TODO: Error Handling
            print("Error - Not Logged In")
        }
    }

    public func addSharedMinter(address: String) async {
        // TODO: Add Validator to Ensure proper address.

        do {
            let txId = try await fcl.send([
                .transaction(FloatTransactions.addSharedMinter.rawValue),
                .args([.address(Flow.Address(hex: address))]),
                .limit(1000),
            ]).hex
            await MainActor.run {
                // TODO: Setup Success Alert!
                print("Setup Shared Minter")

                // TODO: Transaction Monitoring
                print(txId)
            }
        } catch {
            // TODO: Error Handling
            print(error)
        }
    }

    public func getGroups() async {
        if fcl.currentUser != nil {
            if fcl.currentUser!.loggedIn {
                self.groups = []
                do {
                    let block = try await fcl.query {
                        cadence {
                            FloatScripts.getGroups.rawValue
                        }

                        arguments {
                            [.address(fcl.currentUser!.addr)]
                        }

                        gasLimit {
                            1000
                        }
                    }.decode()
                    await MainActor.run {
                        // TODO: Figure out why decode not working properly for this
                        // TODO: Figure out why group events are not returning
                        if let floatGroups = block as? [String: Any] {
                            floatGroups.forEach { (_: String, value: Any) in
                               if let group = value as? [String: Any] {
                                   self.groups.append(FloatGroup(id: group["id"] as? UInt64 ?? 0, uuid: group["uuid"] as? UInt64 ?? 0, name: group["name"] as? String ?? "", image: group["image"] as? String ?? "", description: group["description"] as? String ?? "", events: group["events"] as? [String] ?? []))
                                }
                            }
                        }
                    }
                } catch {
                    // TODO: Error Handling
                    print(error)
                }
            }
        }
    }
    
    public func getEvents() async {
        if (fcl.currentUser != nil) {
            if fcl.currentUser!.loggedIn {
                do {
                    let block = try await fcl.query {
                        cadence {
                            FloatScripts.getEvents.rawValue
                        }

                        arguments {
                            [.address(fcl.currentUser!.addr)]
                        }

                        gasLimit {
                            1000
                        }
                    }.decode()
                    await MainActor.run {
                        if let eventsDict = block as? [String: Any] {
                            print(eventsDict)
                        }
                    }
                } catch {
                    // TODO: Error Handling
                    print(error)
                }
            } else {
                // TODO: Error Handling
                print("Error - Not Logged In")
            }
        } else {
            // TODO: Error Handling
            print("Error - Not Logged In")
        }
    }
}
