$root = $PSScriptRoot

function Download-Asset($url, $subpage) {
    if ($url -match "(\d{24}_.*?\..*?)$") {
        $filename = $matches[1]
    }
    elseif ($url -match "([^/]+\.riv)$") {
        $filename = $matches[1]
    }
    elseif ($url -match "([^/]+\.gif)$") {
        $filename = $matches[1]
    }
    else {
        $filename = $url.Split('/')[-1]
    }
    
    $filename = [uri]::UnescapeDataString($filename)
    $targetDir = "$root\$subpage\img"
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    $targetPath = "$targetDir\$filename"
    
    Write-Host "Downloading $filename to $subpage..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $targetPath -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to download $url"
    }
}

# Iconography
$iconographyUrls = @(
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/675a15088dcb88ed7da57a2a_Iconography%20-%20Slot%20machine.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6757139e300c51acda4b6329_slot_machine_%E2%80%93_mobile.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740b57f0d1bbe853a60e078_iconography-app.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740b46d207752963404485a_iconography-app-mobile.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a49e4b5180c8c54451de_rocket.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a46e52bba2508ad030aa_link.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a42825c13c8c21b2387b_early%20bird.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a326f6c7204d229a4eb1_credit%20card.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a34170efb03215735b88_fingerprint.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a30da7790d656513827f_camera.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a31c0c3d6692b9df6c7a_celebrate.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a336e1b75d578e0a7119_external%20drive.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a34940acac6c6cdf0cbd_heart.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a3525d4b50e2ed1da7e8_highlight.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a35a5d4b50e2ed1db40e_mic.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a36243778f507af060cc_person%20multiple.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a36bd19501c45992162c_restore.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a373e7ad3088f9275e0d_thumbs%20up.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a37d90cafe3b3792b953_twinkle%204.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a387d65c95c1c6ef4bc8_warning.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a38f2d5ab3f3176d6752_zip.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a3fc1e4a1a270158cb7f_accounts.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4057c47bd7e9950d879_add%20comment.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a40ea80e0786882c0ba3_analytics.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a41790cafe3b379395da_audio.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a420e1b75d578e0b53b6_automation.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a432e1b75d578e0b660c_emoji%20sunglasses.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a43b04c741699b0bf5fc_fail.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a44443778f507af13dce_follow.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a44e43778f507af1462a_game.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a458524f6566ba5d1b47_lightbulb.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4772f89df9225df6689_passwords.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a48043778f507af18e72_PDF.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a488ae7d0f226d79316c_pin.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a495bece621f76edbc5f_print.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4a97c47bd7e9951524c_sprout.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4b252426a633bca5e9e_stamp.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4ba165743c029122e96_unknown.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4c4a80e0786882cbbc6_upload%20file.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4cd2cb3fd0491148a61_upload%20folder.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4d51fd80ad6e795ccb8_warning.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a4df82323949c55b2b77_win.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a657b8ee169914bfbf87_add%20folder.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a6a83dff9632122c097f_clock.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a6bba0fed9da28f13089_crop.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a6cfb8efb8dd4463e3e8_edit.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a6f05d4b50e2ed20b301_image.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a75025c13c8c21b4d552_UIIcon.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a76ee1f0731a7f89ed39_notification.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a79d9d6490392b705689_record.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a7aea80e0786883309dd_send.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a7bf594e062e3df49df2_signable%20document.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a7d5594e062e3df4ab93_slider.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722a7e540acac6c6ce33e58_upload.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6759bf91b7f4707dd0546352_Group%201400004280.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6759c098c938b3395f9e63b6_Group%20asdasdasd.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6759c0b4e415c9d249b7520c_werwerwer.svg',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/672bbdc668fbbfbc72aa5842_ytj.png',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/674613a74de19716b23bd06a_Creation%20Panel.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/673e2d8e64232aaf72d8cb8b_Group%201400004260.png'
)

# Imagery
$imageryUrls = @(
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6793e7082c730ee06481a671_imagery_-_web-updated.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/67587bacc2b7ca09077dad4e_imagery-app_-_mobile.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722b2e2d54cd944c562df34_Frame%20201154.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722aeb03f5a54aab93fa032_Notifications-Dog_Spot_DM%201.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/675b1245f426d35814273bb2_docsend-time-spent-focused-648x335.png',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6722b106a3e00d418282016b_Gray%20350%20docs.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6733c8962bc1d0fdab0ea676_The%20Luupe_YaelNovMobile4_woman_144dpi-1.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/67477c4f13adb5f56daf7520_Group%201171278736.png',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d36de914f76b000d0d93_Frame%201321315263-1.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d59a9bfa1c956d02b617_Jumbo-oatmeal-banana-cookies.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d33223409800d705bd44_artwork_01.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d567f5414236ffd7e845_image%201564.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d3eb599478262cf256c9_Frame%201321315263.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d55406ca8259aed07f80_image%201564-1.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d57662dcb163c5083f10_IMG_4562%201.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d5c4a41c91dc0b5692ec_production_id_4463164%20(1080p)%201.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d5058d8c664c4df19d04_GettyImages-1493955613.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d5efd221b66df0f0b7cc_streetiphone-iphonepics-6.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d5879bfa1c956d02a9d0_Invoice.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d514a2b9041a88919d0b_Group%201321315263-1.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d53b2fbe8b6285050afe_Group%201321315263.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6744d5de09d1bc1c7311f353_shina-shonocollection-dropbox-artifact-27.webp'
)

# Motion
$motionUrls = @(
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/674664f62774f41bc13a74c1_ec9f58238cd0ef03e6ae0ba36c19e502.gif',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6734d5f92596ac60996d81c7_motion_principle_animations.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6747a967815f75ccd95a7058_motion_principle_animations-mobile.riv'
)

# Typography
$typographyUrls = @(
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/673bd08c554a9ff79e07512a_Frame%201400003462.webp'
)

# Color
$colorUrls = @(
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740ec221f2fa3aa308548c9_DROPBOX-CHAZ-2786%201.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740ec509c43e68c2b5e0bda_DROPBOX-CHAZ-2786%201-1.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740ec5ba30dd5afbcc30a4e_DROPBOX-CHAZ-2786%201-2.webp',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/673cbc55eada3b7cd44ceada_Color%20-%20color_picker.riv',
    'https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/6740fa3ed4e7840cdc0d176a_color_picker-mobile.riv'
)

Write-Host "Starting download process..."
foreach ($url in $iconographyUrls) { Download-Asset $url "iconography" }
foreach ($url in $imageryUrls) { Download-Asset $url "imagery" }
foreach ($url in $motionUrls) { Download-Asset $url "motion" }
foreach ($url in $typographyUrls) { Download-Asset $url "typography" }
foreach ($url in $colorUrls) { Download-Asset $url "color" }
Write-Host "Download complete!"
