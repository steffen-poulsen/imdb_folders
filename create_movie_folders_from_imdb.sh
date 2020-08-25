#!/bin/sh

# Retrieves current list of movies from imdb
# Creates one folder and one empty .mkv for each movie
# More than 489000 movie folders will be created

# These folders can be directly imported in radarrr

if [ ! -f title.basics.tsv ]; then
  wget "https://datasets.imdbws.com/title.basics.tsv.gz" -O title.basics.tsv.gz
  gunzip title.basics.tsv.gz
fi

# Cleanup any non-file-system characters in the title and put the year in paranthesis
cut -f2-3,6 title.basics.tsv | grep ^movie | cut -f2,3 | grep -P "\d\d\d\d$" | perl -pe 's/\s*(\d\d\d\d)$/ ($1)/g' | perl -pe 's/\: / - /g' | perl -pe 's/\"/'\''/g' | perl -pe 's/[\/\:\*\\\;\|\<\>]/\-/g' | perl -pe 's/[\?\¿\!\¡]//g' | sort | uniq > imdb_movies.txt

# Create movie folders
xargs -0 -d \\n -I {} mkdir -p './imdb_movies/{}' < imdb_movies.txt 

# Put one empty .mkv in each folder to allow radarr to pick it up
xargs -0 -d \\n -I {} touch './imdb_movies/{}/{}.mkv' < imdb_movies.txt 
