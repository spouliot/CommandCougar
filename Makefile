SWIFTOMATIC=/Users/poupou/Downloads/swift-o-matic

SWIFT_BIN = $(SWIFTOMATIC)/bin/swift/bin
SWIFT_LIB = $(SWIFTOMATIC)/bin/swift/lib/swift/macosx/
SWIFT_DLL = $(SWIFTOMATIC)/lib/SwiftInterop/

XAMARIN_MAC = "/Users/poupou/Dropbox (Personal)/Xamarin.Mac.dll"

SYSTEM_CSC = csc
MOBILE_BCL_DIR = /Library/Frameworks/Xamarin.Mac.framework/Versions/Current/lib/mono/Xamarin.Mac/
MAC_mobile_CSC = $(SYSTEM_CSC) -nostdlib -noconfig -r:$(MOBILE_BCL_DIR)/mscorlib.dll -r:$(MOBILE_BCL_DIR)/System.dll -r:$(XAMARIN_MAC)

SWIFTC = $(SWIFT_BIN)/swiftc
SWIFTARGS = -sdk `xcrun --show-sdk-path` -emit-module -emit-library

TOM_SWIFTY=$(SWIFTOMATIC)/lib/swift-o-matic/tom-swifty.exe
SWIFT_GLUE = $(SWIFTOMATIC)/lib/mac/XamGlue.framework

OUTPUT_MODULE=XamCougar
TOM_SWIFTY_OUTPUT=tsout

all: libXamCougar.dylib
	@rm -rf $(TOM_SWIFTY_OUTPUT)
	@mkdir $(TOM_SWIFTY_OUTPUT)
	mono --debug $(TOM_SWIFTY) --retain-swift-wrappers --swift-bin-path $(SWIFT_BIN) -o $(TOM_SWIFTY_OUTPUT) -C . -module-name $(OUTPUT_MODULE)
	$(MAC_mobile_CSC) -unsafe -lib:$(SWIFT_DLL) -r:SwiftRuntimeLibrary.Mac.dll -lib:. tsout/*.cs -t:library -out:$(OUTPUT_MODULE).dll

libXamCougar.dylib:
	$(SWIFTC) $(SWIFTARGS) -module-name $(OUTPUT_MODULE) Sources/*.swift

clean:
	@rm -rf tsout
	@rm -rf libXamCougar.dylib
