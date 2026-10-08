echo "###########################################"
echo "######## Delete specific Database #########"
echo "###########################################"
source ../validation/existDb.sh

read -p "Enter the name of db : " db
if existdb "$db" ; then
    rm -rf "../Databases/$db"
    echo "database deleted successfully...."
else
    echo "this db does not exist"
    exit
fi
