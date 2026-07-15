DEVICE_PATH := device/oppo/heal

# Screen density
PRODUCT_PROPERTY_OVERRIDES +=     ro.sf.lcd_density=510

# Permissions
PRODUCT_COPY_FILES +=     frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:/etc/permissions/android.hardware.camera.flash-autofocus.xml     frameworks/native/data/etc/android.hardware.camera.front.xml:/etc/permissions/android.hardware.camera.front.xml     frameworks/native/data/etc/android.hardware.fingerprint.xml:/etc/permissions/android.hardware.fingerprint.xml     frameworks/native/data/etc/android.hardware.nfc.xml:/etc/permissions/android.hardware.nfc.xml

# Overlays
DEVICE_PACKAGE_OVERLAYS +=     $(DEVICE_PATH)/overlay

# Vendor proprietary files
$(call inherit-product, vendor/oppo/heal/BoardConfigVendor.mk)
