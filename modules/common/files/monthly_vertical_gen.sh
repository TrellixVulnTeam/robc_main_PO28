#!/bin/bash

#credentials for 
export RTUSER="rt_svc_user"
export RTPASSWD="FN#27?Pq"
#export RTPASSWD="addaa4c8c74bb2a6ae07ba9778669332"
export RTSERVER="https://rt.gorillanation.com/"
 ##### Mysql query to keep verticals and root causes up to date all the time ##
###Testing Phab ###
sql=`which mysql`
sql_u="noctools_r"
sql_pass="2dxIKzSy"
sql_host_prd="vip-sqlrw-rt.tp.prd.lax.gnmedia.net"
#query for verticals 
sql_query="SELECT  cfv.Name  FROM CustomFields AS cf INNER JOIN CustomFieldValues AS cfv ON cf.id = cfv.CustomField WHERE cf.Name =  'Vertical'"
sql_query_rcs="SELECT  cfv.Name  FROM CustomFields AS cf INNER JOIN CustomFieldValues AS cfv ON cf.id = cfv.CustomField WHERE cf.Name =  'Root Cause'"
TODO_verticals=`$sql -u "$sql_u" -p"$sql_pass" -h "$sql_host_prd" -e "$sql_query" rt3 | awk '$NR<1'`
TODO_rcs=`$sql -u "$sql_u" -p"$sql_pass" -h "$sql_host_prd" -e "$sql_query_rcs" rt3 | awk '$NR<1'`
#Color
colors_words()
 {
 esc="\033"
 bold="${esc}[1m"
 q_bold="${esc}[22m"

}

echo "Generating Report..."
#The date is been fixed to be from the first day to the last day of the current month
prv_month=$(date +%Y:%m:%d -d "1 month ago" |  cut -d : -f 2 )
lyear=$(cal $prv_month $(date +%Y -d "1 year ago")| awk '!/^$/{ print $NF }' | awk 'NR == 1 { print }END{ print }'| head -1)
cyear=$(date +%Y)
if [[ $prv_month == "12" ]]
then
	year=$lyear
else 	
	year=$cyear	
fi 
month=$prv_month
fday="01"
lday=$(cal $prv_month $(date +%Y -d "1 month ago") | awk '!/^$/{print $NF}' | tail -1 )
scale=2 #number of decimal places for percentages
declare -A array_total_per_vertical=() #for storing the total percentage of tickets per vertical
declare -A array_total_per_rootcause=() #for storing the total percentage of tickets per root cause

##arrays for both rootcauses and verticals from DB servers
declare -a rcauses=('NULL' $TODO_rcs)   
declare -a Verticals=('NULL' $TODO_verticals)
colors_words

#Body of the message 
printf  "The data in this report was taken from rt.gorillanation.com and was  generated by an automated script (rt_script) it displays the\nticket number of all and each of them, Total of tickets found and the percentage that they represent regarding\nthe Total found with  the propper Vertical\n\n" > $HOME/output

#Function  to resolve  percentages 

bc_solver(){
bc << EOF
scale=2
$@
quit
EOF
}

#calculating percentages
pct(){
        echo "scale = 2; $1 *100 / $2" | bc
}

build_novalue(){
        ticket_no=$(cat "$HOME/Novalue_output" | cut -d : -f 1)
        echo "$ticket_no" > "$HOME/io_ticket"
        while read line 
        do
                rt_Created=$(/usr/local/bin/rt show ticket/$line | grep Created | awk '{print $3,$4,$5,$6}')
                echo "https://rt.gorillanation.com/Ticket/Display.html?id=$line" ticket creation date "$rt_Created" >> "$HOME/io"
	        done < "$HOME/io_ticket"
	printf  "$bold There are $(cat "$HOME/Novalue_output"| wc -l) tickets without vertical assigned. \n Please click on the links below and set the Vertical manually for each ticket and generate the report again.${q_bold}\n\n" > "$HOME/output"
	echo  "`cat "$HOME/Novalue_output" >> "$HOME/output" `"
	printf   "\n These are the links for the tickets \n `cat "$HOME/io"`" >> "$HOME/output"
        #cleaning
        rm -rf "$HOME/io"
        rm -rf "$HOME/io_ticket"

}



#Starting Query's

No_value(){
Novalue_query=$(/usr/local/bin/rt  ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$year-$month-$fday 00:00:00' AND Created <= '$year-$month-$lday 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' AND Subject NOT LIKE 'ERROR:' AND Subject NOT LIKE 'Decom' AND 'CF.{Vertical}' IS '${Verticals[0]}'")

Novalue_rcause=$(/usr/local/bin/rt  ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$year-$month-$fday 00:00:00' AND Created <= '$year-$month-$lday' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' AND Subject NOT LIKE 'ERROR:' AND Subject NOT LIKE 'Decom' AND 'CF.{Root Cause}' IS '${rcauses[0]}'")

if [[ $Novalue_query != "No matching results."  ||  $Novalue_rcause != "No matching results." ]]; then
	echo "$Novalue_query Missing Vertical" >> $HOME/Novalue_output
	sed -i '/matching/d' $HOME/Novalue_output
	echo "$Novalue_rcause Missing Root Cause" >> $HOME/Novalue_output
	sed -i '/matching/d' $HOME/Novalue_output
	build_novalue
	echo "`cat -v $HOME/output`" | mail -s "Monthly Report MISSING! [[vertical/Root cause]] " noc@gorillanation.com
	echo "Report sent successfully!"
	rm -rf "$HOME/Novalue_output"
	exit
fi

}
# Here performing  the query to get the ticket out of rt
percentage() {
	Grand_query=$(/usr/local/bin/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$year-$month-$fday 00:00:00' AND Created <= '$year-$month-$lday 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' AND Subject NOT LIKE 'ERROR:' AND Subject NOT LIKE 'Decom'")
	Total_tickets=$(echo "$Grand_query"| wc -l )
	printf "Total tickets created : $Total_tickets \n Date range: $year-$month-$fday & $year-$month-$lday \n "
	printf "Tickets divided into verticals \n\n"
	x=1
	array_total_per_vertical=()
while [ $x  -lt ${#Verticals[@]} ] 
do
	Vertical_query=$(/usr/local/bin/rt  ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$year-$month-$fday 00:00:00' AND Created <= '$year-$month-$lday 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' AND Subject NOT LIKE 'ERROR:' AND Subject NOT LIKE 'Decom' AND 'CF.{Vertical}' = '${Verticals[x]}'")
if [[ $Vertical_query == "No matching results." ]]; then

	echo "$?" > /dev/null
	else 
	total_vtickets=$(echo "$Vertical_query" | wc -l)
        #here i push elements into the array
	array_total_per_vertical[${Verticals[x]}]=$total_vtickets
	printf "\n Total Tickets created for ${Verticals[x]} is $total_vtickets"
	y=1
	array_total_per_rootcause=()
	while [ $y -lt ${#rcauses[@]} ]
	do
        RootCause_query=$(/usr/local/bin/rt ls -o -Created -t ticket " Queue = 'Q_NOC' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' ) AND Created > '$year-$month-$fday 00:00:00' AND Created <= '$year-$month-$lday 23:59:59' AND Subject NOT LIKE 'ZRM' AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:'  AND Subject NOT LIKE 'ERROR:' AND Subject NOT LIKE 'Decom' AND 'CF.{Vertical}' = '${Verticals[x]}' AND 'CF.{Root Cause}' = '${rcauses[y]}'")
	if [[ $RootCause_query == "No matching results." ]]; then
		
		echo "$?" > /dev/null
		else
		printf   "\n ${rcauses[y]} \n"
		echo "$RootCause_query" | while IFS= read -r line
                do
                        ticket_id="$(cut -d':' -f 1 <<<"$line")"
                        echo "$line https://rt.gorillanation.com/Ticket/Display.html?id=$ticket_id"
                done
                Total_rctickets=$(echo  "$RootCause_query" | wc -l )
                echo "Total tickets for ${rcauses[y]} is $Total_rctickets "
		#here i push elements into the array
		array_total_per_rootcause[${rcauses[y]}]=$Total_rctickets
	fi
	((y++))
	done
	printf "\nVERTICAL/ROOT CAUSE PERCENTAGE:\n"
	for i in "${!array_total_per_rootcause[@]}"
	do
		printf "Percentage of Tickets for Vertical: ${Verticals[x]} on Root Cause: $i  is "
		total_root_cause_percentage=$(pct ${array_total_per_rootcause[$i]} $total_vtickets)
		echo "$total_root_cause_percentage %"
	done
fi
((x++))
done 
printf "\nVERTICAL TICKET PERCENTAGES:\n"
for i in "${!array_total_per_vertical[@]}"
do
	printf "Percentage of Tickets for $i is "
	total_vertical_percentage=$(pct ${array_total_per_vertical[$i]} $Total_tickets)
	echo "$total_vertical_percentage %"
done

#Print link of definition of root cause
		printf "\n\nThe Definition of each Root Cause are in the link below:\n"
		printf "http://docs.gnmedia.net/wiki/Root_Cause_Definitions"
}


No_value
percentage >> $HOME/output
#*2
if [[ -f "$HOME/output" ]];then
	#sending mail using /bin/mail 
        echo "`cat -v $HOME/output`" | mail -s "Monthly Report [[vertical/Root cause]] " noc@gorillanation.com
        echo "Report sent successfully"
        exit 0
else
        echo "Something went wrong the output file of the query does not exits"
fi
                
