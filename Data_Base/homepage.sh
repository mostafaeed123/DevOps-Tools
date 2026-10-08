#!/bin/bash
source extentions/welcome.sh
source tableOperations/Insertdata.sh
source tableOperations/selectrow.sh
source tableOperations/deleterom.sh

welcome

select option in "Create Database" "Delete Database" "Create column" "Delete Column" "Exit"
do
    case $option in
        "Create Database")
            cd Lib
            ./createdb.sh
            cd ..
            ;;
        "Delete Database")
            cd Lib
            ./deletedb.sh
            cd ..
            ;;
        "Create column")
            cd Lib
            ./createcol.sh
            cd ..
            ;;
        "Delete Column")
            cd Lib
            ./deletecol.sh
            cd ..
            ;;
        "Exit")
            break
            ;;
    esac
done
