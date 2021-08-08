# Environment file for Greeter Unit
set -a

max_width=$(stty size | awk '{ print $2; }') 
max_height=$(stty size | awk '{ print $1; }')

NEWT_COLORS='
  root=,blue
  window=white,red
  border=lightgray,red
  textbox=white,red
  button=white,blue
  title=white,red
' \

if [[ "$max_width" -gt "80" ]]; then
	max_width=80
fi

if [[ "$max_height" -gt "60" ]]; then
	max_height=60
fi

mid_height=$(( max_height * 2 / 3 ))
mid_width=$(( max_width * 2 / 3 ))
