Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path .\baseline.txt

    if ($baselineExists) {
        Remove-Item -Path .\baseline.txt
    }
}

Function Send-EmailNotification {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$subject,
        [Parameter(Mandatory=$true)]
        [string]$body
    )
    
    $smtpServer = "xxxxxxx"  # Replace with your SMTP server address
    $smtpPort = 587  # Replace with your SMTP server port number
    $username = "xxxxxxx"  # Replace with your SMTP server username
    $password = "xxxxxxx"  # Replace with your SMTP server password
    $fromAddress = "xxxxxxx@example.com"  # Replace with your sender email address
    $toAddress = "xxxxxxx@example.com"  # Replace with your recipient email address
    
    $smtpParams = @{
        SmtpServer = $smtpServer
        Port = $smtpPort
        UseSsl = $true
        Credential = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (ConvertTo-SecureString -String $password -AsPlainText -Force))
        From = $fromAddress
        To = $toAddress
        Subject = $subject
        Body = $body
    }
    
    $success = Send-MailMessage @smtpParams
    
    if ($success) {
        Write-Host "Email sent successfully."
    } else {
        Write-Host "Email sending failed."
    }
}

Function Collect-New-Baseline() {
    Erase-Baseline-If-Already-Exists

    $files = Get-ChildItem -Path .\test_files

    foreach ($file in $files) {
        $hash = Calculate-File-Hash $file.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }
}

Function Monitor-Files {
    $fileHashDictionary = @{}
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    
    foreach ($f in $filePathsAndHashes) {
        $filePath = $f.Split("|")[0]
        $fileHash = $f.Split("|")[1]
        $fileHashDictionary[$filePath] = $fileHash
    }

    while ($true) {
        Start-Sleep -Seconds 1
        
        $files = Get-ChildItem -Path .\test_files

        foreach ($file in $files) {
            $filePath = $file.FullName
            $currentHash = (Calculate-File-Hash $filePath).Hash

            if ($fileHashDictionary.ContainsKey($filePath)) {
                $baselineHash = $fileHashDictionary[$filePath]

                if ($baselineHash -eq $currentHash) {
                    # The file remains unchanged
                }
                else {
                    $subject = "File Modified: $filePath"
                    $body = "The file $filePath has been modified."
                    Send-EmailNotification -subject $subject -body $body
                }
            }
            else {
                $subject = "File Created: $filePath"
                $body = "The file $filePath has been created."
                Send-EmailNotification -subject $subject -body $body
            }
        }

        $deletedFiles = Compare-Object -ReferenceObject $fileHashDictionary.Keys -DifferenceObject $files.FullName -PassThru | Where-Object { $_.SideIndicator -eq "<=" }
        foreach ($deletedFile in $deletedFiles) {
            $subject = "File Deleted: $deletedFile"
            $body = "The file $deletedFile has been deleted."
            Send-EmailNotification -subject $subject -body $body
        }
    }
}

Function Generate-Detailed-Reports() {
    $reportPath = ".\detailed_report.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Append the report to the file
    Add-Content -Path $reportPath -Value "`r`n`r`nDetailed Report - $timestamp`r`n"

    $files = Get-ChildItem -Path .\test_files

    foreach ($file in $files) {
        $hash = Calculate-File-Hash $file.FullName
        $status = Get-File-Status $hash.Path

        $reportLine = "File Path: $($hash.Path)`r`nStatus: $status`r`nHash Value: $($hash.Hash)`r`n`r`n"

        # Append the report line to the file
        Add-Content -Path $reportPath -Value $reportLine
    }

    Write-Host "Detailed report generated. Path: $reportPath"
}

Function Get-File-Status($filePath) {
    $baselineExists = Test-Path -Path .\baseline.txt

    if ($baselineExists) {
        $baselineFileStillExists = Test-Path -Path $filePath

        if ($baselineFileStillExists) {
            $baselineHash = Get-Content -Path .\baseline.txt | Where-Object { $_ -like "$filePath*" } | ForEach-Object { $_.Split("|")[1] }
            $currentHash = (Calculate-File-Hash $filePath).Hash

            if ($baselineHash -eq $currentHash) {
                return "Unchanged"
            } else {
                return "Changed"
            }
        } else {
            return "Deleted"
        }
    } else {
        return "Baseline not found"
    }
}

Write-Host ""
Write-Host "Choose your action?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host "    C) Generate detailed reports?"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' , 'B' or 'C'"
Write-Host ""

if ($response -eq "A".ToUpper()) {
    Collect-New-Baseline
}
elseif ($response -eq "B".ToUpper()) {
    Monitor-Files
}
elseif ($response -eq "C".ToUpper()){
    Generate-Detailed-Reports
}
else{
    Write-Host "Invalid input. Please select a valid option."
}