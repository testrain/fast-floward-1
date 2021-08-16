import KittyItems from Project.KittyItems;
import NonFungibleToken from Flow.NonFungibleToken;

// This transaction transfers a Kitty Item from one account to another.

transaction(recipient: Address, withdrawID: UInt64) {
    // local variable for a reference to the signer's Kitty Items Collection
    let signerCollectionRef: &KittyItems.Collection

    // local variable for a reference to the receiver's Kitty Items Collection
    let receiverCollectionRef: &{NonFungibleToken.CollectionPublic}

    prepare(signer: AuthAccount) {
        // 1) borrow a reference to the signer's Kitty Items Collection
        self.signerCollectionRef = signer
            .borrow<&KittyItems.Collection>(from: KittyItems.CollectionStoragePath)
            ?? panic("Signer KittyItems.Collection storage not setup");
        // 2) borrow a public reference to the recipient's Kitty Items Collection
        self.receiverCollectionRef = getAccount(recipient)
            .getCapability(KittyItems.CollectionPublicPath)
            .borrow<&KittyItems.Collection{NonFungibleToken.CollectionPublic}>()
            ?? panic("receiver NFT.CollectionPublic not setup");
    }

    execute {
        // 3) withdraw the Kitty Item from the signer's Collection
        let item <- self.signerCollectionRef.withdraw(withdrawID: withdrawID);
        // 4) deposit the Kitty Item into the recipient's Collection
        self.receiverCollectionRef.deposit(token: <-item);
    }
}