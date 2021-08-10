. "$PSScriptRoot\ls.ps1"
. "$PSScriptRoot\appearance.ps1"

Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -EditMode Emacs

Set-Alias ls color-ls
Set-Alias show explorer.exe

function ll {
    color-ls -l
}

function la {
    color-ls -a
}
