#!/bin/bash

#################################################################################################################################################################
# CREATED BY SAMONI NAG ON 10/26/2020
# 
# THIS SCRIPT QUERIES DATA FROM DAYBAG (OR SANDBOX) 70 DIFFERENT TIMES (FOR 5 U.S. TIMEZONES & 7 YEARS & 2 RELATIVE POSITIONS) WITH THE FOLLOWING CRITERIA:
#   [1] AIRPORT = 2 (HONOLULU)
#   [2] DAY = 1 (LEVEL 1)
#   [3] REPLAY = 0 (NO REPLAY)
#   [4] MODE = 0 (CAREER)
#   [5] DATE FALLS WITHIN CERTAIN TIME RANGES AROUND A CONTROL "PHASE CHANGE" FROM 2013 - 2019 
#    
# RELEVANT TIME ZONES INCLUDE: 
#   - EASTERN, CENTRAL, MOUNTAIN, PACIFIC, ALASKA 
#       - STANDARD: -5, -6, -7, -8, -9 
#       - DAYLIGHT: -4, -5, -6, -7, -8 
#   - NOT INCLUDING HAWAII (-10) BECUASE DST IS NOT OBSERVED 
# 
#################################################################################################################################################################

season="SEPTEMBER";

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
    # Sunday September 8, 2013 @ 6:00:00AM EST through Saturday September 21, 2013 @ 11:59:59PM EST | 1378634400 - 1379822399  
    # Sunday September 14, 2014 @ 6:00:00AM EST through Saturday September 27, 2014 @ 11:59:59PM EST | 1410688800 - 1411876799  
    # Sunday September 13, 2015 @ 6:00:00AM EST through Saturday September 26, 2015 @ 11:59:59PM EST | 1442138400 - 1443326399  
    # Sunday September 11, 2016 @ 6:00:00AM EST through Saturday September 24, 2016 @ 11:59:59PM EST | 1473588000 - 1474775999  
    # Sunday September 10, 2017 @ 6:00:00AM EST through Saturday September 23, 2017 @ 11:59:59PM EST | 1505037600 - 1506225599  
    # Sunday September 9, 2018 @ 6:00:00AM EST through Saturday September 22, 2018 @ 11:59:59PM EST | 1536487200 - 1537675199  
    # Sunday September 8, 2019 @ 6:00:00AM EST through Saturday September 21, 2019 @ 11:59:59PM EST | 1567936800 - 1569124799    
 
# LIST OF INTERVENEING TIME STAMPS TO EXCLUDE FROM QUERY (11:59:59PM prior to time change to 6:00:00AM after time change) IN DATETIME AND UTC (EASTERN TIME ZONE ONLY):
    # Saturday September 14, 2013 @ 11:59:59PM EST through Sunday September 15, 2013 @ 6:00:00AM EST | 1379217599 - 1379239200 
    # Saturday September 20, 2014 @ 11:59:59PM EST through Sunday September 21, 2014 @ 6:00:00AM EST | 1411271999 - 1411293600
    # Saturday September 19, 2015 @ 11:59:59PM EST through Sunday September 20, 2015 @ 6:00:00AM EST | 1442721599 - 1442743200
    # Saturday September 17, 2016 @ 11:59:59PM EST through Sunday September 18, 2016 @ 6:00:00AM EST | 1474171199 - 1474192800 
    # Saturday September 16, 2017 @ 11:59:59PM EST through Sunday September 17, 2017 @ 6:00:00AM EST | 1505620799 - 1505642400
    # Saturday September 15, 2018 @ 11:59:59PM EST through Sunday September 16, 2018 @ 6:00:00AM EST | 1537070399 - 1537092000
    # Saturday September 14, 2019 @ 11:59:59PM EST through Sunday September 15, 2019 @ 6:00:00AM EST | 1568519999 - 1568541600

# EASTERN TIME ZONE UTC VALUES (HARD CODED WITH AID FROM http://www.vk2zay.net/calculators/epochTimeConverter.php) (OR https://www.epochconverter.com/)
# 2013start, 2013end, 2014start, 2014end, 2015start, 2015end, .... 2019start, 2019end 
easternBounds=(1378634400 1379822399 1410688800 1411876799 1442138400 1443326399 1473588000 1474775999 1505037600 1506225599 1536487200 1537675199 1567936800 1569124799); 
# 2013dayBeforeChange, 2013dayAfterChange, 2014dayBeforeChange, 2014dayAfterChange, 2015dayBeforeChange, 2015dayAfterChange, .... 2019dayBeforeChange, 2019dayAfterChange 
easternChange=(1379217599 1379239200 1411271999 1411293600 1442721599 1442743200 1474171199 1474192800 1505620799 1505642400 1537070399 1537092000 1568519999 1568541600); 

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
                # tz=$timeZone_standard;
                tz=$timeZone_dst;
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
