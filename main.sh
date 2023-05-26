#!/bin/bash
function roll {
return $(( $RANDOM % $1 + 1 ))
}
function stoproll() {
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
over=0
enend=0
myend=0 #podtverjdenie okonchaniya matcha
enscore=0
myscore=0 #points
encards=0
mycards=0 #Cards amount
text=''
while [ $over -ne 2 ]
do
    if [ $enend -ne 1 ]
	then 
	roll 11
	enscore=$(( $? + $enscore ))
	encards=$(( 1 + $encards ))
	stoproll $enscore
	enend=$?

    fi

    if [ $enend -ne 1 ]
    	then 
    	text="Enemy continues rolling with $encards cards\n"
    	else 
    	text="Enemy stops to roll with $encards cards\n"
    fi
    text="${text}You have $myscore points and $mycards cards"	

    if [ $myend -ne 1 ]
    	then
        dialog --title "Continue picking up cards?" --yesno "$text" 10 40
        myend=$?
    	if [ $myend -ne 1 ];
    	then
    	    roll 11
    	    myscore=$(( $? + $myscore ))
    	    mycards=$(( 1 + $mycards ))
	fi
        else	
    	dialog --title "Wait"  20 50
    fi
    over=$(( $myend + $enend ))
    
done
if [ $enscore -gt 21 ]
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
dialog --title "$text" --msgbox "Enemy score = ${enscore}\nYour score = ${myscore}" 10 40

