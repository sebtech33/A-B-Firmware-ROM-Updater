function Update-Firmware_Rom {
    Clear-Host
    Write-Output "Please reboot the device to bootloader and connect the device to your pc."
    Write-Output 'If device is not listed below choose "n" to refresh.'
    fastboot devices
    Write-Host
    $fastboot = Read-Host "Is this the correct device and only device? (y/n/q)"
    if ($fastboot -eq "y") {
        Write-Host
        Update-Firmware
    }
    elseif ($fastboot -eq "n") {
        Update-Firmware_Rom
    }
    elseif ($fastboot -eq "q") {
        Write-Output "Exiting..."
        exit
    }
    else {
        Update-Firmware_Rom
    }

    Write-Host
    $recovery = Read-Host "Reboot to recovery? (y/n)"
    if ($recovery -eq "y") {
        fastboot reboot recovery
        $rom = Read-Host "Update ROM? (y/n)"
        if ($rom -eq "y") {
            Update-ROM
        }
        else {
            Write-Output "Exiting..."
            exit
        }
    }
    elseif ($recovery -eq "n") {
        $reboot = Read-Host "Reboot device? (y/n)"
        if ($reboot -eq "y") {
            fastboot reboot
        }
        else {
            Write-Output "Exiting..."
            exit
        }
    }
    else {
        Write-Output "Exiting..."
        exit
    }
}
function Update-Firmware {
    Clear-Host
    $ErrorActionPreference = "SilentlyContinue"
    if ($flash_msg) {
        Clear-Host
        Write-Host $flash_msg -ForegroundColor Red
        Write-Host -ForegroundColor White
    }
    $ErrorActionPreference = "Continue"


    # Flash boot
    Write-Output "Drag and drop the boot.img file here."
    $boot = (Read-Host "BOOT").Replace("`"", "")
    $boot_filename = Split-Path $boot -leaf
    $boot_extn = [IO.Path]::GetExtension($boot_filename)

    if ($boot_filename -match "boot" -and $boot_extn -match ".img") {
        fastboot flash boot_a $boot
        fastboot flash boot_b $boot
        Write-Host
    }
    else {
        $flash_msg = "ERROR: Invalid BOOT file.
        (boot.img requires to have boot in the name and .img extension)"
        Update-Firmware
    }

    # Flash dtbo
    Write-Output "Drag and drop the dtbo.img file here."
    $dtbo = (Read-Host "DTBO").Replace("`"", "")
    $dtbo_filename = Split-Path $dtbo -leaf
    $dtbo_extn = [IO.Path]::GetExtension($dtbo_filename)

    if ($dtbo_filename -match "dtbo" -and $dtbo_extn -match ".img") {
        fastboot flash dtbo_a $dtbo
        fastboot flash dtbo_b $dtbo
        Write-Host
    }
    else {
        $flash_msg = "ERROR: Invalid DTBO file.
        (dtbo.img requires to have dtbo in the name and .img extension)"
        Update-Firmware
    }

    # Flash Vendor Boot
    Write-Output "Drag and drop the vendor_boot.img file here."
    $vendor_boot = (Read-Host "VENDOR BOOT").Replace("`"", "")
    $vendor_boot_filename = Split-Path $vendor_boot -leaf
    $vendor_boot_extn = [IO.Path]::GetExtension($vendor_boot_filename)

    if ($vendor_boot_filename -match "vendor_boot" -and $vendor_boot_extn -match ".img") {
        fastboot flash vendor_boot_a $vendor_boot
        fastboot flash vendor_boot_b $vendor_boot
        Write-Host
    }
    else {
        $flash_msg = "ERROR: Invalid VENDOR BOOT file.
        (vendor_boot.img requires to have vendor_boot in the name and .img extension)"
        Update-Firmware
    }

    # Flash Vendor Kernel Boot
    Write-Output "Drag and drop the vendor_kernel_boot.img file here."
    $vendor_kernel_boot = (Read-Host "VENDOR KERNEL BOOT").Replace("`"", "")
    $vendor_kernel_boot_filename = Split-Path $vendor_kernel_boot -leaf
    $vendor_kernel_boot_extn = [IO.Path]::GetExtension($vendor_kernel_boot_filename)

    if ($vendor_kernel_boot_filename -match "vendor_kernel_boot" -and $vendor_kernel_boot_extn -match ".img") {
        fastboot flash vendor_kernel_boot_a $vendor_kernel_boot
        fastboot flash vendor_kernel_boot_b $vendor_kernel_boot
        Write-Host
    }
    else {
        $flash_msg = "ERROR: Invalid VENDOR KERNEL BOOT file.
        (vendor_kernel_boot.img requires to have vendor_kernel_boot in the name and .img extension)"
        Update-Firmware
    }

    # Flash Init Boot
    Write-Output "Drag and drop the init_boot.img or magisk_patched.img file here."
    $init_boot = (Read-Host "INIT BOOT").Replace("`"", "")
    $init_boot_filename = Split-Path $init_boot -leaf
    $init_boot_extn = [IO.Path]::GetExtension($init_boot_filename)

    if ($init_boot_filename -match "init_boot" -or $init_boot_filename -match "magisk_patched" -and $init_boot_extn -match ".img") {
        fastboot flash init_boot_a $init_boot
        fastboot flash init_boot_b $init_boot
        Write-Host
    }
    else {
        $flash_msg = "ERROR: Invalid INIT BOOT file.
        (init_boot.img requires to have init_boot in the name and .img extension)"
        Update-Firmware
    }
}

Function Update-ROM {
    Clear-Host
    $ErrorActionPreference = "SilentlyContinue"
    if ($rom_msg) {
        Clear-Host
        Write-Host $rom_msg -ForegroundColor Red
        Write-Host -ForegroundColor White
    }
    $ErrorActionPreference = "Continue"

    # Check if device is connected
    adb devices
    $device_connected = Read-Host "Is this the correct device and only device? (y/n/q)"
    if ($device_connected -eq "n") {
        Write-Output "Refreshing..."
        Update-ROM
    }
    elseif ($device_connected -eq "q") {
        Write-Output "Exiting..."
        exit
    }

    # Sideload ROM
    Write-Output 'To sideload the rom please choose "Apply update", then "Apply from ADB" in the recovery menu.'
    Write-host
    Write-Output "Drag and drop the rom.zip file here."
    $rom_path = (Read-Host "ROM").Replace("`"", "")
    $rom_filename = Split-Path $rom_path -leaf
    $rom_extn = [IO.Path]::GetExtension($rom_filename)

    if ($rom_extn -match ".zip") {
        adb sideload $rom_path
        Write-Host
    }
    else {
        $rom_msg = "ERROR: Invalid ROM file.
        (rom.zip requires to have a .zip extension)"
        Update-ROM
    }

    Write-Output "Follow the instructions on the device."
    Write-Host
    Write-Output "Do you need gapps to be installed? (y/n)"
    $gapps = (Read-Host "GAPPS").Replace("`"", "")
    if ($gapps -eq "y") {
        Write-Output "Drag and drop the gapps.zip file here."
        adb sideload $gapps
    }
    $reboot = Read-Host "Do you want to reboot the device now? (y/n)"
    if ($reboot -eq "y") {
        adb reboot
    }
    else {
        Write-Output "Exiting..."
        exit
    }

}

Clear-Host
$Banner = @"
███████╗██╗    ██╗       ██╗       ██████╗  ██████╗ ███╗   ███╗
██╔════╝██║    ██║       ██║       ██╔══██╗██╔═══██╗████╗ ████║
█████╗  ██║ █╗ ██║    ████████╗    ██████╔╝██║   ██║██╔████╔██║
██╔══╝  ██║███╗██║    ██╔═██╔═╝    ██╔══██╗██║   ██║██║╚██╔╝██║
██║     ╚███╔███╔╝    ██████║      ██║  ██║╚██████╔╝██║ ╚═╝ ██║
╚═╝      ╚══╝╚══╝     ╚═════╝      ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝

██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗██████╗
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ██████╔╝
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗██║  ██║
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
by SebTech33
"@

Write-Host $Banner
Write-Host
Write-Output "1. Update Firmware"
Write-Output "2. Update ROM"
Write-Output "3. Exit"
$rh = Read-Host "Option"

if ($rh -eq "1") {
    Update-Firmware_Rom
}
elseif ($rh -eq "2") {
    Update-ROM
}
elseif ($rh -eq "3") {
    Write-Output "Exiting..."
    exit
}


