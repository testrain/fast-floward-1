import Artist from "./artist.contract.cdc"

// Create a Picture Collection for the transaction authorizer.
transaction {

  prepare(acct: AuthAccount) {
    // Creating collection singleton for each interacted account.
    let selfCollectionCap = acct.getCapability<&Artist.Collection>(/public/ArtistPictureCollection);
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
      log("Found existing collection in ".concat(acct.address.toString()));
    }
  }
}
