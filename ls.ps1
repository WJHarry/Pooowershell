# 配色表
$colorMap = @{
    "Directory" = "Blue";
    "Executable" = "Red";
    "Text" = "Yellow";
    "Compressed" = "Darkgreen"
}

# ls中每行展示个数
$script:sizeEachLine = 8

$script:index = 0

# ls对不同类型彩色展示
function color-ls
{
    $echoWhole = $false
    $hidden = $false
    for ($i = 0; $i -lt $args.count; $i++) {
        if ($args[$i] -eq "-l") {
            # 显示所有信息
            $echoWhole = $true
        } elseif ($args[$i] -eq "-a") {
            # 显示隐藏文件（不是指windows的隐藏文件，而是unix风格的“.”开头的文件）
            $hidden = $true
        } else {
            Write-Host "Wrong param:$($args[$i])"
            exit
        }
    }
    $regexOpts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
          -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $fore = $Host.UI.RawUI.ForegroundColor

    # 列举各种类型文件的后缀
    $compressed = New-Object System.Text.RegularExpressions.Regex(
          '\.(zip|tar|gz|rar|jar|war)$', $regexOpts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
          '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regexOpts)
    $textFiles = New-Object System.Text.RegularExpressions.Regex(
          '\.(txt|cfg|conf|ini|csv|log|xml|java|c|cpp|nut|sql|html|css|rs|cs|php)$', $regexOpts)

    $script:index = 0
    Invoke-Expression ("Get-ChildItem") | ForEach-Object {
        if ($_.GetType().Name -eq 'DirectoryInfo') {
            $Host.UI.RawUI.ForegroundColor = $colorMap["Directory"]
            echo-item -itemObject $_ -whole $echoWhole -hidden $hidden
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($compressed.IsMatch($_.Name)) {
            $Host.UI.RawUI.ForegroundColor = $colorMap["Compressed"]
            echo-item -itemObject $_ -whole $echoWhole -hidden $hidden
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($executable.IsMatch($_.Name)) {
            $Host.UI.RawUI.ForegroundColor = $colorMap["Executable"]
            echo-item -itemObject $_ -whole $echoWhole -hidden $hidden
            $Host.UI.RawUI.ForegroundColor = $fore
        } elseif ($textFiles.IsMatch($_.Name)) {
            $Host.UI.RawUI.ForegroundColor = $colorMap["Text"]
            echo-item -itemObject $_ -whole $echoWhole -hidden $hidden
            $Host.UI.RawUI.ForegroundColor = $fore
        } else {
            echo-item -itemObject $_ -whole $echoWhole -hidden $hidden
        }
    }
}

function echo-item
{
    Param(
        $itemObject,
        $whole,
        $hidden
    )

    # 是否展示隐藏文件
    $name = ($itemObject).Name
    if (!$hidden -and ($name[0] -eq ".")) {
        return
    }
    $script:index++

    if ($whole) {
        echo $itemObject
    } else {
        if ($script:index % $script:sizeEachLine -eq 0) {
            $name = $name + "`n"
        } else {
            $name = $name + "`t"
        }
        Write-Host $name -NoNewLine
    }
}
