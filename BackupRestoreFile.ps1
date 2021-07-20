$originalFilePath = ''
$backupFolder = ''

# Extract the components of the original file.
$originalFileName = Get-Item $originalFilePath | Select-Object -ExpandProperty BaseName
$originalFileExt =  Get-Item $originalFilePath | Select-Object -ExpandProperty Extension

# Get what to do.
$choice = $host.UI.PromptForChoice("Backup & Restore", "What action do you want to perform?
'$originalFilePath' to '$backupFolder'", ("Backup","Restore","Do Nothing"), 2)

Switch ($choice) {
    # Backup.
    0 {
        $newFileName = "$originalFileName $(Get-Date -Format "yyyyMMddHHmmss")$originalFileExt"
        $newFilePath = "$backupFolder\$newFileName"
        Write-Host "Backing up: 
   '$originalFilePath'
=> '$newFilePath'"
        Copy-Item $originalFilePath $newFilePath
    }
    # Restore.
    1 {
        $mostRecentBackup = Get-ChildItem "$backupFolder\$originalFileName *$originalFileExt" | Sort-Object Name -Descending | Select-Object -First 1 -ExpandProperty FullName

        Write-Host "Restoring: 
   '$mostRecentBackup'
=> '$originalFilePath'"

        Copy-Item $mostRecentBackup $originalFilePath
    }
    # Do nothing.
    2 {
        Write-Host 'Doing nothing! Exiting...'
    }
}
