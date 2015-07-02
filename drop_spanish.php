#!/usr/bin/php
<?php
/*
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
*/

$command = "cat /tmp/kcna/e-news.html";
exec($command, $output);

// so each line of the file is now in the output array
// what I want to do is go though and find the line that
// has the string "Spanish-speaking People" in it then drop 
// that line and everything after that line
$stringToMatch = "Spanish-speaking People";

foreach ($output as $line){
	if (substr_count($line, $stringToMatch) >= 1){
	   // if the counted number of times that the pharase "Spanish-speaking People"
	   // is found in the line is one or more then stop right here
	   break;
	} else {
	   // otherwise continue outputting the lines
	  print "$line\n";
	} // end else
} // end foreach




