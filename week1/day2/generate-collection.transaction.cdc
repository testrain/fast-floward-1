import Artist from 0x02

transaction {
  let printerRef: &Artist.Printer
  let collectionRef: &Artist.Collection

  // Creating collection for the interacted account for its first time
  prepare(acct: AuthAccount) {
    let selfCollectionCap = acct.getCapability<&Artist.Collection>(/public/ArtistPictureCollection);
    // Creating link for the first time 
    if (selfCollectionCap.check() == false) {
      log("No collection exists in ".concat(acct.address.toString()).concat(", creating collection now..."))
      acct.save(
        <- Artist.createCollection(),
        to: /storage/ArtistPictureCollection
      );
      acct.link<&Artist.Collection>(
        /public/ArtistPictureCollection,
        target: /storage/ArtistPictureCollection
      );
    } else {
      log("Use existing collection in ".concat(acct.address.toString()));
    }

    self.collectionRef = selfCollectionCap.borrow() ?? panic("Couldn't borrow collection reference");
    self.printerRef = getAccount(0x02)
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow() ?? panic("Couldn't borrow printer reference");
  }

  execute {
    // Replace with your own drawings.
    let pixels = "* * * * *   *   * * *   *"
    let canvas = Artist.Canvas(
      width: self.printerRef.width,
      height: self.printerRef.height,
      pixels: pixels
    )

    let pic <- self.printerRef.print(canvas: canvas);
    if (pic == nil) {
      log("Picture with ".concat(pixels).concat(" already exists!"))
      destroy pic
    } else {
      log("Picture printed and deposited!");
      self.collectionRef.deposit(picture: <- pic!);
    }
  }
}