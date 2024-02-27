Add-Type -AssemblyName System.Windows.Forms

Write-Host "Starting"

while ($true) {
    # Test for an active internet connection
    Write-Host "Testing for connection"
    if ((Test-Connection -ComputerName "www.google.com" -Count 1 -Quiet)) {
        Write-Host "Connection ok"
    }
    else {
        # If no connection, raise a MessageBox alert saying "check internet"
        Write-Host "No connection, raising popup"

        # Define the script block
        $scriptBlock = {
            [System.Windows.Forms.MessageBox]::Show("Check internet", "Internet Connection Alert", "OK", [System.Windows.Forms.MessageBoxIcon]::Warning)
        }

        # Start a new PowerShell background job to run the script block
        Start-Job -ScriptBlock $scriptBlock

        # Wait for the message box to display
        Start-Sleep -Seconds 1
        Write-Host "Waiting for close"
        # Wait for 10 seconds or until the message box is closed, whichever comes first
        $timeout = 10
        while ($timeout -gt 0 -and (Get-Job -State "Running")) {
            Start-Sleep -Seconds 1
            $timeout--
        }
        Write-Host "Closing popup"
        # Close the job if it's still running
        Get-Job | Remove-Job -Force
    }

    # Wait for 1 minute
    Write-Host "Waiting before next check"
    Start-Sleep -Seconds 60
}
