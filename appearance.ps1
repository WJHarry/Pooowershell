Set-PSReadLineOption -Colors @{
    Command             = "#e5c07b"
    Number              = "#cdd4d4"
    Member              = "#e06c75"
    Operator            = "#e06c75"
    Type                = "#78b6e9"
    Variable            = "#78b6e9"
    Parameter           = "#e06c75"  #命令行参数颜色
    ContinuationPrompt  = "#e06c75"
    Default             = "#cdd4d4"
    Emphasis            = "#e06c75"
    #Error
    Selection           = "#cdd4d4"
    Comment             = "#cdd4d4"
    Keyword             = "#e06c75"
    String              = "#78b6e9"
}

$colorList = 'red', 'yello', 'green', 'blue'

function prompt
{
    Write-Host "-" -NoNewLine
    $pathList = $pwd.path.split("\")
    for($i=0; $i -lt $pathList.Length; $i++) {
        if($i -eq $pathList.Length - 1) {
            $str = $pathList[-1]
        } else {
            $str = $pathList[$i].substring(0, 1).ToLower()
        }
        Write-Host "$str/" -ForegroundColor $colorList[$i % $colorList.Length] -NoNewLine
    }

    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            $branch = git rev-parse --short HEAD
            $Host.UI.RawUI.WindowTitle = "PowerShell <git:$branch>"
        } elseif ($branch) {
            $Host.UI.RawUI.WindowTitle = "PowerShell <git:$branch>"
        } else {
            $Host.UI.RawUI.WindowTitle = "PowerShell"
        }
    } catch {
        $Host.UI.RawUI.WindowTitle = "PowerShell"
    }
    "→ "
}
