# Genere trigone-pc.ico (multi-tailles 16-256) pour raccourci Windows
Add-Type -AssemblyName System.Drawing

$base = $PSScriptRoot
$src = Join-Path $base 'icon-512.png'
if (-not (Test-Path $src)) { $src = Join-Path $base 'logo application.png' }
if (-not (Test-Path $src)) { throw 'icon-512.png ou logo application.png introuvable' }

$out = Join-Path $base 'trigone-pc.ico'
$sizes = @(256, 48, 32, 16)

Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class TrigoneIcoWriter
{
    public static void Write(string pngPath, string icoPath, int[] sizes)
    {
        using (var src = new Bitmap(pngPath))
        using (var fs = File.Create(icoPath))
        using (var bw = new BinaryWriter(fs))
        {
            var pngChunks = new List<byte[]>();
            foreach (var size in sizes)
            {
                using (var bmp = new Bitmap(size, size, PixelFormat.Format32bppArgb))
                {
                    using (var g = Graphics.FromImage(bmp))
                    {
                        g.Clear(Color.White);
                        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        g.SmoothingMode = SmoothingMode.HighQuality;
                        g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                        var pad = Math.Max(1, (int)(size * 0.04));
                        var inner = size - (pad * 2);
                        var scale = Math.Min((float)inner / src.Width, (float)inner / src.Height);
                        var w = (int)Math.Round(src.Width * scale);
                        var h = (int)Math.Round(src.Height * scale);
                        var x = (size - w) / 2;
                        var y = (size - h) / 2;
                        g.DrawImage(src, x, y, w, h);
                    }
                    using (var ms = new MemoryStream())
                    {
                        bmp.Save(ms, ImageFormat.Png);
                        pngChunks.Add(ms.ToArray());
                    }
                }
            }

            bw.Write((short)0);
            bw.Write((short)1);
            bw.Write((short)sizes.Length);
            var offset = 6 + (16 * sizes.Length);
            for (var i = 0; i < sizes.Length; i++)
            {
                var size = sizes[i];
                bw.Write((byte)(size >= 256 ? 0 : size));
                bw.Write((byte)(size >= 256 ? 0 : size));
                bw.Write((byte)0);
                bw.Write((byte)0);
                bw.Write((short)1);
                bw.Write((short)32);
                bw.Write(pngChunks[i].Length);
                bw.Write(offset);
                offset += pngChunks[i].Length;
            }
            foreach (var chunk in pngChunks) bw.Write(chunk);
        }
    }
}
'@ -ReferencedAssemblies System.Drawing

[TrigoneIcoWriter]::Write($src, $out, $sizes)
$len = (Get-Item $out).Length
Write-Host "OK $out ($len octets)"
