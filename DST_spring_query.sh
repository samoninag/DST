#!/bin/bash

#################################################################################################################################################################
# CREATED BY SAMONI NAG ON 10/6/2020
# 
# THIS SCRIPT QUERIES DATA FROM DAYBAG (OR SANDBOX) 70 DIFFERENT TIMES (FOR 5 U.S. TIMEZONES & 7 YEARS & 2 RELATIVE POSITIONS) WITH THE FOLLOWING CRITERIA:
#   [1] AIRPORT = 2 (HONOLULU)
#   [2] DAY = 1 (LEVEL 1)
#   [3] REPLAY = 0 (NO REPLAY)
#   [4] MODE = 1 (CAREER)
#   [5] DATE FALLS WITHIN CERTAIN TIME RANGES AROUND A DST PHASE ADVANCE (SPRING FORWARD) FROM 2013 - 2019 
#    
# RELEVANT TIME ZONES INCLUDE: 
#   - EASTERN, CENTRAL, MOUNTAIN, PACIFIC, ALASKA
#       - STANDARD: -5, -6, -7, -8, -9 
#       - DAYLIGHT: -4, -5, -6, -7, -8 
#   - NOT INCLUDING HAWAII (-10) BECUASE DST IS NOT OBSERVED 
# 
#################################################################################################################################################################

season="SPRING";

# AIRPORT SCANNER CRITERIA
airport=2;  
day=1;  
replay=0;  
mode=1;

# LIST OF TIME ZONES     
timeZoneLabels=("EASTERN" "CENTRAL" "MOUNTAIN" "PACIFIC" "ALASKA"); 
nTimeZones=${#timeZoneLabels[@]}; # 5  

# SET OTHER VARIABLES TO BE USED IN QUERY LOOPS    
years=(2013 2014 2015 2016 2017 2018 2019);
nYears=${#years[@]}; # 7
positions=("PRE" "POST");
nPositions=${#positions[@]}; # 2
        
# LIST OF RELEVANT TIME STAMPS (BOUNDS OF 14-DAY WINDOW AROUND TIME CHANGE) IN DATETIME AND UTC (EASTERN TIME ZONE ONLY):  
    # Sunday March 3, 2013 @ 6:00:00AM EST through Saturday March 16, 2013 @ 11:59:59PM EST | 1362308400 - 1363492799  
    # Sunday March 2, 2014 @ 6:00:00AM EST through Saturday March 15, 2014 @ 11:59:59PM EST | 1393758000 - 1394942399  
    # Sunday March 1, 2015 @ 6:00:00AM EST through Saturday March 14, 2015 @ 11:59:59PM EST | 1425207600 - 1426391999  
    # Sunday March 6, 2016 @ 6:00:00AM EST through Saturday March 19, 2016 @ 11:59:59PM EST | 1457262000 - 1458446399  
    # Sunday March 5, 2017 @ 6:00:00AM EST through Saturday March 18, 2017 @ 11:59:59PM EST | 1488711600 - 1489895999  
    # Sunday March 4, 2018 @ 6:00:00AM EST through Saturday March 17, 2018 @ 11:59:59PM EST | 1520161200 - 1521345599  
    # Sunday March 3, 2019 @ 6:00:00AM EST through Saturday March 16, 2019 @ 11:59:59PM EST | 1551610800 - 1552795199    

# LIST OF INTERVENEING TIME STAMPS TO EXCLUDE FROM QUERY (11:59:59PM prior to time change to 6:00:00AM after time change) IN DATETIME AND UTC (EASTERN TIME ZONE ONLY):
    # Saturday March 9, 2013 @ 11:59:59PM EST through Sunday March 10, 2013 @ 6:00:00AM EST | 1362891599 - 1362909600
    # Saturday March 8, 2014 @ 11:59:59PM EST through Sunday March 9, 2014 @ 6:00:00AM EST | 1394341199 - 1394359200
    # Saturday March 7, 2015 @ 11:59:59PM EST through Sunday March 8, 2015 @ 6:00:00AM EST | 1425790799 - 1425808800
    # Saturday March 12, 2016 @ 11:59:59PM EST through Sunday March 13, 2016 @ 6:00:00AM EST | 1457845199 - 1457863200
    # Saturday March 11, 2017 @ 11:59:59PM EST through Sunday March 12, 2017 @ 6:00:00AM EST | 1489294799 - 1489312800
    # Saturday March 10, 2018 @ 11:59:59PM EST through Sunday March 11, 2018 @ 6:00:00AM EST | 1520744399 - 1520762400
    # Saturday March 9, 2019 @ 11:59:59PM EST through Sunday March 10, 2019 @ 6:00:00AM EST | 1552193999 - 1552212000

# EASTERN TIME ZONE UTC VALUES (HARD CODED WITH AID FROM http://www.vk2zay.net/calculators/epochTimeConverter.php) 
# 2013start, 2013end, 2014start, 2014end, 2015start, 2015end, .... 2019start, 2019end 
easternBounds=(1362308400 1363492799 1393758000 1394942399 1425207600 1426391999 1457262000 1458446399 1488711600 1489895999 1520161200 1521345599 1551610800 1552795199); 
easternChange=(1362891599 1362909600 1394341199 1394359200 1425790799 1425808800 1457845199 1457863200 1489294799 1489312800 1520744399 1520762400 1552193999 1552212000); 

constant=3600; # number of seconds in 1 hour
factor=0; 

# CENTRAL TIME ZONE 
let factor+=1; # how many timezones away from Eastern?
plus=$(($constant * $factor)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    centralBounds[idx]=$(( easternBounds[idx] + plus )); 
    centralChange[idx]=$(( easternChange[idx] + plus )); 
done

# MOUNTAIN TIME ZONE 
let factor+=1; # how many timezones away from Eastern?
plus=$(($constant * $factor)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    mountainBounds[idx]=$(( easternBounds[idx] + plus )); 
    mountainChange[idx]=$(( easternChange[idx] + plus )); 
done

# PACIFIC TIME ZONE 
let factor+=1; # how many timezones away from Eastern?
plus=$(($constant * $factor)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    pacificBounds[idx]=$(( easternBounds[idx] + plus )); 
    pacificChange[idx]=$(( easternChange[idx] + plus )); 
done

# ALASKA TIME ZONE 
let factor+=1; # how many timezones away from Eastern?
plus=$(($constant * $factor)); # what to add to Eastern time stamps
for idx in "${!easternBounds[@]}"; 
do
    alaskaBounds[idx]=$(( easternBounds[idx] + plus )); 
    alaskaChange[idx]=$(( easternChange[idx] + plus )); 
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
                tz=$timeZone_standard; 
                ;;
                "POST")
                tz=$timeZone_dst;
                ;;
            esac 

            # GET LOWER BOUND FOR POSSIBLE DATES 
            let counter+=1; 
            date_lower=${allBounds[counter]};   
            # GET UPPER BOUND FOR POSSIBLE DATES 
            let counter+=1;
            date_upper=${allChanges[counter]};    

            # WHICH SEASON/YEAR/TIME ZONE IS THE CODE CURRENTLY ITERATING THROUGH?
            printf "\n"
            echo "Gathering data from $season $year for $timeZone time zone ($position)"
            printf "\n"

            # QUERY THE DATA & WRITE CSV FILE  
                # DATE has to be between date_lower and exclude_lower prior to time change when TIME/TIMEZONE is STANDARD
                # DATE has to be between exclude_upper and date_upper after time change when TIME/TIMEZONE is DST 
                mysql -u mysqlusr -pmn5ZIE0R -e "SELECT * FROM sandbox WHERE AirportId=$airport AND Day=$day AND Replay=$replay AND ModeId=$mode AND TimeZone=$tz AND Date BETWEEN $date_lower AND $date_upper;" -D data3 > DST_${season}_${year}_${timeZone}_${position}.csv  
                # mysql -u mysqlusr -pmn5ZIE0R -e "SELECT * FROM daybag WHERE AirportId=$airport AND Day=$day AND Replay=$replay AND ModeId=$mode AND TimeZone=$tz AND Date BETWEEN $date_lower AND $date_upper;" -D data3 > DST_${season}_${year}_${timeZone}_${position}.csv  

        done # POSITION LOOP  

    done # YEAR LOOP 

done # TIME ZONE LOOP 

