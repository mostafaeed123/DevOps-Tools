source ../validation/checkNameTrue.sh
source ../validation/existDb.sh

echo "###########################################"
echo "########### Add a new Database ############"
echo "###########################################"
read -p "Enter the name of db : " db

if IsNameTrue "$db" ; then
    if existdb "$db" ; then
        echo "this db is exist"
    else
        mkdir -p "../Databases/$db"
        cd "../Databases/$db" || exit 1
    fi
else
    echo "the name of data base is not valid"
fi