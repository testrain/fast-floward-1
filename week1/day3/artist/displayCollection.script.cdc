import Artist from "./artist.contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {
    let collectionRef = getAccount(address).getCapability<&Artist.Collection>(/public/ArtistPictureCollection).borrow();
    if (collectionRef == nil) {
        return nil;
    } else {
        let cr = collectionRef!;
        let len = cr.collection.length;
        let pics: [String] = [];
        var i = 0;
        while i < len {
            pics.append(cr.collection[i].canvas.pixels);
            i = i + 1;
        }
        return pics;
    }
}