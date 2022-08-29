//
//  Scripts.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation

enum FloatScripts: String {
    case isSetup =
        """
          import FLOAT from 0xFLOAT
          import NonFungibleToken from 0xCORE
          import MetadataViews from 0xCORE
          import GrantedAccountAccess from 0xFLOAT

          pub fun main(accountAddr: Address): Bool {
            let acct = getAccount(accountAddr)
            if acct.getCapability<&FLOAT.Collection{FLOAT.CollectionPublic}>(FLOAT.FLOATCollectionPublicPath).borrow() == nil {
                return false
            }

            if acct.getCapability<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>(FLOAT.FLOATEventsPublicPath).borrow() == nil {
              return false
            }

            if acct.getCapability<&GrantedAccountAccess.Info{GrantedAccountAccess.InfoPublic}>(GrantedAccountAccess.InfoPublicPath).borrow() == nil {
                return false
            }
            return true
          }
        """
    case getGroups =
        """
          import FLOAT from 0xFLOAT
          pub fun main(account: Address): [&FLOAT.Group?] {
            let floatEventCollection = getAccount(account).getCapability(FLOAT.FLOATEventsPublicPath)
                                        .borrow<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>()
                                        ?? panic("Could not borrow the FLOAT Events Collection from the account.")
            let groups = floatEventCollection.getGroups()

            let answer: [&FLOAT.Group?] = []
            for groupName in groups {
                answer.append(floatEventCollection.getGroup(groupName: groupName))
            }

            return answer
          }
        """
    case getEvents =
        """
          import FLOAT from 0xFLOAT

          pub fun main(account: Address): [FLOATEventMetadata] {
            let floatEventCollection = getAccount(account).getCapability(FLOAT.FLOATEventsPublicPath)
                                        .borrow<&FLOAT.FLOATEvents{FLOAT.FLOATEventsPublic}>()
                                        ?? panic("Could not borrow the FLOAT Events Collection from the account.")
            let floatEvents: [UInt64] = floatEventCollection.getIDs()
            let returnVal: [FLOATEventMetadata] = []
            for eventId in floatEvents {
                let event = floatEventCollection.borrowPublicEventRef(eventId: eventId) ?? panic("This event does not exist in the account")
                let metadata = FLOATEventMetadata(
                    _claimable: event.claimable,
                    _dateCreated: event.dateCreated,
                    _description: event.description,
                    _eventId: event.eventId,
                    _extraMetadata: event.getExtraMetadata(),
                    _groups: event.getGroups(),
                    _host: event.host,
                    _image: event.image,
                    _name: event.name,
                    _totalSupply: event.totalSupply,
                    _transferrable: event.transferrable,
                    _url: event.url,
                    _verifiers: event.getVerifiers()
                )
                returnVal.append(metadata)
            }
            return returnVal
          }
          pub struct FLOATEventMetadata {
            pub let claimable: Bool
            pub let dateCreated: UFix64
            pub let description: String
            pub let eventId: UInt64
            pub let extraMetadata: {String: AnyStruct}
            pub let groups: [String]
            pub let host: Address
            pub let image: String
            pub let name: String
            pub let totalSupply: UInt64
            pub let transferrable: Bool
            pub let url: String
            pub let verifiers: {String: [{FLOAT.IVerifier}]}
            init(
                _claimable: Bool,
                _dateCreated: UFix64,
                _description: String,
                _eventId: UInt64,
                _extraMetadata: {String: AnyStruct},
                _groups: [String],
                _host: Address,
                _image: String,
                _name: String,
                _totalSupply: UInt64,
                _transferrable: Bool,
                _url: String,
                _verifiers: {String: [{FLOAT.IVerifier}]}
            ) {
                self.claimable = _claimable
                self.dateCreated = _dateCreated
                self.description = _description
                self.eventId = _eventId
                self.extraMetadata = _extraMetadata
                self.groups = _groups
                self.host = _host
                self.image = _image
                self.name = _name
                self.transferrable = _transferrable
                self.totalSupply = _totalSupply
                self.url = _url
                self.verifiers = _verifiers
            }
          }
        """
    case getFloats =
        """
        import FLOAT from 0xFLOAT
        pub fun main(account: Address): [CombinedMetadata] {
          let floatCollection = getAccount(account).getCapability(FLOAT.FLOATCollectionPublicPath)
                                .borrow<&FLOAT.Collection{FLOAT.CollectionPublic}>()
                                ?? panic("Could not borrow the Collection from the account.")
          let ids = floatCollection.getIDs()
          var returnVal: [CombinedMetadata] = []
          for id in ids {
            let nft: &FLOAT.NFT = floatCollection.borrowFLOAT(id: id)!
            let eventId = nft.eventId
            let eventHost = nft.eventHost

            let event = nft.getEventMetadata()
            returnVal.append(CombinedMetadata(_float: nft, _totalSupply: event?.totalSupply, _transferrable: event?.transferrable))
          }

          return returnVal
        }

        pub struct CombinedMetadata {
            pub let float: &FLOAT.NFT
            pub let totalSupply: UInt64?
            pub let transferrable: Bool?

            init(
                _float: &FLOAT.NFT,
                _totalSupply: UInt64?,
                _transferrable: Bool?
            ) {
                self.float = _float
                self.totalSupply = _totalSupply
                self.transferrable = _transferrable
            }
        }
        """
}
