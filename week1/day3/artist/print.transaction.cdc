import Artist from "./artist.contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
    let printerRef: &Artist.Printer;
    let collectionRef: &Artist.Collection;
    let addrStr: String;

    prepare(acct: AuthAccount) {
        self.addrStr = acct.address.toString();
        // Note: Global printer was deployed to emulator-artist account. See flow.json for more info. 
        self.printerRef = getAccount(0x01cf0e2f2f715450).getCapability<&Artist.Printer>(/public/ArtistPicturePrinter).borrow() ?? panic("Couldn't borrow global printer reference");
        self.collectionRef = acct.getCapability<&Artist.Collection>(/public/ArtistPictureCollection).borrow() ?? panic("Couldn't borrow account collection reference");
    }

    execute {
        let canvas = Artist.Canvas(width: width, height: height, pixels: pixels)
        let pic <- self.printerRef.print(canvas: canvas)
        if (pic == nil) {
            log("Picture with ".concat(pixels).concat(" already exists!"))
            destroy pic
        } else {
            log("Picture printed and stored into collection of ".concat(self.addrStr));
            self.collectionRef.deposit(picture: <- pic!);
        }
    }
}
