pub contract Artist {
    pub struct Canvas {
        pub let width: UInt8
        pub let height: UInt8
        pub let pixels: String

        init(width: UInt8, height: UInt8, pixels: String) {
            self.width = width
            self.height = height
            // The following pixels
            // 123
            // 456
            // 789
            // should be serialized as
            // 123456789
            self.pixels = pixels
        }

        pub fun serializeStringArray(_ lines: [String]): String {
            var buffer = "";
            for line in lines {
                buffer = buffer.concat(line)
            }
            return buffer;
        }

        // display the canvas in a frame.
        pub fun display() {
            let len = self.pixels.length;
            var i = 0;
            var header_arr: [String] = ["+", "+"];
            while i < Int(self.width) {
                header_arr.insert(at: 1, "-");
                i = i + 1;
            }
            let header: String = self.serializeStringArray(header_arr);

            log(header);
            i = 0;
            while i < len {
                log(
                "|"
                .concat(self.pixels.slice(from: i, upTo: i + Int(self.width)))
                .concat("|")
                )
                i = i + Int(self.height);
            }
            log(header)
        }
    }

    pub resource Picture {
        pub let canvas: Canvas

        init(canvas: Canvas) {
            self.canvas = canvas
        }
    }

    pub event PicturePrintSuccess(pixels: String)
    pub event PicturePrintFailure(pixels: String)

    pub resource Printer {
        pub let width: UInt8
        pub let height: UInt8
        priv let printed: {String: Bool}

        init(width: UInt8, height: UInt8) {
            self.width = width;
            self.height = height;
            self.printed = {}
        }

        pub fun print(canvas: Canvas): @Picture? {
             // Canvas needs to fit Printer's dimensions.
            if canvas.pixels.length != Int(self.width * self.height) {
                return nil
            }
            // Canvas can only use visible ASCII characters.
            for symbol in canvas.pixels.utf8 {
                if symbol < 32 || symbol > 126 {
                    return nil
                }
            }
            if (!self.printed.containsKey(canvas.pixels)) {
                self.printed[canvas.pixels] = true
                emit PicturePrintSuccess(pixels: canvas.pixels);
                let pic <- create Picture(canvas: canvas)
                return <- pic
            } else {
                emit PicturePrintFailure(pixels: canvas.pixels)
                return nil;
            }
        }
    } 

    pub resource Collection {
        pub let collection: @[Picture];

        pub fun deposit(picture: @Picture) {
            self.collection.append(<-picture);
        }

        init() {
            self.collection <- [];
        }

        destroy() {
            destroy self.collection;
        }
    }

    pub fun createCollection(): @Collection {
        return <- create Collection()
    }

    init() {
        self.account.save(
            <- create Printer(width: 5, height: 5),
            to: /storage/ArtistPicturePrinter
        );
        self.account.link<&Printer>(
            /public/ArtistPicturePrinter,
            target: /storage/ArtistPicturePrinter
        );
    }
}