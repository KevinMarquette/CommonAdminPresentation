#test streams
[cmdletbinding()] param()
Write-Host 'Write-Host'
Write-Output 'Write-Output'
Write-Verbose 'Write-Verbose'
Write-Warning 'Write-Warning'
Write-Error 'Write-Error'
Write-Debug 'Write-Debug'
Write-Information 'Write-Information' # New in PS 5.0
Throw 'Throw'
