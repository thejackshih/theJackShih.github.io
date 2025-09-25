+++
title = "How to Boot from USB on an iBook G4"
author = ["Jack Shih"]
date = 2025-09-25T00:00:00+08:00
draft = false
+++

**Disclaimer: This post was proofread using ChatGPT.**

Recently, I pulled out my family's old vintage iBook G4. Somehow, a long time ago, I installed Ubuntu 13.10 on this machine. Of course, I already forgot the password-I didn’t even remember installing Ubuntu in the first place!

This time, I’m planning to restore it to macOS-specifically, OS X Leopard, which was the latest official version for PowerPC. After doing some research, people online recommend using a disc to install it rather than a USB.

But then I discovered the DVD drive is broken (it keeps ejecting every disc I put in). Guess I’ll have to do this the hard way.

This post is basically based on [this](https://www.youtube.com/watch?v=CZyiMlLZV1Q&list=PL3izGrqeHYQ3OIkESuUUDp5YV1qr5u0bb) YouTube video, with a few notes of my own.


## Prerequisites {#prerequisites}

-   A USB stick
    -   Preferably an older one. I had no luck with my 64GB stick, but it worked with an ancient 8GB one.
    -   I recommend a stick with a read indicator LED (the kind that flashes when reading/writing).
-   OS X install image (still available online).
    -   In my case, only the `.dmg` file worked.
-   An iBook.


## Prepare the USB Stick {#prepare-the-usb-stick}

1.  Use `Disk Utility` to format the USB stick with an `Apple Partition Map`.
    -   If you don't see the Scheme option, you're probably selecting just a partition instead of the whole drive. Click the drive icon on the left panel of Disk Utility, then choose "Show All Devices".
2.  Create a new partition using the `Mac OS Extended (Journaled)` format.
    -   Some people say you need to create a smaller partition if your USB stick is too large. Mine was 8GB, so I didn’t test this.
3.  Restore the OS image to the USB stick. I couldn’t get the GUI method to work, so I used this terminal command instead:

<!--listend-->

```shell
sudo asr restore --source {IMAGE_LOCATION} --target /Volumes/{DRIVE_NAME} --erase --noverify
```

1.  Use `Disk Utility` to check `Partition number`.
    -   If your device shows as `disk4s3`, then the partition number is `3`.


## Booting from USB Using Open Firmware {#booting-from-usb-using-open-firmware}

1.  Power on iBook while holding: `option` + `cmd` + `o` + `f`
2.  (Optional) Check if the USB drive’s LED is flashing (if it has one).
3.  Run the command `dev / ls` to list all devices.
4.  Look for something like `/usb@{SOME_NUMBER}` that has a `/disk@{SOME_NUMBER}` subtree.
    -   if you don't see `/disk@{SOME_NUMBER}` under `/usb@{SOME_NUMBER}`, it could mean:
        1.  The usb stick has incorrect format (not using apple partition).
        2.  The image doesn't work.
        3.  The iBook can't read the USB stick at all (refer to step 2).
5.  Set up an alias `devalias ud {FULL_PATH_TO_DISK}`. For example, mine was `devalias ud /pci@f2000000/usb@1b,1/disk@1`
6.  List the files on the USB Stick: `dir ud:{PARTITION_NUMBER},\` where paritition is based on previous step, mine was: `dir ud:3,\`
7.  If you see the file list, you're good to go.
8.  Boot using: `boot ud:{PARTITION_NUMBER},\System\Library|CoreServices\BootX`, mine was `boot ud:3,\System\Library\CoreServices\BootX`
9.  You should now see the install screen just like booting from install disc.


## References {#references}

-   <https://www.youtube.com/watch?v=CZyiMlLZV1Q&list=PL3izGrqeHYQ3OIkESuUUDp5YV1qr5u0bb&index=33>
-   <https://maydur.st/2024-03-19-open-firmware-crash-course/>
