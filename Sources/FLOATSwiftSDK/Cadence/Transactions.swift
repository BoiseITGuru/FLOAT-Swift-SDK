//
//  Transactions.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation

enum FloatTransactions: String {
    case setupAccountTx =
        """
             import FLOAT from 0xFLOAT
             import NonFungibleToken from 0xCORE
             import MetadataViews from 0xCORE
             import GrantedAccountAccess from 0xFLOAT
             transaction {
               prepare(acct: AuthAccount) {
                 // SETUP COLLECTION
                 if acct.borrow<&FLOAT.Collection>(from: FLOAT.FLOATCollectionStoragePath) == nil {
                     acct.save(<- FLOAT.createEmptyCollection(), to: FLOAT.FLOATCollectionStoragePath)
                     acct.link<&FLOAT.Collection{NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection, FLOAT.CollectionPublic}>
                             (FLOAT.FLOATCollectionPublicPath, target: FLOAT.FLOATCollectionStoragePath)
                 }
                 // SETUP FLOATEVENTS
                 if acct.borrow<&FLOAT.FLOATEvents>(from: FLOAT.FLOATEventsStoragePath) == nil {
                   acct.save(<- FLOAT.createEmptyFLOATEventCollection(), to: FLOAT.FLOATEventsStoragePath)
                   acct.link<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic, MetadataViews.ResolverCollection}>
                             (FLOAT.FLOATEventsPublicPath, target: FLOAT.FLOATEventsStoragePath)
                 }
                 // SETUP SHARED MINTING
                 if acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath) == nil {
                     acct.save(<- GrantedAccountAccess.createInfo(), to: GrantedAccountAccess.InfoStoragePath)
                     acct.link<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>
                             (GrantedAccountAccess.InfoPublicPath, target: GrantedAccountAccess.InfoStoragePath)
                 }
               }
               execute {
                 log("Finished setting up the account for FLOATs.")
               }
             }
        """
    case addSharedMinter =
        """
            import GrantedAccountAccess from 0xFLOAT
            transaction (receiver: Address) {
                let Info: &GrantedAccountAccess.Info
                prepare(acct: AuthAccount) {
                  // set up the FLOAT Collection where users will store their FLOATs
                  if acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath) == nil {
                      acct.save(<- GrantedAccountAccess.createInfo(), to: GrantedAccountAccess.InfoStoragePath)
                      acct.link<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>
                              (GrantedAccountAccess.InfoPublicPath, target: GrantedAccountAccess.InfoStoragePath)
                  }
                  self.Info = acct.borrow<&GrantedAccountAccess.Info>(from: GrantedAccountAccess.InfoStoragePath)!
                }
                execute {
                  self.Info.addAccount(account: receiver)
                }
            }
        """
}
