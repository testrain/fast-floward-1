import LocalArtist from 0x3e1c9476cfe21394
import LocalArtistMarket from 0x3e1c9476cfe21394
import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

transaction(listingIndex: Int) {
  let marketRef: &{LocalArtistMarket.MarketInterface};
  let buyerVaultWithdrawn: @FungibleToken.Vault;
  let buyerAddr: Address;

  prepare(acct: AuthAccount) {
    self.marketRef = getAccount(0x3e1c9476cfe21394)
      .getCapability<&{LocalArtistMarket.MarketInterface}>(/public/LocalArtistMarket)
      .borrow() ?? panic("Couldn't borrow market interface reference");
    let listing: [LocalArtistMarket.Listing] = self.marketRef.getListings();
    if (listingIndex >= listing.length) {
      panic("listingIndex out of range");
    } else {
      let price = listing[listingIndex].price;
      let buyerVaultRef = acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!
        self.buyerVaultWithdrawn <- buyerVaultRef.withdraw(amount: price)
        self.buyerAddr = acct.address;
    }
  }

  execute {
    self.marketRef.buy(listing: listingIndex, with: <- self.buyerVaultWithdrawn, buyer: self.buyerAddr);
  }
}
