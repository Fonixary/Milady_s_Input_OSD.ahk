>> Important notice: Beacuse this script draws independent GUI boxes instead of the WHQL hard driver embedding, therefore you need to capture the whole screen in OBS instead of the "Windows Capture" method, and this will runs sweet.
>> Another notice: I suggest to run some "admin" games forcely off the admin privileges by using this bat command:
						set __COMPAT_LAYER=RunAsInvoker
						start "" "C:\Path\To\game-or-launcher.exe""
  					instead of run all the Script, AHK, and the OBS with admin privileges.


This script is for load into the AutoHotKey 2.0, plug and play, but you need to fill your own values, such as your fonts, color, space size, etc. 
This footage is a brief showcase for the effect it can achive: https://youtu.be/dBXBrbwaHFA

The script support the primary keys on keyboard and the 5-key mouse. When you holding the key, the background is filled.
This script can display the key hits in ALL window (even the small prompt window), I use the same concept of the "Nvidia Frameview" to render the transparent background instead to be forced to make the overlay's own solid background.

Customization supports:
	- fontfaces;
	- colors;
	- the alignment and offsets;
	- timeout and fading time length;
	- non-letter key icon replacement;
	- character set;
All at your flavor!

Generated step by step on guided Gemini, built from zero, viewed and tested by foxwitch.

	* Use this line in Powershell to quick setup the startup for your AHK: New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'AHK' -Value '"{your_path_here}"' -PropertyType String
