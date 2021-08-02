import Artist from 0x02

pub fun main() {
    let accts: [Address; 5] = [0x01, 0x02, 0x03, 0x04, 0x05];
    for acct in accts {
      let collectionRef = getAccount(acct)
        .getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
        .borrow();
      if (collectionRef != nil) {
        let cr = collectionRef!
        let len = cr.collection.length
        var i = 0;
        while i < len {
          let canvas = cr.collection[i].canvas
          canvas.display();
          i = i + 1
        }
      } else {
        log("Account ".concat(acct.toString()).concat(" doesn't yet have a Collection"))
      }
    }
}