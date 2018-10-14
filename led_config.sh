
#!/bin/bash


led(){
       echo " $led_ch For Selection "  
       ledCOM=false

       while [ $ledCOM = false ]
       do 
              echo "1) Turn on"
              echo "2) turn off"
              echo "3) associate with a system event"
              echo "4) associate with the performance of a process"
              echo "5) stop association with a process performance"
              echo "6) quit to main menu"

              read led_sel 

              if [[ $led_sel == 1 ]]
              then 
                    # if 1 is selected it will turn on the led
                    echo 1 | sudo tee  /sys/class/leds/$led_ch/brightness

              elif [[ $led_sel == 2 ]] 
              then 
                     # if 2 is selected it will turn off the led
                     echo 0 | sudo tee  /sys/class/leds/$led_ch/brightness

              elif [[ $led_sel == 3 ]]
              then
                     #if 3 is selected it will call the  systemEVENT function 
                     systemEV
              elif [[ $led_sel == 4 ]]
              then 
                     #if 4 is selected it will call the processMENU function 
                     processMENU

              elif [[ $led_sel == 6 ]] 
              then 
                     #if 6 is selected it while change  the while loop to true and then break 
                     ledCOM=true
                     break
              fi 
       done  

}
systemEV(){
sysQuit=false
#this is the beginning of the event menu 
echo "Associate Led with a system Event: "
select ch_3 in $(cat /sys/class/leds/$led_ch/trigger) Quit  
do 
              for i in $(cat /sys/class/leds/$led_ch/trigger)
              do
                       if [[ $ch_3 = $i ]]
                       then 
                             #if a valid option will be chosen other then quit it chnage it to that trigger and break this menu  
                             sudo sh -c "echo $i > /sys/class/leds/$led_ch/trigger"
                             echo "you selected $i"     
                       fi 
              done
              break
      if [[ $ch_3 = "Quit" ]]
            then 
                   # if Quit is selected it will break out of the menu 
                   sysQuit=true
                   break
            fi        
done 
}

processMENU(){
#this function is almost working just not quite yet 
pQuit=false
echo "Associate LED with the performance of a process"

while [ $pQuit=false ] 
do 

        echo "----------------------------------------"
        echo "Please enter the name of the program to moniter: "
        echo "Cancel"
        #this will gather the input from the user input 
        read pro_ch 
        # this is getting the number of lines from ps -C
        if [[ $pro_ch = $(ps -C $pro_ch | wc -l) ]]
        pro_count=$(ps -C $pro_ch | wc -l) 
        then 
                if [[ $pro_count -gt 2 ]] 
                then 
                      echo "Name Conflict"
                      echo "-------------"
                      echo "I have detected a name conflict. choose one you want to moniter: "
                      ps -C $pro_ch 
                      echo "Quit"
                      for i in $(ps -C $pro_ch) 
                      do 
                           
                            if [[ $pro_ch = $i ]] 
                            then 
                                   echo "run the script in the background"
                            elif [[ $pro_ch == "Quit" ]]
                            then 
                                    break
                            fi
                      
                      done 
                elif [[ $pro_count = 2 ]]
                then
                        echo " run the script in the background"
                
                elif [[ $pro_count = 1 ]]
                then 
                        echo "this program does not exist"
                fi
        elif [[ $pro_ch == "Cancel" ]]
        then 
                 pQuit=true 
                 break
        fi 
done 

} 



main(){
# this is the first menu that is shown 
echo "LED_Konfigurator"
echo "===================="

mainCom=false
#columns is used in conjunction with PS3 and select to define the width of the colums for the menu 
COLUMNS=12
PS3="Select an led to configure: "
select led_ch in $(ls /sys/class/leds) Quit 
do 
       for i in $(ls /sys/class/leds)
               do 
                       if [[ $led_ch = $i ]]
                       #if a option is choosen from the list with will run the led function 
                       then 
                               led
                       fi 
               done
      if [[ $led_ch == "Quit" ]] 
              then 
                     #if Quit is selected it will break from this menu and return to the command line 
                     mainCom=true
                     break 
              fi 

done  
echo "$led_ch has been selected"

}
# this is calling the main fucntion that will be the base for the code 
main 
