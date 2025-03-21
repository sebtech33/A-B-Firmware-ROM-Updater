# A-B-Firmware-ROM-Updater
This is a over-complicated Firmware and ROM updater for phones that has A/B partitions.
This will include devices that often uses payload.bin files for update. This does require that the payload is dumped before using this, but using a extractor of sorts (Payload Extrator or Payload Dumper e.g.). After using that this script will guide you through what you need to do afterwards.

---

# Usage
1. Download "Update-Firmware.ps1" (RAW) or Clone the repo
2. CD into the folder where the downloaded script file or into the cloned folder.
3. Run the script from a terminal in the location where the file is located with powershell by running `.\Update-Firmware.ps1`
4. Follow the on-screen instructions.

---

# WIP
This was made fast as I got bored of typing the same commands over and over. But wanted some checks so that you can't flash a boot image to the dtbo partition and so on. The checks a compleatly rudimentary and only checks the filename to have the correct partition in the name and that it is a .img file. so it does not check if its for the correct device or so on. So as a warning do be careful with what you do with your phone and by using this script you accept the risk of doing so.

---

# WARNING
By using this you accept the risk of doing so. I'm not responsible for bricking your device. Flash only what you know if tailord for your device on your device and be sure to follow instructions for your device. You can look through the code to see if the same commands are used for your device and your rom.

---

# Tested and working on
## Android devices:
- Google Pixel 9 Pro Fold (My personal device)


## Host Machines:
- Windows 11 with Powershell Core (7)

## Please report it working or not working for your device on the issues page and ill try to help.
