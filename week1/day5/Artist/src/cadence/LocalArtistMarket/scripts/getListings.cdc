import LocalArtistMarket from "../contract.cdc"

pub fun main(): [LocalArtistMarket.Listing] {
  let marketRef = getAccount(0x3e1c9476cfe21394)
    .getCapability<&{LocalArtistMarket.MarketInterface}>(/public/LocalArtistMarket)
    .borrow() ?? panic("Couldn't borrow market interface reference");

  return marketRef.getListings();
}
