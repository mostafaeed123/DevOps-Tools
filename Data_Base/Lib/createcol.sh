source ../validation/checkNameTrue.sh
source ../validation/existDb.sh
source ../validation/existCol.sh
source ../tableOperations/Insertdata.sh
source ../tableOperations/selectrow.sh
source ../tableOperations/deleterow.sh

echo "###########################################"
echo "########### Add a new column ##############"
echo "###########################################"
read -p "Enter the name of db : " db

if IsNameTrue "$db" ; then
    if existdb "$db" ; then
    echo "this db is exist"
    else
        mkdir -p "../Databases/$db"
    fi
    cd "../Databases/$db" || exit 1

    read -p "Enter the name of col : " col
    if IsNameTrue "$col" ; then
        if [[ -f "$col" ]]; then
            echo "this column is exist"
        else
            touch "$col"
        fi
    else
        echo "the name of column is not valid"
    fi
else
    echo "the name of data base is not valid"
fi

tablefile="$col"

select options in "Insert Row" "Select Row" "Delete Row" "Exit"
do
    case $options in 
        "Insert Row")
        InsertData "$tablefile" ;;
        "Select Row")
        selectSearch "$tablefile" ;;
        "Delete Row")
        deleteRow "$tablefile" ;;
        "Exit")
        break ;;
        *)
        echo "Invalid option"
        exit 
    esac
done

        