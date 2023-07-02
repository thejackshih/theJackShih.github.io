title: How to boot into linux on v3-372 / 在 V3-372 上如何開機進入 Linux
date: 2016-11-04 09:45:43
tags: 
- linux
- acer
- v3-372
---
There is not much information about this problem on Internet. Truns out it need more configuration than simply disable secure boot.

1. Boot into BIOS (Press F2 on boot screen.)
2. Swtich to boot tab.
3. Make sure secure boot is enable.
4. Switch to Security tab.
5. Select "Select an UEFI file as trusted for executing".
6. Select the proper .efi file. (Ex. EFI/ubuntu/grubx64.efi on ubuntu 16.10 64bit)
7. Disable secure boot if you want.
8. Save change and boot into BIOS again.
9. You should see your boot option in boot tab now.
