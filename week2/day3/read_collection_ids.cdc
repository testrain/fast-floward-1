import NonFungibleToken from Flow.NonFungibleToken
import KittyItems from Project.KittyItems

// This script returns an array of all the NFT IDs in an account's Kitty Items Collection.

pub fun main(address: Address): [UInt64] {
    // 1) Get a public reference to the address' public Kitty Items Collection
    let collectionRef = getAccount(address)
        .getCapability(KittyItems.CollectionPublicPath)
        .borrow<&KittyItems.Collection{KittyItems.KittyItemsCollectionPublic}>()
        ?? panic("address KittyItems.Collection not setup");
    // 2) Return the Collection's IDs 
    return collectionRef.getIDs();
}