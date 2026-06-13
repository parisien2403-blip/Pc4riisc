Add-Type -AssemblyName System.Drawing
$src = Join-Path $PSScriptRoot 'logo-portail.png'
$dst = Join-Path $PSScriptRoot 'logo-trigone.png'
$bmp = [System.Drawing.Bitmap]::FromFile($src)
$out = New-Object System.Drawing.Bitmap $bmp.Width, $bmp.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
for ($y = 0; $y -lt $bmp.Height; $y++) {
  for ($x = 0; $x -lt $bmp.Width; $x++) {
    $c = $bmp.GetPixel($x, $y)
    if ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240) {
      $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, $c.R, $c.G, $c.B))
    }
    elseif ($c.R -gt 220 -and $c.G -gt 220 -and $c.B -gt 220) {
      $edge = [Math]::Min(255, [int]((255 - [Math]::Min($c.R, [Math]::Min($c.G, $c.B))) * 8))
      $a = [Math]::Max(0, 255 - $edge)
      $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($a, $c.R, $c.G, $c.B))
    }
    else {
      $out.SetPixel($x, $y, $c)
    }
  }
}
$out.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$out.Dispose()
Write-Host "Created $dst"
