#!/bin/bash
#
# script to update covid19 cases datasets and convert them into RDS
# results are generated into xxx-DATE

DATE=`date -v-1d +"%m-%d-%Y"`

dirTGT="updateDS_"${DATE}
origDIR=`pwd`

mkdir ${dirTGT}
cd ${dirTGT}

#curl -L -O https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv

JHUurl="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"
TSdomain="csse_covid_19_time_series"
AGGdomain="csse_covid_19_daily_reports"
TSfiles="time_series_covid19_confirmed_global.csv time_series_covid19_deaths_global.csv time_series_covid19_recovered_global.csv 
	time_series_covid19_confirmed_US.csv time_series_covid19_deaths_US.csv"

### Time Series data
for file in `echo ${TSfiles}`; do
	target=${JHUurl}/${TSdomain}/${file} ;
	echo $target ;
	curl -L -O  $target ;
done

### Aggregated data

echo "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-27-2020.csv"

#dailyReport=${JHUurl}/${AGGdomain}/`date -v-1d +"%m-%d-%Y"`".csv"
dailyReport=${JHUurl}/${AGGdomain}/${DATE}".csv"
echo $dailyReport
curl -L -O $dailyReport


### City of Toronto data -- google drive
#https://drive.google.com/file/d/1euhrML0rkV_hHF1thiA0G5vSSeZCqxHY/view?usp=sharing
FILEID="1euhrML0rkV_hHF1thiA0G5vSSeZCqxHY"
FILENAME="covid19_Toronto.xlsx"	#"City.of.Toronto.xlsx"
#wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O FILENAME
curl -L "https://docs.google.com/uc?export=download&id=$FILEID" > $FILENAME


# RUN Rscript csv2rds.R
Rscript ../csv2rds.R

ln -s  ${DATE}".csv.RDS"  latest.RDS
