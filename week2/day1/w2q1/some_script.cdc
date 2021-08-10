import SomeContract from "./some_contract.cdc";

pub fun main() {
  // Area 4

  let aStruct = SomeContract.SomeStruct();
  // a,b are readable in Area 4; c,d are not readable in Area 4.
  log(aStruct.a);
  log(aStruct.b);

  // Only a is writable in Area 4.
  aStruct.a = "a is writable in Area 4";

  // Only publicFunc() is callable here.
  aStruct.publicFunc();
}