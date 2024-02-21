"""Check if internet is available, pop up Windows message if not.

To run under Windows (10/11 right now) to monitor an intermittent
internet connection.

The idea is that this could be scheduled to run every five minutes or so.
"""

import ctypes
import requests

# Want to make the message box steal focus
MB_OK = 0x00000000
MB_ICONINFORMATION = 0x00000040
MB_SETFOREGROUND = 0x00010000  # This flag makes the message box steal focus

def check_internet_connection(url="http://example.com"):
    try:
        # Attempt to access a reliable website
        response = requests.get(url)
        response.raise_for_status()  # Raises an HTTPError if the HTTP request returned an unsuccessful status code

        print("Internet is accessible.")
    except requests.RequestException:
        print("Internet is not accessible.")
        # Display a popup with only an OK button and a timeout of 60 seconds
        MessageBoxTimeout = ctypes.windll.user32.MessageBoxTimeoutW
        MessageBoxTimeout(None, "Check internet connection.", "Internet Connection Issue", 0, 0, 60000)

# Call the function to check internet connectivity
check_internet_connection()
