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

# Check for php
if [ ! -f /usr/bin/php ]
    then echo "Unable to find php please install php."
# Check for sed
elif [ ! -f /usr/bin/sed ]
    then echo "Unable to find sed please install sed."
# Check for awk
elif [ ! -f /usr/bin/awk ]
    then echo "Unable to find awk please install awk."
# Check for kdialog
elif [ ! -f /usr/bin/kdialog ]
    then echo "Unable to find kdialog please install kdialog."
else

# Installer script for dprk_pull
echo "Removing Old Version (if it exists)..."
rm -rf ~/kcna
echo "Creating ~/kcna directory"
mkdir ~/kcna


echo "Copying files..."
cp --recursive ./* ~/kcna
cd ~/kcna
echo "Install completed.  Type ~/kcna/dprk_pull.sh to run."

fi
