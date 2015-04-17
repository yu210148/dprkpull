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
	dbusRef=`kdialog --title "DPRK Pull" --progressbar "DPRK Pull Changing Directory" 6` 
	qdbus $dbusRef Set "" "value" 1
	qdbus $dbusRef setLabelText "<b><big>DPRK Pull</big></b><BR><i>Changing Directory</i>" 

cd ~/kcna

#ON JUNE 12TH 2009 THE E-NEWS FILE WAS SAVED AS e-news.html rather than
#e-news.htm.  I'm not sure that this is a permenent change or not 
#I've changed the code here to reflect the .html but I may have to
#change it back if this new file name is not kept by the people at kcna
	qdbus $dbusRef Set "" "value" 2
	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Getting http://www.kcna.co.jp/e-news.html</i>		"

wget http://www.kcna.co.jp/e-news.html

	qdbus $dbusRef Set "" "value" 3
	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Looking for links in e-news.html</i>		" 

cat e-news.html | grep href > links.txt

	qdbus $dbusRef Set "" "value" 4
	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Editing with sed and awk...</i>		" 

sed -f edit.sed links.txt > 2links.txt
awk -f edit.awk 2links.txt > 3links.txt
sed -f addDomain.sed 3links.txt > 4links.txt
sed -f rm_p_tags.sed 4links.txt > 5links.txt
rm -rf 4links.txt
mv 5links.txt 4links.txt

	qdbus $dbusRef Set "" "value" 5
	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Parsing Links and getting stores...</i>		" 

~/kcna/kcna-parse-links.php


	qdbus $dbusRef Set "" "value" 6	
	qdbus $dbusRef setLabelText "		<b><big>DPRK Pull</big></b><br><i>Final editing in progress...</i>		" 

cat *.html > newsfile.txt
sed -f editNewsfile.sed newsfile.txt > 2newsfile.txt
dos2unix 2newsfile.txt
sed -f killblanklines.sed 2newsfile.txt > 3newsfile.txt

#Change the name of 3newsfile.txt to KCNA_News.txt
mv 3newsfile.txt KCNA_News.txt

	qdbus $dbusRef close

# Uncomment the line below to have the script pull up a google translated (to english) version of the KNS/KCNA images page 
#firefox "http://translate.google.com/translate?js=n&prev=_t&hl=en&ie=UTF-8&u=http%3A%2F%2Fkns-photo.com%2Findex.php&sl=auto&tl=en&history_state0=" &

# Uncomment the line below to have festival read the news aloud
# festival --tts ~/KCNA_News.txt &

kwrite KCNA_News.txt

kdialog --passivepopup '<b><big>DPRK Pull</big></b><br><i>Cleaning up</i>' 2 &
rm -rf ~/kcna/*.html
rm -rf ~/kcna/*.txt
rm -rf ~/kcna/*.htm
