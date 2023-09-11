PATH_BIN  = /usr/bin/
PATH_SBIN = /usr/sbin/

NASM      = $(PATH_BIN)nasm
MCOPY     = $(PATH_BIN)mcopy
MMD       = $(PATH_BIN)mmd
LINKER    = lld

OUT       = out/
OBJ       = $(OUT)test.obj
EFIH      = $(OUT)test.efi
IMG       = $(OUT)test.IMG
MAIN      = src/test.asm

AFLAGS    = -Ox -f win64 -o $(OBJ) $(MAIN)

LFLAGS    = -flavor link                 \
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
ifeq (, $(shell which $(LINKER)))
	echo "Can't execute lld, install lld."
endif
	@-$(LINKER) $(LFLAGS)

.PHONY: img 
img:
ifeq (, $(shell which mkfs.vfat))
	echo "Can't execute mkfs.vfat, install dosfstools."
endif
ifeq (, $(shell which $(MCOPY)))
	echo "Can't execute mcopy, install mtools."
endif
	@-dd if=/dev/zero of=$(IMG) bs=1M count=1
	@-mkfs.vfat $(IMG)
	@-$(MMD)   -i $(IMG) ::EFI
	@-$(MMD)   -i $(IMG) ::EFI/BOOT
	@-$(MCOPY) -i $(IMG) $(EFIH) ::EFI/BOOT/BOOTX64.EFI

.PHONY: qemu
qemu:
ifeq (, $(shell which qemu-system-x86_64))
	echo "Can't execute qemu-system-x86_64, install qemu."
endif
	@-qemu-system-x86_64 -bios bios/OVMF.fd -drive format=raw,file=$(IMG)

.PHONY: clean
clean:
	rm -rf $(OUT)
