#!/usr/bin/env bash
source /opt/$VENV_NAME/bin/activate 

rm -rf ./R/data_refresh_R_files
rm ./R/data_refresh_R.html
quarto render ./R/data_refresh_R.qmd --to html

rm -rf docs/data_refresh_R/
mkdir docs/data_refresh_R
cp ./R/data_refresh_R.html ./docs/data_refresh_R/
cp -R ./R/data_refresh_R_files ./docs/data_refresh_R/

echo "Finish"
p=$(pwd)
git config --global --add safe.directory $p

#Check for changes and commit if any
if [[ "$(git status --porcelain)" != "" ]]; then
    #Render index dashboard (assumes index.qmd uses R or Rmd code chunks)
    quarto render R/index.qmd
    cp R/index.html docs/index.html
    rm -rf docs/index_files
    cp -R R/index_files/ docs/
    rm R/index.html
    rm -rf R/index_files
    
    git config --global user.name $USER_NAME
    git config --global user.email $USER_EMAIL
    git add csv/*
    git add metadata/*
    git add docs/*
    git commit -m "Auto update of the data"
    git push origin main
else
echo "Nothing to commit..."
fi
