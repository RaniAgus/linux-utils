oh-my-posh init pwsh --config C:\Users\agustin.ranieri\.config\oh-my-posh\zen.toml | Invoke-Expression

if ($host.Name -eq 'ConsoleHost')
{
    function ls_git { & 'C:\Program Files\Git\usr\bin\ls' --color=auto -hF $args }
    Set-Alias -Name ls -Value ls_git -Option Private
}
