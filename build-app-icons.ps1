# Icones PWA Android / Apple — logo-portail.png (phenix tricolore + TRIGONE)
Add-Type -AssemblyName System.Drawing

$base = $PSScriptRoot
$src = Join-Path $base 'logo application.png'
if (-not (Test-Path $src)) { $src = Join-Path $base 'logo-portail.png' }
if (-not (Test-Path $src)) { throw "Source introuvable : logo application.png ou logo-portail.png" }

$blanc = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)

function Test-IsBg([System.Drawing.Color]$c) {
    if ($c.A -lt 20) { return $true }
    return ($c.R -gt 248 -and $c.G -gt 248 -and $c.B -gt 248)
}

function Get-CroppedLogo([System.Drawing.Bitmap]$bmp) {
    $w = $bmp.Width; $h = $bmp.Height
    $minX = $w; $maxX = 0; $minY = $h; $maxY = 0
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            if (-not (Test-IsBg ($bmp.GetPixel($x, $y)))) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    $pad = 4
    $minX = [Math]::Max(0, $minX - $pad)
    $minY = [Math]::Max(0, $minY - $pad)
    $cw = [Math]::Min($w - $minX, $maxX - $minX + 1 + (2 * $pad))
    $ch = [Math]::Min($h - $minY, $maxY - $minY + 1 + (2 * $pad))
    $crop = New-Object System.Drawing.Bitmap $cw, $ch
    $g = [System.Drawing.Graphics]::FromImage($crop)
    $g.DrawImage($bmp, 0, 0, (New-Object System.Drawing.Rectangle $minX, $minY, $cw, $ch), [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    return $crop
}

function Save-AppIcon {
    param(
        [System.Drawing.Image]$Img,
        [string]$Dst,
        [int]$Size,
        [double]$PadRatio = 0.04
    )

    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($blanc)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    $pad = [int]($Size * $PadRatio)
    $inner = $Size - (2 * $pad)
    $scale = [Math]::Min($inner / $Img.Width, $inner / $Img.Height)
    $nw = [int][Math]::Round($Img.Width * $scale)
    $nh = [int][Math]::Round($Img.Height * $scale)
    $x = [int](($Size - $nw) / 2)
    $y = [int](($Size - $nh) / 2)
    $g.DrawImage($Img, $x, $y, $nw, $nh)
    $g.Dispose()
    $bmp.Save($Dst, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$srcBmp = [System.Drawing.Bitmap]::FromFile($src)
$cropped = Get-CroppedLogo $srcBmp
$srcBmp.Dispose()

Save-AppIcon -Img $cropped -Dst (Join-Path $base 'icon-192.png') -Size 192 -PadRatio 0.04
Save-AppIcon -Img $cropped -Dst (Join-Path $base 'icon-512.png') -Size 512 -PadRatio 0.04
Save-AppIcon -Img $cropped -Dst (Join-Path $base 'apple-touch-icon.png') -Size 180 -PadRatio 0.04
Save-AppIcon -Img $cropped -Dst (Join-Path $base 'icon-maskable-512.png') -Size 512 -PadRatio 0.12
$cropped.Dispose()

Write-Host 'OK icon-192.png, icon-512.png, apple-touch-icon.png, icon-maskable-512.png'
