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

public let sharedFloat = FLOAT_Swift_SDK.shared

public class FLOAT_Swift_SDK: ObservableObject {
    public static let shared = FLOAT_Swift_SDK()
    private var cancellables = Set<AnyCancellable>()
    private var floatSetup = false
    
    @Published public var groups: [FloatGroup] = []
    @Published public var events: [FLOATEventMetadata] = []
    @Published public var floats: [CombinedFloatMetadata] = []

    public init() {
        fcl.$currentUser.sink { user in
            if user != nil {
                self.loginInit()
            }
        }.store(in: &cancellables)
    }
    
    public func loginInit() {
        Task.detached {
            await self.floatIsSetup()
            await self.getGroups()
            await self.getEvents()
            await self.getFloats()
        }
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
                    }.decode([FloatGroup].self)
                    
                    await MainActor.run {
                        let unsortedArray = block ?? []
                        
                        self.groups = unsortedArray.sorted(by: { $0.id > $1.id })
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
                    }.decode([FLOATEventMetadata].self)
                    await MainActor.run {
                        let unsortedArray = block ?? []
                        
                        self.events = unsortedArray.sorted(by: { $0.dateCreated > $1.dateCreated })
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
    
    public func getFloats() async {
        if (fcl.currentUser != nil) {
            if fcl.currentUser!.loggedIn {
                do {
                    let block = try await fcl.query {
                        cadence {
                            FloatScripts.getFloats.rawValue
                        }

                        arguments {
                            [.address(fcl.currentUser!.addr)]
                        }

                        gasLimit {
                            1000
                        }
                    }.decode([CombinedFloatMetadata].self)
                    await MainActor.run {
                        let unsortedArray = block ?? []
                        
                        self.floats = unsortedArray.sorted(by: { $0.float.dateReceived > $1.float.dateReceived })
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
