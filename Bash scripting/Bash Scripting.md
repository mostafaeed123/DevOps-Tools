
- هنا لما تيجى تعمل ملف باش الملف هيكون اخره sh

```bash
#!/bin/bash
```
- لازم تكتب السطر ده علشان تعرفه انك هتكب باش 
- لو عايز تعمل variable هتعمل الاتى 
```bash
#!/bin/bash

 name="mostafa"

 city="menofia"

 echo "my name is $name "

 echo " $name is living in $city "
```
- هنا عرفت المتغيران دول وعملت echo علشان اطبعهم وعلشان تشغل الامر ده لازم لينكس او git bash هتعمل الاتى 
```bash
./bash.sh
```


- علشان تعمل كومنت هتعمل هاش #

---
```bash
#!/bin/bash

 name="mostafa"

 city="menofia"

 echo "my name is $name "

 echo " $name is living in $city "

  

  a=10

  b=20

  echo "the result is = $a + $b = $((a+b)) "
```
- هنا علشان  تجمع بين المتغيرين دول لازم تعمل كده  $((a+b))

```bash
batman@Gunner MINGW64 /d/Root/Devops/Bash scripting/bash
$ ./bash.sh
my name is mostafa
 mostafa is living in menofia
the result is = 10 + 20 = 30

```

---
```bash
#!/bin/bash
 name="mostafa"
 city="menofia"
# echo "my name is $name "
# echo " $name is living in $city "
  #  a=10
 # b=20
  # echo "the result is = $a + $b = $((a+b)) "
  echo "enter your first number"
  read a
  echo "enter your second number"
  read b
  echo "the result is = $a + $b = $((a+b)) "
```
- هنا read معنها انك هتاخد متغير من اليوزر 


---

```bash
#!/bin/bash


echo "$HOME"
```
- هنا المتغير الى هوا الـ home ده مش موجود فى الملف فراح دور فى الـ enviroment فلاقى دى 

```bash
batman@Gunner MINGW64 /d/Root/Devops/Bash scripting/bash
$ ./bash.sh
/c/Users/batman
```


---
```bash
$0

$1

$2

./bash.sh 5 10
```

- هنا اول arguement هيكون هوا  ./bash.sh  الى هوا  $0
- تانى هوا $1    === 5
-  $2 ==== 10

---
- كتبت كده فى الكود
```bash
#!/bin/bash
a= $1
b= $2
echo "the result of this = $1 + $2 = $(($1 +$2))"
```

```bash
batman@Gunner MINGW64 /d/Root/Devops/Bash scripting/bash
$ ./bash.sh 5 10
./bash.sh: line 4: 5: command not found
./bash.sh: line 5: 10: command not found
the result of this = 5 + 10 = 15
```


---
```bash
#!/bin/bash

echo -n "enter the first number :"
read a
```
- هنا بيقولك انه انه بيطبع دى وكمان هيقرا الكلام الى اليوزر الى هيدخله اليوزر
- دى زى الاتى 

```bash
#!/bin/bash

read -p "Enter your first name: " a
```
- هنا هيطبع دى وكمان هيقرا الى انته هتحطه وهيخزنه فى  a

---
```bash
#!/bin/bash

case $1 in
    "start")
        echo "starting the service .."
        ;;
    "stop")
        echo "stop the service...."
        ;;
    "restart")
        echo "restarting the service"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
esac
```
- هنا فى حاله الشرط فى الباش هتعمل اول حاجه كلمه case وبعدها الباراميتر الى انته بتستقبله وبعدها لو كان الباراميتر ده بيساور start هتطبع الجمله دى وبعدها تطلع عن طريق ;;


---
```bash
#!/bin/bash

  

read -p "enter your name" n

case $n in

    "mostafa")

    echo "your name is $n" ;;

    "mohammed")

    echo "your name is $n" ;;

    "abdo")

    echo "your name is $n" ;;

    *)

    echo " the name is not exit";;

esac
```
- كده هيستقبل الاسم من اليوزر وبعدها يبدا يقارن هنا اخر واحده بعد *( **  بتكتب الحجات الى ممكن تحصل لو مش موجود

```bash
batman@Gunner MINGW64 /d/Root/Devops/Bash scripting/bash
$ ./bash.sh
enter your name mostafa
your name is mostafa

```

|العملية|المعنى|
|---|---|
|`-eq`|equal (يساوي)|
|`-ne`|not equal (لا يساوي)|
|`-gt`|greater than (أكبر من)|
|`-ge`|greater than or equal (أكبر من أو يساوي)|
|`-lt`|less than (أصغر من)|
|`-le`|less than or equal (أصغر من أو يساوي)|

بتستخدمها جوه شرط `[ ]` أو `[[ ]]` كده مثلاً:
- دى ممكن تستخدمها فى المقارنه

```bash
if [ $a -eq $b ]; then
    echo "equal"
fi
```

|العملية|المعنى|
|---|---|
|`-f`|check if file exists (فحص إن الملف موجود)|
|`-d`|check if directory exists (فحص إن الفولدر موجود)|
|`-e`|check if file or directory exists (فحص إن ملف أو فولدر موجود)|
|`-z`|check if string is empty (فحص إن السترينج فاضي)|
|`-n`|check if string is not empty (فحص إن السترينج مش فاضي)|

أمثلة على الاستخدام:
```bash
if [ -f "myfile.txt" ]; then
    echo "File exists"
fi

if [ -d "myfolder" ]; then
    echo "Directory exists"
fi

if [ -z "$str" ]; then
    echo "String is empty"
fi
```

|العملية|المعنى|
|---|---|
|`-f`|check if file exists (فحص إن الملف موجود)|
|`-d`|check if directory exists (فحص إن الفولدر موجود)|
|`-e`|check if file or directory exists (فحص إن ملف أو فولدر موجود)|
|`-z`|check if string is empty (فحص إن السترينج فاضي)|
|`-n`|check if string is not empty (فحص إن السترينج مش فاضي)|
|`-r`|check if file is readable (فحص إن الملف قابل للقراءة)|
|`-w`|check if file is writable (فحص إن الملف قابل للكتابة)|
|`-x`|check if file is executable (فحص إن الملف قابل للتنفيذ)|

مثال عملي:

```bash
if [ -r "myfile.txt" ]; then
    echo "File is readable"
fi

if [ -x "script.sh" ]; then
    echo "File is executable"
else
    echo "Run: chmod +x script.sh"
fi
```


---
- او ممكن تستخدم الرموز زى كده 
```bash
#!/bin/bash

  

read -p "enter the number: " num

  

if [[ $num = 10 ]]; then

    echo "the $num is equal to 10"

else

    echo "mostafa"

fi
```

---
- ممكن تستخدم الرموز بالشكل ده الاتى الجميل ده

```bash
if (( num < 10 )); then
    num=10
fi
```

```bash
(( num < 10 ))
(( num > 10 ))
(( num == 10 ))
```


---

```bash
#!/bin/bash

# Function to add a user
add_user() {
    local username="$1"

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists. Skipping."
    else
        useradd -m "$username"
        if [ $? -eq 0 ]; then
            echo "User '$username' added successfully."
        else
            echo "Error occurred while adding user '$username'."
        fi
    fi
}

# Function to delete a user
delete_user() {
    local username="$1"

    if id "$username" &>/dev/null; then
        userdel -r "$username"
        if [ $? -eq 0 ]; then
            echo "User '$username' deleted successfully."
        else
            echo "Error occurred while deleting user '$username'."
        fi
    else
        echo "User '$username' does not exist. Nothing to delete."
    fi
}

# Interactive menu
echo "Choose an operation:"
echo "1) Add user"
echo "2) Delete user"
read -p "Enter your choice: " choice

read -p "Enter the username: " uname

case "$choice" in
    1)
        add_user "$uname"
        ;;
    2)
        delete_user "$uname"
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
```
- هنا ده مثال على  سكربت باش انه يضيف يوزر وبرضه لو جيت اضيف اليوزر ده ةاليوزر كان موجود ميضفهوش وبرضه انه يحذف يوزر واليوزر لو مش موجود ميحذفهوش

---

# # Logical operators

- ممكن تستخدم الرموز بالشكل ده الاتى الجميل ده

```bash
if (( num < 10 )); then
    num=10
fi
```

```bash
(( num < 10 ))
(( num > 10 ))
(( num == 10 ))
```

```bash
#!/bin/bash
a=10
b=20
if (($a < b)) && (($b > $a)) ; then
    echo " B is greater than a"
else
    echo " A is greater than B"
fi
```

----
# # Loops

```bash
#!/bin/bash
for var in 1 2 3 4 5
do
    echo "the number is $var"
done
```

- الناتج هيكون 
```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
the number is 1
the number is 2
the number is 3
the number is 4
the number is 5
```
- هنا فى كود اللوب بياخد الواحد وبعدها بيدخل على الـ do بينفذ الكود الى جواه وبعدها بيعمل done وبعدها بيروح يجيب الـ 2 وبعدها بيعمل الشغل الى جوه الـ do وبعدها بيعمل done

---
- لو انته عايز تعمل لوب من اول واحد لحد 100 هتعمل الاتى 

```bash

#!/bin/bash
for var in {1..100}
do
    echo "the number is $var"

done
```
- كده هيطبع من واحد لحد 100

---
```bash
#!/bin/bash
for var in {1..10..2}
do
    echo "the number is $var"
done
```
- هنا معناها انك هتبدا من عند الواحد وكل مره هتزود اتنين فهيكون شكل الطباعه كده
```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
the number is 1
the number is 3
the number is 5
the number is 7
the number is 9
root@MY-Home:/home/mostafa/Documents/Data base Project#
```

---
- فى اللوب فى الحاله الطبيعيه بتعمل الاتى 
```bash
#!/bin/bash
for (( i=0 ; i<=10 ; i++ ));
do
    echo "the number is $i"
done
```
- هيطلع الناتج الاتى 
```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
the number is 0
the number is 1
the number is 2
the number is 3
the number is 4
the number is 5
the number is 6
the number is 7
the number is 8
the number is 9
the number is 10
```


---
- او ممكن تعمل الاتى 
```bash
#!/bin/bash
for (( i=0 ; i<=10 ;  ));
do
    echo "the number is $i"
    ((i++))
done
```

---
---
## # While Loop
```bash
#!/bin/bash
while (( i <= 5  ));
do
    echo "the number is $i"
    ((i++))
done
```

- طالما الشرط بيتحقق هيفضل يشتغل 
```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
the number is 
the number is 1
the number is 2
the number is 3
the number is 4
the number is 5
root@MY-Home:/home/mostafa/Documents/Data base Project# 
```

---
---
---

# # Drop Down menu

```bash
#!/bin/bash

select option in "start" "stop" "restart" "exit"
do 
    case $option in 
        "start")
        echo "start this servece ..." ;;
        "stop")
        echo "stop this servece ..." ;;
        "restart")
        echo "restart this servece ..." ;;
        "exit")
        echo "exit this servece ..." ;;
        *)
        echo "invalid option" ;;
    esac
done
```
- هنا فى الـ selcect دى مهمه جدا لو انته عايز تعمل شويه options هنا المتغير الى اسمه option ممكن تغير اسمه عادى وبعدها هتعمل case علشان تختار من ضمن الحجات دى وبعدها هتقفل الـ cases من خلال الـ esac وبعدها تقفل الـ select من خلال الـ done

الناتج :::::

```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
1) start
2) stop
3) restart
4) exit
#? 1
start this servece ...
#? 4
exit this servece ...
#? 
```

- ممكن بقى تخليه اول مثلا لما تعمل start يعملك مثلا او يتفذ اسكربت معين زى الاتى 


```bash
#!/bin/bash

select option in "start" "stop" "restart" "exit"
do 
    case $option in 
        "start")
        echo "start this servece ..." 
         ./loginpage.sh
        ;;
        "stop")
        echo "stop this servece ..." ;;
        "restart")
        echo "restart this servece ..." ;;
        "exit")
        echo "exit this servece ..." ;;
        *)
        echo "invalid option" ;;
    esac
done
```
- هنا لو انا مثلا اخترت start كده هيدخلك على الملف الى اسمه loginpage.sh  انا حطيته فى نفس الفولدر بتاع ملف الـ main وعلشان يشتغل عملت ده./loginpage.sh   
![[Pasted image 20260906195236.png]]
![[Pasted image 20260906195254.png]]
- ده الى موجود فى الملف بتاع الوجين 
اول لما شغلت الاسكربت عمل الاتى 


```bash
root@MY-Home:/home/mostafa/Documents/Data base Project# ./start.sh
1) start
2) stop
3) restart
4) exit
#? 1
start this servece ...
Hello guest
```

---

```bash
#!/bin/bash

select option in "Create DateBase" "stop" "restart" "exit"
do 
    case $option in 
        "Create DateBase")
        echo "start Creating DateBase ..." 
         ./loginpage.sh
        ;;
        "stop")
        echo "stop this servece ..." ;;
        "restart")
        echo "restart this servece ..." ;;
        "exit")
        echo "exit this servece ..." 
        break ;;
        *)
        echo "invalid option" ;;
    esac
done
```

- هنا انا حطيت كلمه create date base بدل start  وبعدها غيرت فى ملف الـ login page  انه بياخد منك اسم الداتا بيز وبعدها بيعملها فولدر كما يلى فى الكود

```bash
echo "Hello guest"

read -p "enter database name ..... : " a
mkdir $a 
```


```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh
1) Create DateBase
2) stop
3) restart
4) exit
#? 1
start Creating DateBase ...
Hello guest
enter database name ..... : users
```

![[Pasted image 20260906200439.png]]
ده الفولدر الى عمله 


----
---
- هنا لو انا عايز اعمل table هعمل الاتى 
```bash
read -p "choose the name of the database" database
mkdir -p $database
cd $database
read -p "choose the name of the table" file
touch $file
```

- الاول هعمل فولدر ولو هوا عندى فى كلتا الحالتين هدخل الاول على الفولدر ده وبعدها هعمل فايل الفايل ده هوا الـ table

الـ `-p` معناها انه لما يجى يعمل ملف او فولدر لو هما موجودين ميديش ايرور ولو مش موجودين هيكريتهم 


---
- لو عايز تحذف table هتعمل الاتى 

```bash
read -p "enter the name of datebase : " database
cd $database
read -p "enter the name of table : " table
rm -rf $table
```
- هنا خليته يدخل على الفودر وحذف الـ table كله 
```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh
1) Create DateBase
2) createTable
3) deleteTable
4) exit
#? 3
enter the name of datebase : users
enter the name of table : names
```

---
---
----

# # Function

```bash
hello(){
    echo "mostafa"
}
hello
```
- هنا فى الاول كتبت اسم الداله وبعدها القوسين وبعدها جوه كتبت الاوامر الى عايزها تتنفذ فى الداله وبعدها علشان استدعيها كتبت فقط اسمها 

```bash
add(  ){
    sum=$(($1 +$2)) 
    echo " the sum is = $sum"
}

add "1" "2"
```
- هنا انته كانك ناولته القيميتن دول وهوا خدهم جوه وجمعهم والناتج الاتى 
```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh 
 the sum is = 3
```


```bash
add(  ){
    sum=$(($1 +$2)) 
    echo " the sum is = $sum"
}

add "10" "20"
```
- هنا خد القيميتين الثابتين دول وجمعهم وبقو 30 
```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh 
 the sum is = 30
```

----
---

```bash
add(  ){
    sum=$(($1 +$2)) 
    echo " the sum is = $sum"
}

add "$1" "$2"
```

```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh 10 200
 the sum is = 210
```
- هنا هوا فى الداله دى بيستقبل المتغيرات من اليوزر وبعدها بيحطها فى الداله

---
---
```bash
add(  ){
    sum=$(($1 +$2)) 
    echo " the sum is = $sum"
}
read -p "enter the first number: " num1
read -p "enter the second number: " num2

add "$num1" "$num2"
```


```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh 10 200
enter the first number: 55
enter the second number: 45
 the sum is = 100
```


---
---

```bash
add(  ){
    sum=$(($1 +$2)) 
    echo " the sum is = $sum"
}
read -p "enter the first number: " num1
read -p "enter the second number: " num2

add "$num1" "$num2"
add "10" "15"
add "$1" "$2"
```

```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh 10 200
enter the first number: 100
enter the second number: 200
 the sum is = 300
 the sum is = 25
 the sum is = 210
```

---
---

```bash
check_file_exixts(){
    if [ -f "$1" ]; then
        echo "file is exixt"
    else
        echo "file is not exixt"
    fi
}
check_file_exixts $1
```
- هنا انته بتشوف الملف ده موجود ولا لا وهنا بيدور فى نفس الفولدر الى هوا فيه 
```bash
mostafa@MY-Home:~/Documents/Data base Project$ ./start.sh tabel.sh
file is exixt
```

---

- لو انته عايز تستخدم داله من ملف خاجى هتعمل الاتى 
```bash
#!/bin/bash
source extentions/welcome.sh
welcome 
```
- هنا انا فى اسمه homepage ولكن ملف welcome موجود فى فولدر اسمه extention فلازم تحط كلمه source وبعدها تحط المسار بتاع الملف الى فيه الداله


```bash
#!/bin/bash
source extentions/welcome.sh
welcome 
```




----
---













- اول حاجه هتعمل كرييت داتا بيز  وهتعمل انك تحذف الداتا بيز وانك تعمل او تركيت تابل وانك تحذفه وانك تعمل exit وتبدا تعمل validation وتبدا تتعامل مع الريجكس 
اعمل validation على كل حاجه

- المفروض تعمل connect to database or coccect to table يعنى تضيف مثلا اسم كانه يكون صف row فى الـ table



- جوه الـ connect هتعمل create row

- ان انته تعمل  and delete row insert into row and select into row

- اول لما انته تعمل create للـ table هتظهرله مينوا يكون فيها  كل الحجات الى انته عايز تعملها فى الـ   الحجات الى قولنهاه فوقrow
- هنا مثلا  لو انته عايز تعمل سيرش هتستخدم الـ awk لانه بتخليك تدور على دورلار ساين 

- وبرضه عايز الـ id يكون primary key





