# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/Evolution-X/manifest.git -b tiramisu -g default,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j16
rm -rf hardware/samsung
git clone https://github.com/LineageOS/android_hardware_samsung.git -b lineage-20 hardware/samsung
rm -rf hardware/samsung/AdvancedDisplay
git clone https://github.com/LineageOS/android_hardware_samsung_nfc hardware/samsung/nfc
git clone https://github.com/LineageOS/android_device_samsung_slsi_sepolicy device/samsung_slsi/sepolicy -b lineage-20
git clone https://github.com/LineageOS/android_hardware_samsung_slsi_libbt hardware/samsung_slsi/libbt -b lineage-20
git clone https://github.com/LineageOS/android_hardware_samsung_slsi_scsc_wifibt_wifi_hal hardware/samsung_slsi/scsc_wifibt/wifi_hal -b lineage-20
git clone https://github.com/LineageOS/android_hardware_samsung_slsi_scsc_wifibt_wpa_supplicant_lib hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib -b lineage-20 && git clone https://github.com/parikk/android_device_samsung_universal7904 device/samsung/universal7904-common
git clone https://github.com/parikk/android_device_samsung_m20lte device/samsung/m20lte
git clone --depth=1 https://github.com/SamarV-121/proprietary_vendor_samsung_universal7904-common -b lineage-20 vendor/samsung/universal7904-common
git clone --depth=1 https://github.com/SamarV-121/proprietary_vendor_samsung_m20lte -b lineage-20 vendor/samsung/m20lte
git clone --depth=1 https://github.com/SamarV-121/android_kernel_samsung_universal7904 -b lineage-20 kernel/samsung/universal7904

# build rom
source $CIRRUS_WORKING_DIR/script/config
timeStart

. build/envsetup.sh
export BUILD_USERNAME=parikk
export BUILD_HOSTNAME=parikk-build
export EVO_BUILD_TYPE=OFFICIAL
lunch evolution_lmi-userdebug
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
mka evolution -j16  > reading & sleep 95m

retVal=$?
timeEnd
statusBuild
# end
