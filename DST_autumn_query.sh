#!/bin/bash

#################################################################################################################################################################
# CREATED BY SAMONI NAG ON 10/13/2020
# 
# THIS SCRIPT QUERIES DATA FROM DAYBAG (OR SANDBOX) 70 DIFFERENT TIMES (FOR 5 U.S. TIMEZONES & 7 YEARS & 2 RELATIVE POSITIONS) WITH THE FOLLOWING CRITERIA:
#   [1] AIRPORT = 2 (HONOLULU)
#   [2] DAY = 1 (LEVEL 1)
#   [3] REPLAY = 0 (NO REPLAY)
#   [4] MODE = 0 (CAREER)
#   [5] DATE FALLS WITHIN CERTAIN TIME RANGES AROUND A DST PHASE DELAY (FALL BACK) FROM 2013 - 2019 
#    
# RELEVANT TIME ZONES INCLUDE: 
#   - EASTERN, CENTRAL, MOUNTAIN, PACIFIC, ALASKA 
#       - STANDARD: -5, -6, -7, -8, -9 
#       - DAYLIGHT: -4, -5, -6, -7, -8 
#   - NOT INCLUDING HAWAII (-10) BECUASE DST IS NOT OBSERVED 
# 
#################################################################################################################################################################

season="AUTUMN";

# AIRPORT SCANNER CRITERIA
airport=2;  
day=1;  
replay=0;  
mode=0; # 0=career, 1=challenge, 2=endless

# LIST OF TIME ZONES     
timeZoneLabels=("EASTERN" "CENTRAL" "MOUNTAIN" "PACIFIC" "ALASKA"); 
nTimeZones=${#timeZoneLabels[@]}; # 5  

# SET OTHER VARIABLES TO BE USED IN QUERY LOOPS    
years=(2013 2014 2015 2016 2017 2018 2019);
nYears=${#years[@]}; # 7
positions=("PRE" "POST");
nPositions=${#positions[@]}; # 2 
        
# LIST OF RELEVANT TIME STAMPS (BOUNDS OF 14-DAY WINDOW AROUND TIME CHANGE) IN DATETIME AND UTC (EASTERN TIME ZONE ONLY):  
    # Sunday October 27, 2013 @ 6:00:00AM EST through Saturday November 9, 2013 @ 11:59:59PM EST | 1382868000 - 1384059599  
    # Sunday October 26, 2014 @ 6:00:00AM EST through Saturday November 8, 2014 @ 11:59:59PM EST | 1414317600 - 1415509199  
    # Sunday October 25, 2015 @ 6:00:00AM EST through Saturday November 7, 2015 @ 11:59:59PM EST | 1445767200 - 1446958799  
    # Sunday October 30, 2016 @ 6:00:00AM EST through Saturday November 12, 2016 @ 11:59:59PM EST | 1477821600 - 1479013199  
    # Sunday October 29, 2017 @ 6:00:00AM EST through Saturday November 11, 2017 @ 11:59:59PM EST | 1509271200 - 1510462799  
    # Sunday October 28, 2018 @ 6:00:00AM EST through Saturday November 10, 2018 @ 11:59:59PM EST | 1540720800 - 1541912399  
    # Sunday October 27, 2019 @ 6:00:00AM EST through Saturday November 9, 2019 @ 11:59:59PM EST | 1572170400 - 1573361999    
 
# LIST OF INTERVENEING TIME STAMPS TO EXCLUDE FROM QUERY (11:59:59PM prior to time change to 6:00:00AM after time change) IN DATETIME AND UTC (EASTERN TIME ZONE ONLY):
    # Saturday November 2, 2013 @ 11:59:59PM EST through Sunday November 3, 2013 @ 6:00:00AM EST | 1383451199 - 1383476400 
    # Saturday November 1, 2014 @ 11:59:59PM EST through Sunday November 2, 2014 @ 6:00:00AM EST | 1414900799 - 1414926000
    # Saturday October 31, 2015 @ 11:59:59PM EST through Sunday November 1, 2015 @ 6:00:00AM EST | 1446350399 - 1446375600
    # Saturday November 5, 2016 @ 11:59:59PM EST through Sunday November 6, 2016 @ 6:00:00AM EST | 1478404799 - 1478430000 
    # Saturday November 4, 2017 @ 11:59:59PM EST through Sunday November 5, 2017 @ 6:00:00AM EST | 1509854399 - 1509879600
    # Saturday November 3, 2018 @ 11:59:59PM EST through Sunday November 4, 2018 @ 6:00:00AM EST | 1541303999 - 1541329200
    # Saturday November 2, 2019 @ 11:59:59PM EST through Sunday November 3, 2019 @ 6:00:00AM EST | 1572753599 - 1572778800

# EASTERN TIME ZONE UTC VALUES (HARD CODED WITH AID FROM http://www.vk2zay.net/calculators/epochTimeConverter.php) (OR https://www.epochconverter.com/)
# 2013start, 2013end, 2014start, 2014end, 2015start, 2015end, .... 2019start, 2019end 
easternBounds=(1382868000 1384059599 1414317600 1415509199 1445767200 1446958799 1477821600 1479013199 1509271200 1510462799 1540720800 1541912399 1572170400 1573361999); 
# 2013dayBeforeChange, 2013dayAfterChange, 2014dayBeforeChange, 2014dayAfterChange, 2015dayBeforeChange, 2015dayAfterChange, .... 2019dayBeforeChange, 2019dayAfterChange 
easternChange=(1383451199 1383476400 1414900799 1414926000 1446350399 1446375600 1478404799 1478430000 1509854399 1509879600 1541303999 1541329200 1572753599 1572778800); 

constant=3600; # number of seconds in 1 hour 
multiplier=0; 

# CENTRAL TIME ZONE 
let multiplier+=1; # how many timezones away from Eastern?
addend=$(($constant * $multiplier)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    centralBounds[idx]=$(( easternBounds[idx] + addend )); 
    centralChange[idx]=$(( easternChange[idx] + addend )); 
done

# MOUNTAIN TIME ZONE 
let multiplier+=1; # how many timezones away from Eastern?
addend=$(($constant * $multiplier)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    mountainBounds[idx]=$(( easternBounds[idx] + addend )); 
    mountainChange[idx]=$(( easternChange[idx] + addend )); 
done

# PACIFIC TIME ZONE 
let multiplier+=1; # how many timezones away from Eastern?
addend=$(($constant * $multiplier)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    pacificBounds[idx]=$(( easternBounds[idx] + addend )); 
    pacificChange[idx]=$(( easternChange[idx] + addend )); 
done

# ALASKA TIME ZONE 
let multiplier+=1; # how many timezones away from Eastern?
addend=$(($constant * $multiplier)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    alaskaBounds[idx]=$(( easternBounds[idx] + addend )); 
    alaskaChange[idx]=$(( easternChange[idx] + addend )); 
done

# CONCATENATE ALL TIME STAMPS FOR USE IN QUERY LOOP 
allBounds=(${easternBounds[@]} ${centralBounds[@]} ${mountainBounds[@]} ${pacificBounds[@]} ${alaskaBounds[@]}); 
allChanges=(${easternChange[@]} ${centralChange[@]} ${mountainChange[@]} ${pacificChange[@]} ${alaskaChange[@]}); 

# QUERY LOOP (CREATES NEW .CSV FILE FOR EACH TIME ZONE, YEAR, AND TIME POSITION RELATIVE TO CRITICAL TIME CHANGE DATE) 
counter=-1; 
for ((i=1; i<=nTimeZones; i++)) # FOR EACH TIME ZONE (EASTERN, CENTRAL, MOUNTAIN, PACIFIC, ALASKA)
do
    # GET CURRENT TIME ZONE INFO 
    timeZone=${timeZoneLabels[$i-1]};  
    case $timeZone in 
        "EASTERN")
        timeZone_dst=-4; 
        timeZone_standard=-5; 
        ;;
        "CENTRAL")
        timeZone_dst=-5; 
        timeZone_standard=-6; 
        ;;
        "MOUNTAIN")
        timeZone_dst=-6; 
        timeZone_standard=-7; 
        ;;
        "PACIFIC")
        timeZone_dst=-7; 
        timeZone_standard=-8; 
        ;;
        "ALASKA")
        timeZone_dst=-8; 
        timeZone_standard=-9; 
        ;;
    esac

    for ((j=1; j<=nYears; j++)) # FOR EACH YEAR (2013, 2014, 2015, 2016, 2017, 2018, 2019)
    do
        # GET CURRENT YEAR
        year=${years[$j-1]}; 

        for ((k=1; k<=nPositions; k++)) # FOR EACH POSITION RELATIVE TO CRITICAL TIME CHANGE (Pre, Post)
        do
            # GET CURRENT POSITION RELATIVE TO TIME CHANGE
            position=${positions[$k-1]};
            case $position in
                "PRE")
                tz=$timeZone_dst; 
                ;;
                "POST")
                tz=$timeZone_standard;
                ;;
            esac  
 
            let counter+=1; 
            # GET LOWER BOUND FOR POSSIBLE DATES 
            date_lower=${allBounds[counter]};   
            # GET UPPER BOUND FOR POSSIBLE DATES  
            date_upper=${allChanges[counter]};    

            # WHICH SEASON/YEAR/TIME ZONE IS THE CODE CURRENTLY ITERATING THROUGH? 
            echo "Gathering data from $season $year for $timeZone time zone ($position) | $date_lower through $date_upper" 

            # GET QUERY START TIME
            tic=$(date +"%s"); # "%s" SPECIFIES UTC TIME

            # QUERY THE DATA & WRITE CSV FILE     
            mysql -u mysqlusr -pmn5ZIE0R -e "SELECT * FROM daybag WHERE AirportId=$airport AND Day=$day AND Replay=$replay AND ModeId=$mode AND TimeZone=$tz AND Date BETWEEN LEAST($date_lower, $date_upper) AND GREATEST($date_upper, $date_lower);" -D data3 > DST_${season}_${year}_${timeZone}_${position}.csv 
            # mysql -u mysqlusr -pmn5ZIE0R -e "SELECT * FROM sandbox WHERE AirportId=$airport AND Day=$day AND Replay=$replay AND ModeId=$mode AND TimeZone=$tz AND Date BETWEEN LEAST($date_lower, $date_upper) AND GREATEST($date_upper, $date_lower);" -D data3 > DST_${season}_${year}_${timeZone}_${position}.csv   

            # GET QUERY END TIME 
            toc=$(date +"%s"); # "%s" SPECIFIES UTC TIME

            # HOW LONG DID IT TAKE TO RUN THE QUERY?
            elaspedTime=$(( toc - tic )); 
            printf "\t"
            echo "It took $elaspedTime seconds to run the above query"
            printf "\n"

        done # POSITION LOOP  

    done # YEAR LOOP 

done # TIME ZONE LOOP 

######################################################################################################################## 
