#!/bin/bash
function roll { #Получение случайного значения от 1 до переданного
return $(( $RANDOM % $1 + 1 ))
} 
function stoproll() { #Функция для определения ботом, продолжать брать карты или нет. С увеличением счета, бот с большей вероятностью перестанет брать карты
local temp=0
if [ ${1} -ge 21 ]
    then
    temp=1
fi
if [ ${1} -le 10 ]
    then
    temp=0
elif [ ${1} -le 12 ] 
    then
    roll 20
    if [ $? -le 1 ]
        then
        temp=1
    fi
elif [ ${1} -le 15 ]
    then
    roll 10
    if [ $? -le 3 ]
    	then
    	temp=1
    fi
elif [ ${1} -le 18 ]
    then 
    roll 10
    if [ $? -le 6 ]
    	then 
    	temp=1
    fi
elif [ ${1} -le 20 ]
    then 
    roll 20
    if [ $? -le 19 ]
    	then
    	temp=1
    fi
fi
return $temp

}
over=0 # Количество участников, переставших брать карты
enend=0 # Флаг завершения добора карт для бота
myend=0 # Флаг завершения добора карт для вас

enscore=0 #Количество очков
myscore=0 

encards=0 #Количество карт
mycards=0 
text=''
while [ $over -ne 2 ] #Продолжаем пока хотя бы один участник берет карты
do
    if [ $enend -ne 1 ] #Бот получает карту и выбирает продолжать брать или нет
	then 
	roll 11 #Получение карты с номиналом от 1 до 11
	enscore=$(( $? + $enscore ))
	encards=$(( 1 + $encards ))
	stoproll $enscore
	enend=$?

    fi

    if [ $enend -ne 1 ] #Сообщение в зависимости от выбора бота
    	then 
    	text="Enemy continues rolling with $encards cards\n"
    	else 
    	text="Enemy stops to roll with $encards cards\n"
    fi
    text="${text}You have $myscore points and $mycards cards"	

    if [ $myend -ne 1 ] #Выбираем продолжать брать карты или нет, после чего берём, в случае положительного ответа
    	then
        dialog --title "Continue picking up cards?" --yesno "$text" 10 40
        myend=$?
    	if [ $myend -ne 1 ];
    	then
    	    roll 11 #Получение карты с номиналом от 1 до 11
    	    myscore=$(( $? + $myscore ))
    	    mycards=$(( 1 + $mycards ))
	fi
    fi
    over=$(( $myend + $enend ))
    
done 
if [ $enscore -gt 21 ] #Выбор победителя
    then
    if [ $myscore -gt 21 ]
    	then
    	if [ $enscore -gt $myscore ]
    	    then
    	    text='You won'
    	elif [ $myscore -gt $enscore ]
    	    then
    	    text="You lost"
    	 
    	else
    	    text="Draw"
    	fi
    
    else
    text="You won" 
    fi
else
    if [ $myscore -gt 21 ]
    then text='You lost'
    else	
    	if [ $enscore -gt $myscore ]
    	then
    	text="You lost"
    	elif [ $myscore -gt $enscore ]
    	then
    	text="You won" 
    	else
    	text="Draw"
    	fi	
    fi
fi 
dialog --title "$text" --msgbox "Enemy score = ${enscore}\nYour score = ${myscore}" 10 40 #Вывод результата игры

