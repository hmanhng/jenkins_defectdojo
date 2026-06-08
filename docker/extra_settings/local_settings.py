from dojo.announcement import os_message


# Disable the remote OSS promo banner in the UI.
os_message.fetch_os_message = lambda: None
