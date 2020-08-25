#!/bin/sh

# Retrieves current list of tv series from imdb
# Creates one folder and one empty .mkv for each tv series
# More than 178000 tv series folders will be created

# These folders can be directly imported in sonarr

if [ ! -f title.basics.tsv ]; then
  wget "https://datasets.imdbws.com/title.basics.tsv.gz" -O title.basics.tsv.gz
  gunzip title.basics.tsv.gz
fi

# Cleanup any non-file-system characters in the title and put the year in paranthesis
cut -f2-3,6 title.basics.tsv | grep ^tvSeries | cut -f2,3 | grep -P "\d\d\d\d$" | perl -pe 's/\s*(\d\d\d\d)$/ ($1)/g' | perl -pe 's/\: / - /g' | perl -pe 's/\"/'\''/g' | perl -pe 's/[\/\:\*\\\;\|\<\>]/\-/g' | perl -pe 's/[\?\¿\!\¡]//g' | sort | uniq > imdb_tv_series.txt

# Create tv series folders
xargs -0 -d \\n -I {} mkdir -p './imdb_tv_series/{}/Season 00' < imdb_tv_series.txt 

# Put one empty .mkv in each folder to allow sonarr to pick up the tv series
xargs -0 -d \\n -I {} touch './imdb_tv_series/{}/Season 00/S00E999 - {}.mkv' < imdb_tv_series.txt 
