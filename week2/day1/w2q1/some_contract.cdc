access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {
        // 4 Variables
        //
        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        // 3 Functions
        //
        pub fun publicFunc() {}

        access(self) fun privateFunc() {}

        access(contract) fun contractFunc() {}


        pub fun structFunc() {
            // Area 1

            // a,b,c,d are all readable in Area 1
            log(self.a);
            log(self.b);
            log(self.c)
            log(self.d);

            // a,b,c,d are all writable in Area 1
            self.a = "a in Area 1 writable";
            self.b = "b in Area 1 writable";
            self.c = "c in Area 1 writable";
            self.d = "d in Area 1 writable";

            // All 3 functions are accessible in Area 1
            self.publicFunc();
            self.privateFunc();
            self.contractFunc();
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            // Area 2

            // a,b,c are all readable in Area 1; d is NOT readable here.
            let aStruct = SomeContract.SomeStruct();
            log(aStruct.a);
            log(aStruct.b);
            log(aStruct.c);

            // Only a is writable here.
            aStruct.a = "a is writable in Area 2";

            // publicFunc() and contractFunc() are callable; privateFunc() is NOT callable here.
            aStruct.publicFunc();
            aStruct.contractFunc();
        }

        init() {
            self.e = 17
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        // Area 3

        // a,b,c are readble in Area 3; d is NOT readable
        log(self.testStruct.a);
        log(self.testStruct.b);
        log(self.testStruct.c);

        // a is writable in Area 3; b,c,d are NOT writable here.
        self.testStruct.a = "a in Area 3 writable";

        // only SomeStruct.publicFunc() and SomeStruct.contractFunc() are callable here.
        self.testStruct.publicFunc();
        self.testStruct.contractFunc();
    }

    init() {
        self.testStruct = SomeStruct()
    }
}
 