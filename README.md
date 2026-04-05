# Duplicate-File-Search
A simple Powershell script that allows you to specify a scan mode and drive (or directory), and it then produces a list of all duplicate files in .txt and .csv formats.  It does not delete or move any files.

## My First Published Script
Hi everyone, this is my first published script - so please go easy on me if it is a bit of a mess.  Yes the code is a little sloppy, but it does what I wanted it to.  Please bear in mind that I only started playing with Powershell a few days ago, and I'm not a "coder" or "programmer".  I hope it proves useful, be that in using it as-is, or by modifying it to improve it.  I may develop this further at a later time, but as of right now I don't have the time to work on it (so feel free to make suggestions, but please note that it may take a while for me to look into them).

## Disclaimer
This script is just a reader / scanner, and as such the information it provides should only be used to help guide you to where duplicate files may be.  It does not move or delete any files.  Therefore as this script is only a guide, I accept no responsibilities for the repercussions of any files you decide to delete or move. 

## How it works
The script starts by scanning your system for drives, and then displaying the results.   It is designed to detect and display all filesystem drives, and should also detect USB drives too.  I didn't check functionality for network drives, as I don't have any.

Next, one of two types of scan can be selected - A simple and fast(ish) scan, or a longer but more accurate scan.

The simple scan merely checks for files with the same file size and name.  Be careful, as sometimes files may appear identical from this list, but actually be two completely different files that just so happen to have the same name and filesize.

The Detailed scan performs a hash check on all the files in the chosen directory.  This will find all files that match the same hash, so should capture duplicates of the smae file where the file names differ.  I have been advised that this still may find "false positives", hence I would advise manually checking the files rather than using a script to delete them.

*Please note:* Running the Detailed Scan has been shown to increase the drive temperature of solid state drives to the point where they thermally throttle (the scan slows down).  Please consider manually increasing the fan speed in your computer manually if you can (or for laptops, use a ventillated laptop stand).

Once each scan is complete, it will write two files to the root of the directory you scanned. One is a text file, the other a CSV file.  The CSV file contains a bit more information than the .txt file.  The CSV file was added in so that it can be loaded into a spreadsheet application to make filtering / reading the data a bit more easy.  The text file was kept to maintain maximum compatibility (a fall-back, if you will).

Running the check in the same directory multiple times will result in the previous .txt and .csv files being overwritten.

## Set-up (Windows)
I run this from a Shortcut icon on my desktop to keep things simple.

1. Download the script file to somewhere you can easily find it, and copy the file path.
2. Right-click on your desktop and select "New" > "Shortcut".
3. In "Type the location of the item", type the following
'''powershell
Powershell.exe -file "C:\your\file\path\DuplicatFileCheck.ps1"
'''
4. Give your shortcut a name, something like "Duplicate File Checker".
5. Hit "Finish", and you're ready to use it.

## Usage
Simply run the script - basic guidance is shown on the screen as you go.

Just remember to put the trailing slash in whatever path name you type out, or you may get errors (e.g. use "C:\" not "C:").

Oh, and the bigger the directory and / or the more files in the directory, the longer this will take.

If you are not sure the script is "scanning", bring up Task Manager (CTRL + SHIFT + ESC), select the "Performance" tab on the left, and then click on the drive you are scanning - you should see it running at about 50-85% usage.
