echo "###########################################"
echo "######## Delete specific column ###########"
echo "###########################################"
source ../validation/existDb.sh
source ../validation/existCol.sh

read -p "Enter the name of db : " db
if existdb "$db" ; then
     cd "../Databases/$db" || exit 1
    read -p "Enter the name of column : " col
    if [[ -f "$col" ]] ; then
        rm -rf  $col
        echo "the column deleted successfully....."
    else
        echo "this column in not exist"
    fi
else
    echo "this db is not exist"
fi