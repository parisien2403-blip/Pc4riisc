# Serveur HTTP local TRIGONE PC — sans Node.js (127.0.0.1:8765)
$ErrorActionPreference = 'Stop'
$Port = 8765
$Root = $PSScriptRoot
if (-not $Root) { $Root = Get-Location | Select-Object -ExpandProperty Path }

$Mime = @{
  '.html' = 'text/html; charset=utf-8'
  '.htm'  = 'text/html; charset=utf-8'
  '.js'   = 'application/javascript; charset=utf-8'
  '.json' = 'application/json; charset=utf-8'
  '.css'  = 'text/css; charset=utf-8'
  '.png'  = 'image/png'
  '.jpg'  = 'image/jpeg'
  '.jpeg' = 'image/jpeg'
  '.webp' = 'image/webp'
  '.ico'  = 'image/x-icon'
  '.webmanifest' = 'application/manifest+json'
  '.omr'  = 'application/json'
}

function Get-LocalFile([string]$UrlPath) {
  $rel = [Uri]::UnescapeDataString($UrlPath.TrimStart('/')).Replace('/', [IO.Path]::DirectorySeparatorChar)
  if ([string]::IsNullOrWhiteSpace($rel)) { $rel = 'index.html' }
  $full = [IO.Path]::GetFullPath((Join-Path $Root $rel))
  $rootFull = [IO.Path]::GetFullPath($Root)
  if (-not $full.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase)) { return $null }
  if (Test-Path $full -PathType Container) {
    $full = Join-Path $full 'index.html'
  } elseif (-not (Test-Path $full -PathType Leaf)) {
    $tryHtml = $full + '.html'
    if (Test-Path $tryHtml -PathType Leaf) { $full = $tryHtml }
    elseif (-not [IO.Path]::HasExtension($full)) {
      $full = Join-Path $full 'index.html'
    }
  }
  if (-not (Test-Path $full -PathType Leaf)) { return $null }
  return $full
}

$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add("http://127.0.0.1:$Port/")
$Listener.Start()

Write-Host ''
Write-Host '  TRIGONE PC — serveur local actif'
Write-Host "  http://127.0.0.1:$Port/"
Write-Host ''
Write-Host '  Laissez cette fenetre ouverte pendant l''utilisation.'
Write-Host '  Fermez-la pour arreter TRIGONE PC.'
Write-Host ''

try {
  while ($Listener.IsListening) {
    $ctx = $Listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response
    $path = $req.Url.LocalPath
    $file = Get-LocalFile $path

    if (-not $file) {
      $buf = [Text.Encoding]::UTF8.GetBytes("404 Not found: $path")
      $res.StatusCode = 404
      $res.ContentType = 'text/plain; charset=utf-8'
      $res.ContentLength64 = $buf.Length
      $res.OutputStream.Write($buf, 0, $buf.Length)
    } else {
      $ext = [IO.Path]::GetExtension($file).ToLowerInvariant()
      $bytes = [IO.File]::ReadAllBytes($file)
      $res.StatusCode = 200
      $res.ContentType = if ($Mime.ContainsKey($ext)) { $Mime[$ext] } else { 'application/octet-stream' }
      $res.ContentLength64 = $bytes.Length
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
    }
    $res.OutputStream.Close()
  }
} finally {
  $Listener.Stop()
  $Listener.Close()
}
