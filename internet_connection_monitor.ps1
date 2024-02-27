Add-Type -AssemblyName System.Windows.Forms

Write-Host "Starting"

# Define the script block
$scriptBlock = {
    [System.Windows.Forms.MessageBox]::Show("Check internet", "Internet Connection Alert", "OK", [System.Windows.Forms.MessageBoxIcon]::Warning)
}

while ($true) {
    # Test for an active internet connection
    Write-Host "Testing for connection"
    if ((Test-Connection -ComputerName "www.google.com" -Count 1 -Quiet)) {
        Write-Host "Connection ok"
    }
    else {
        # If no connection, raise a MessageBox alert saying "check internet"
        Write-Host "No connection, raising popup"

        # Create a delegate of type System.Threading.ParameterizedThreadStart
        $threadStart = [System.Threading.ParameterizedThreadStart]::new($scriptBlock)

        # Instantiate the thread object
        $thread = [System.Threading.Thread]::new($threadStart)

        # Start the thread
        $thread.Start($null)

        # Wait for the message box to display
        Start-Sleep -Seconds 1
        Write-Host "Waiting for close"
        # Wait for 10 seconds or until the message box is closed, whichever comes first
        $timeout = 10
        while ($timeout -gt 0 -and $thread.IsAlive) {
            Start-Sleep -Seconds 1
            $timeout--
        }
        Write-Host "Closing popup"
        # Close the thread if it's still running
        if ($thread.IsAlive) {
            $thread.Abort()
        }
    }

    # Wait for 1 minute
    Write-Host "Waiting before next check"
    Start-Sleep -Seconds 60
}
