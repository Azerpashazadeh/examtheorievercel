# remove-auth-guard.ps1
# Bu betik, tüm .html dosyalarını tarar ve 'auth-guard.js' referansını içeren satırları siler.

Write-Host "🚀 Auth-Guard temizleme betiği başlatıldı..."

# Geçerli dizindeki (ve alt dizinlerdeki) tüm .html dosyalarını al
$htmlFiles = Get-ChildItem -Path . -Filter *.html -Recurse -File

$totalFiles = $htmlFiles.Count
$processedFiles = 0
$modifiedFiles = 0

foreach ($file in $htmlFiles) {
    $processedFiles++
    Write-Progress -Activity "Dosyalar taranıyor" -Status "$processedFiles / $totalFiles" -PercentComplete (($processedFiles / $totalFiles) * 100)

    # Dosyayı oku
    $content = Get-Content -Path $file.FullName -Raw

    # Eğer dosya 'auth-guard.js' içeriyorsa, ilgili satırı sil
    # Bu regex, <script> etiketini ve içindeki src'si auth-guard.js olan tüm satırı yakalar.
    if ($content -match '<script[^>]*src=["'']?[^>"'']*auth-guard\.js[^>]*>.*?</script>') {
        Write-Host "🔄 İşleniyor: $($file.FullName)"
        # Eşleşen bloğu boşluk ile değiştir (sil)
        $newContent = $content -replace '<script[^>]*src=["'']?[^>"'']*auth-guard\.js[^>]*>.*?</script>', ''
        
        # Eğer değişiklik olduysa dosyayı kaydet
        if ($content -ne $newContent) {
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
            $modifiedFiles++
            Write-Host "✅ Silindi: $($file.Name)"
        }
    }
}

Write-Host "`n✨ Temizlik tamamlandı! $modifiedFiles dosya güncellendi."