The ultimate update is here, still using the most reliable hard coded keys recognization!
	to let you assign any icon for any keys,
		to made as an OSD-compainion to the reWASD, (with same manually-setup way)
			TO! CONQUER! ALL! REMAP-LESS GAMES! 🏁
			TO! SHOWING! YOUR! UNBEATABLE OPERATIONS! ⌖


--------------------

This script is for load into the AutoHotKey 2.0, plug and play, but you need to fill your own values, such as your fonts, color, space size, etc. 
These footages are brief showcases for the effect it can achive: https://youtu.be/dBXBrbwaHFA (old)  https://youtu.be/1mEdudBOjM4 (updated)

The script support the primary keys on keyboard and the 5-key mouse. When you holding the key, the background is filled.
This script can display the key hits in ALL window (even the small prompt window), I use the same concept of the "Nvidia Frameview" to render the transparent background instead to be forced to make the overlay's own solid background.

Customization supports:
	- fontfaces;
	- colors;
	- the alignment and offsets;
	- separated time windows;
	- non-letter key icon replacement;
	- character set;
	- assign any Unicode Tablet character;
	- combo capability;
	- breaker threshold;
	- (macro/combo) burst blocking with auto recovering / self-reset;
All at your flavor!

Generated and updated -- with the step by step guided Gemini, built from scratch, viewed and tested by the foxwitch.

--------------------

Version differences: 
	- Milady's Input OSD.ahk -> English, base version;
	- Milady's Input OSD - Chinese/Japanese.ahk -> Lowered the overlength threshold to a single character, pre-filled the letter names with the localized pronounciations;
	- Milady's Input OSD - Self-Reset Group -> Add the burst/combo ignore and auto-recovery code block into the base version, just like the overload-protection circuit breaker:
		= AutoHotkey64 - interval self-reset.ahk -> shut off when input interval is simply narrower than the defined interval;
		= AutoHotkey64 - time window self-reset.ahk -> to block the programmable keyboard's macro burst input;

>> 	Use the "A_MaxHotkeysPerInterval" only to prevent a Hard Break (pop-up prompt window of the AHK itself).
>> 	If you don't need the blocking (like me), just use the base version for the best performance. (Despite the computer doesn't care.)

--------------------

>> Important notice: Beacuse this script draws independent GUI boxes instead of the WHQL hard driver embedding, therefore you need to capture the whole screen in OBS instead of the "Windows Capture" method, and this will runs sweet.

>> Another notice: I suggest to run some "admin" games forcely off the admin privileges by using this bat command:
						set __COMPAT_LAYER=RunAsInvoker
						start "" "C:\Path\To\game-or-launcher.exe""
  					instead of run all the Script, AHK, and the OBS with admin privileges.

>>	* Use this line in Powershell to quick setup the startup for your AHK: New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'AHK' -Value '"{your_path_here}"' -PropertyType String
>>	* To find a character in Unicode -> https://symbl.cc/ (not sponsor)

	* Note: This introduction is not a part of any script or release, and its copyright is belongs to Fonixary, showing for explaining purpose.

15 Nov '26   © 2026 Fonixary All Rights Reserved
