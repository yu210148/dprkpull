#!/bin/bash
############################################################################
#    Copyright (C) 2009 by Kevin Lucas                                     #
#    yu210148@gmail.com                                                    #
#                                                                          #
#    This program is free software; you can redistribute it and#or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation; either version 2 of the License, or     #
#    (at your option) any later version.                                   #
#                                                                          #
#    This program is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.                          #
#                                                                          #
#    You should have received a copy of the GNU General Public License     #
#    along with this program; if not, write to the                         #
#    Free Software Foundation, Inc.,                                       #
#    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
############################################################################

# This is the main script 
# calls to kdialog are indented while the 
# nuts and bolts of what's being done are not
# please keep it that way as I find it makes 
# debugging easier --KL Jan. 2010

#There are two lines commented out below by default 
#when uncommented one will show the kcna images for the day
#with the page routed through google translate in firefox.
#The other will pipe the text output directly into the
#festival text to speach reader.  

# November 2009 Updateing to use dbus instead of dcop for kdialog to work with kde4

# April 2013 Going to make this run as a system level program rather
# than from the user's home directory.  I'm doing this so that I can 
# make an installable package out of it.

#	dbusRef=`kdialog --title "DPRK Pull" --progressbar "DPRK Pull Changing Directory" 7` 
#	qdbus $dbusRef Set "" "value" 1
#	qdbus $dbusRef setLabelText "<b><big>DPRK Pull</big></b><BR><i>Changing Directory</i>" 

#cd ~/kcna
mkdir /tmp/kcna


#ON JUNE 12TH 2009 THE E-NEWS FILE WAS SAVED AS e-news.html rather than
#e-news.htm.  I'm not sure that this is a permenent change or not 
#I've changed the code here to reflect the .html but I may have to
#change it back if this new file name is not kept by the people at kcna
#	qdbus $dbusRef Set "" "value" 2
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Getting http://www.kcna.co.jp/e-news.html</i>		"

wget -O /tmp/kcna/e-news.html http://www.kcna.co.jp/e-news.html

#	qdbus $dbusRef Set "" "value" 3
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Dropping Spanish</i>		"

/usr/bin/drop_spanish.php > /tmp/kcna/2e-news.html
rm -rf /tmp/kcna/e-news.html
mv /tmp/kcna/2e-news.html /tmp/kcna/e-news.html

#	qdbus $dbusRef Set "" "value" 4
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Looking for links in e-news.html</i>		" 

cat /tmp/kcna/e-news.html | grep href > /tmp/kcna/links.txt

#	qdbus $dbusRef Set "" "value" 5
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Editing with sed and awk...</i>		" 

sed -f /usr/lib/edit.sed /tmp/kcna/links.txt > /tmp/kcna/2links.txt
awk -f /usr/lib/edit.awk /tmp/kcna/2links.txt > /tmp/kcna/3links.txt
sed -f /usr/lib/addDomain.sed /tmp/kcna/3links.txt > /tmp/kcna/4links.txt
sed -f /usr/lib/rm_p_tags.sed /tmp/kcna/4links.txt > /tmp/kcna/5links.txt
rm -rf /tmp/kcna/4links.txt
mv /tmp/kcna/5links.txt /tmp/kcna/4links.txt

#	qdbus $dbusRef Set "" "value" 6
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Parsing Links and getting stores...</i>		" 

/usr/bin/kcna-parse-links.php


#	qdbus $dbusRef Set "" "value" 7	
#	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Final editing in progress...</i>		" 

#Language Check has to happen here before all the articles
#Get smashed into the one newsfile.txt

cat /tmp/kcna/2*.html > /tmp/kcna/newsfile.txt
sed -f /usr/lib/editNewsfile.sed /tmp/kcna/newsfile.txt > /tmp/kcna/2newsfile.txt
dos2unix /tmp/kcna/2newsfile.txt
sed -f /usr/lib/killblanklines.sed /tmp/kcna/2newsfile.txt > /tmp/kcna/3newsfile.txt

#Change the name of 3newsfile.txt to KCNA_News.txt
mv /tmp/kcna/3newsfile.txt /tmp/kcna/KCNA_News.txt

#	qdbus $dbusRef close

# Comment out the line below to stop it pulling up a google translated (to english) version of the KNS/KCNA images page 
#firefox "http://translate.google.com/translate?js=n&prev=_t&hl=en&ie=UTF-8&u=http%3A%2F%2Fkns-photo.com%2Findex.php&sl=auto&tl=en&history_state0=" &

# Comment out the line below to stop festival tts reading the news aloud
#festival --tts ~/kcna/KCNA_News.txt &

#kwrite KCNA_News.txt

# The idea here eventually is to create a file with the audio 
# So it can be put into an RSS feed and downloaded to mobile
# devices as a podcast.
text2wave /tmp/kcna/KCNA_News.txt -o /tmp/kcna/KCNA_News.wav

# Ubuntu is now using avconv rather than ffmpeg (as of 12.04)
# comment out the avconv line and uncomment the ffmpeg line
# if you're using ffmpeg 
#ffmpeg -i ~/kcna/KCNA_News.wav -acodec libvorbis ~/kcna/KCNA_News.ogg
#ffmpeg -i ~/kcna/KCNA_News.wav ~/kcna/KCNA_News.mp3

# Uncomment for Ubuntu
avconv -acodec pcm_s16le -i /tmp/kcna/KCNA_News.wav -acodec libvorbis -b 64k /tmp/kcna/KCNA_News.ogg

# I don't remember where this one was used could be gentoo.
#avconv -i KCNA_News.wav KCNA_News.ogg

# Add the ID3 tag for artist & album so that it get's put in the right
# spot when google music picks it up
#id3v2 -a KCNA -A "TTS News" KCNA_News.ogg
# or for ogg files
vorbiscomment -a -t "ALBUM=TTS News" /tmp/kcna/KCNA_News.ogg

#Get date
MODDATE=$(stat -c %y /tmp/kcna/KCNA_News.ogg)
MODDATE=${MODDATE%% *}
#echo $MODDATE

# Add the date to the id3 tag of the mp3 as the Title
id3v2 -t $MODDATE /tmp/kcna/KCNA_News.ogg

#and append to ogg filename
mv /tmp/kcna/KCNA_News.ogg /tmp/kcna/KCNA_News-$MODDATE.ogg

# put code here to move the ogg to the rss feed
#mv ~/kcna/*.ogg ~/music/kcna/


#kdialog --passivepopup '<b><big>DPRK Pull</big></b><br><i>Cleaning up</i>' 2 &
rm -rf /tmp/kcna/*.html
rm -rf /tmp/kcna/*.txt
rm -rf /tmp/kcna/*.htm
rm -rf /tmp/kcna/*.html.1
rm -rf /tmp/kcna/*.html.2
rm -rf /tmp/kcna/*.html.3
rm -rf /tmp/kcna/*.wav

#Play the .ogg file
#mplayer /tmp/kcna/KCNA_News-$MODDATE.ogg

#move the .ogg file to the web server directory
mv /tmp/kcna/KCNA_News-$MODDATE.ogg /var/www/dprkpull/

#Remove when done
rm -rf /tmp/kcna
