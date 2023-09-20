# yt-dlp-auto-updater
This is a simple script for use in cron jobs and to automate the task of downloading youtube videos via yt-dlp. 

**NOTE:**
To use this script you need to download copy.sh and put it wherever you want.
For use in jellyfin, I have the script in the parent directory of shows.
(EX: /data/jellyfin/shows contains the shows I watch, so the script is located in /data/jellyfin)

**The first time you run this script, you need to run it from the directory you intend the youtube directory to be (EX. I ran it from /data/jellyfin the first time), this is because all the subdirectories will be created in that directory!**

The first time you run this script, it will create a channels.txt file for you in the same directory as itself (for me that is in /data/jellyfin).
You simply add youtube channel links to this file in the **"https://www.youtube.com/@exampleone"** format. The simplified format with @ is important.

Once you add channel links to the channel.txt file, the next time you run the script it will automatically create a youtube directory in the 
jellyfin directory, and then it will create subdirectories based off the channel link names. 
(EX: https://www.youtube.com/@exampleone creates a subdirectory called /data/jellyfin/youtube/exampleone in the /data/jellyfin/youtube directory.)

yt-dlp will then download all the videos that the link contains, and add them to the their specific subdirectories.

A lastupdated.txt file will be created in the copy.sh directory that you can read to view when the last time a video was downloaded from that channel.

If you add more links to the channels.txt at a later date, more subdirectories will automatically be created for you based off of the channel names,
so you simply need to run the script again or just let it run again via a cronjob (my preferred method).

**To delete any channels:** simply remove the link from the channels.txt file, and delete the directory of the channel in "/data/jellyfin/youtube".

**NOTE:**
---------------------------------------------------------------------------------------------------------------------------------
If you wish to add more options to your yt-dlp download such as descriptions, metadata, etc then you need to modify this line!

**yt-dlp $(cat $e0/channels.txt | sort | sed -n "$counter"p) --download-archive archive.txt** in **line 74** of the script.


