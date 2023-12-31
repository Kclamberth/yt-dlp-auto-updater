#!/bin/bash

counter=1
copyLocation=$(find / -name copy.sh 2>/dev/null | xargs dirname 2>/dev/null)
cd $copyLocation

if [ -s $copyLocation/channels.txt ] || [ -s $copyLocation/youtube/channels.txt ]
then
	if [ ! $(find / -type d -iname youtube 2>/dev/null | tail -1) ]   #if youtube directory DOES NOT exist, create youtube folder & subdirectories based off channels.txt
        then
	        mkdir youtube
            if [ -s $copyLocation/channels.txt ]; then
                mv $copyLocation/channels.txt $copyLocation/youtube/channels.txt
            fi

	        e0=$(find / -name channels.txt 2>/dev/null | xargs dirname 2>/dev/null) #find channel.txt
	        cd $e0

	        echo "No youtube directory found or no channel folders found in $e0"
            echo "Creating youtube subdirectories based off of youtube links in the channels.txt file..."

            if [ -s $e0/channels.txt ]
	        then
	            e5=$(cat channels.txt | sort | wc -l)
	        else
		        echo "channels.txt is empty, please add links to it to continue." | exit
	        fi

	    sleep 3

        for ((link = 1; link <= "$e5"; link ++))
        do
            e6=$(cat channels.txt | sort | awk -F "@" '{print $2}' | sed -n "$link"p)
            mkdir -p "$e0/$e6"
            echo "$e0/$e6 has been created"
        done

	echo " "
        echo "Beginning download of youtube channels into respective directories..."
	sleep 5

        #call main script again
        cd $copyLocation
        ./copy.sh

	fi

	if [ -d youtube ] # if youtube directory does exist, continue
	then
        if [ -s $copyLocation/channels.txt ]; then
        mv $copyLocation/channels.txt $copyLocation/youtube/channels.txt
        fi

	    e0=$(find / -name channels.txt 2>/dev/null | xargs dirname 2>/dev/null) #find channel.txt
	    e8=$(cat $e0/channels.txt | wc -l)
	    e9=$(ls -d $e0/* | grep -v .txt | wc -l)
	    if [ $e8 -gt $e9 ]
	    then
            echo "More channel links found than youtube subdirectories exist."
            echo "Creating youtube subdirectories based off of youtube links in the channels.txt file..."
            echo " "
		    sleep 2
		    e5=$(cat $e0/channels.txt | sort | wc -l)

		    for ((link = 1; link <= "$e5"; link ++))
            do
                e6=$(cat $e0/channels.txt | sort | awk -F "@" '{print $2}' | sed -n "$link"p)
                if [ -d $e0/$e6 ]
		        then
			        sleep 1
		        else
		            mkdir -p "$e0/$e6"
                    echo "$e0/$e6 has been created"
		        fi
            done
     
	    echo " "
	fi


    #download channel contents into each subdirectory of youtube
    for dir in $e0/*
    do
        if [ -d $dir ]
            then
                cd $dir #cd into specific channel folder
                e1=$(ls -l | wc -l) #counts number of items in directory BEFORE yt-dlp runs

                #downloads everything on a youtube channel that is NOT already in the archive.txt
                yt-dlp $(cat $e0/channels.txt | sort | sed -n "$counter"p) --download-archive archive.txt

                e2=$(ls -l | wc -l) #counts number of items in directory AFTER yt-dlp runs

                #grabs the first video in the folder and stores it's name in a variable
                e3=$(ls -lt | grep --invert-match ".txt" | sed -n 2p | awk -F " " '{ for (i=9; i<=NF; i++) print $i }' | paste -s -d " ")

                cd $e0 #return to copy.sh directory

                counter=$(expr $counter + 1)

        fi

        if [ $e2 -gt $e1 ] #if items in directory grew after yt-dlp runs
        then
            echo $e3 downloaded on $(date) in $dir >> $e0/lastupdated.txt
        else
            echo "No new videos as of $(date) in $dir" >> $e0/lastupdated.txt
        fi

    done

	    e4=$(cat $e0/channels.txt | wc -l) #number of items in dir (not counting total line)
	    echo " "
        if [ -f $e0/lastupdated.txt ]; then
            sed -i '/channels.txt/d' lastupdated.txt
            sed -i '/^$/d' lastupdated.txt 
	        cat $e0/lastupdated.txt | tail -$e4 #prints out what changed for each item in channels.txt
        fi

	fi
else
	echo "Channels.txt is empty or does not exist."
	echo "Creating channels.txt..."
	echo " "
	sleep 2
	if [ -f channels.txt ]
	then
	    echo "channels.txt already exists but is empty."
	else
	    touch channels.txt
	fi
	e0=$(find / -name channels.txt 2>/dev/null | xargs dirname 2>/dev/null) #find channel.txt
	cd $e0
	echo "Ensure you populate channels.txt with links to youtube channels."
fi
