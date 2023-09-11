PATH_BIN = /usr/bin/

NASM     = $(PATH_BIN)nasm
LLD      = $(PATH_BIN)lld

OUT      = out/
OBJ      = $(OUT)test.obj
EFIH     = $(OUT)test.efi
IMG      = $(OUT)test.IMG
MAIN     = src/test.asm

AFLAGS   = -Ox -f win64 -o $(OBJ) $(MAIN)

LFLAGS   = -flavor link                 \
           -subsystem:efi_application   \
		   -entry:_start                \
		   -out:$(EFIH)                 \
		   -nodefaultlib                \
		   $(OBJ) 

.PHONY: all
all: mkdirs build link
		 
.PHONY: mkdirs
mkdirs:
	mkdir -p $(OUT)

.PHONY: build
build:
	@-$(NASM) $(AFLAGS)

.PHONY: link
link:
	@-$(LLD) $(LFLAGS)

.PHONY: clean
clean:
	rm -rf $(OUT)