New-Item -ItemType Directory -Force -Path assets\branding | Out-Null

Add-Type -AssemblyName System.Drawing

$bitmap = New-Object System.Drawing.Bitmap 1200, 1200
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$fullRect = New-Object System.Drawing.Rectangle 0, 0, 1200, 1200
$backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $fullRect,
    [System.Drawing.ColorTranslator]::FromHtml('#090D16'),
    [System.Drawing.ColorTranslator]::FromHtml('#111827'),
    45
)
$graphics.FillRectangle($backgroundBrush, $fullRect)

$glowPrimary = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34, 99, 102, 241))
$glowSecondary = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(28, 13, 148, 136))
$graphics.FillEllipse($glowPrimary, -120, 120, 620, 620)
$graphics.FillEllipse($glowSecondary, 700, 720, 420, 420)

$cardX = 360
$cardY = 300
$cardWidth = 480
$cardHeight = 480
$cornerRadius = 96

$cardPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$cardPath.AddArc($cardX, $cardY, $cornerRadius, $cornerRadius, 180, 90)
$cardPath.AddArc($cardX + $cardWidth - $cornerRadius, $cardY, $cornerRadius, $cornerRadius, 270, 90)
$cardPath.AddArc($cardX + $cardWidth - $cornerRadius, $cardY + $cardHeight - $cornerRadius, $cornerRadius, $cornerRadius, 0, 90)
$cardPath.AddArc($cardX, $cardY + $cardHeight - $cornerRadius, $cornerRadius, $cornerRadius, 90, 90)
$cardPath.CloseFigure()

$cardGradient = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Rectangle $cardX, $cardY, $cardWidth, $cardHeight),
    [System.Drawing.ColorTranslator]::FromHtml('#6366F1'),
    [System.Drawing.ColorTranslator]::FromHtml('#0D9488'),
    55
)
$graphics.FillPath($cardGradient, $cardPath)

$outlinePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 255, 255, 255), 4)
$graphics.DrawPath($outlinePen, $cardPath)

$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(236, 249, 250, 251))
$linePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(245, 249, 250, 251), 18)
$linePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$linePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

$graphics.FillRectangle($whiteBrush, 470, 575, 52, 110)
$graphics.FillRectangle($whiteBrush, 550, 505, 52, 180)
$graphics.FillRectangle($whiteBrush, 630, 445, 52, 240)

$points = @(
    (New-Object System.Drawing.Point 460, 610),
    (New-Object System.Drawing.Point 570, 530),
    (New-Object System.Drawing.Point 660, 480),
    (New-Object System.Drawing.Point 735, 410)
)
$graphics.DrawLines($linePen, $points)
$graphics.FillEllipse($whiteBrush, 716, 392, 34, 34)

$titleFont = New-Object System.Drawing.Font('Segoe UI', 64, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$subtitleFont = New-Object System.Drawing.Font('Segoe UI', 26, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$subtitleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#9CA3AF'))
$stringFormat = New-Object System.Drawing.StringFormat
$stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
$stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

$graphics.DrawString('InvestTrack', $titleFont, $whiteBrush, (New-Object System.Drawing.RectangleF 180, 850, 840, 86), $stringFormat)
$graphics.DrawString('Private portfolio intelligence', $subtitleFont, $subtitleBrush, (New-Object System.Drawing.RectangleF 180, 940, 840, 40), $stringFormat)

$bitmap.Save('assets\branding\splash_investtrack.png', [System.Drawing.Imaging.ImageFormat]::Png)

$backgroundBrush.Dispose()
$glowPrimary.Dispose()
$glowSecondary.Dispose()
$cardPath.Dispose()
$cardGradient.Dispose()
$outlinePen.Dispose()
$whiteBrush.Dispose()
$linePen.Dispose()
$titleFont.Dispose()
$subtitleFont.Dispose()
$subtitleBrush.Dispose()
$stringFormat.Dispose()
$graphics.Dispose()
$bitmap.Dispose()
