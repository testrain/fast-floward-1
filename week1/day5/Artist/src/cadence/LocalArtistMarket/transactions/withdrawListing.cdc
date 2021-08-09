import LocalArtistMarket from "../contract.cdc"

transaction(listingIndex: Int) {
  prepare (acct: AuthAccount) {
    let marketRef = getAccount(0x3e1c9476cfe21394)
      .getCapability<&{LocalArtistMarket.MarketInterface}>(/public/LocalArtistMarket)
      .borrow() ?? panic("Couldn't borrow market interface reference")

    let listing: [LocalArtistMarket.Listing] = marketRef.getListings();
    if (listingIndex >= listing.length) {
      panic("listingIndex out of range");
    } else if (listing[listingIndex].seller != acct.address) {
      panic("msg.sender ["
          .concat(acct.address.toString())
          .concat("] is not the seller ")
          .concat(listing[listingIndex].seller.toString())
          );
    } else {
      marketRef.withdraw(listingIndex: listingIndex, to: acct.address)
    }
  }
}
