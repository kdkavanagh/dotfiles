function epoch() {
    local filler=0000000000000000000
    printf -v epochTime '%s\n' "$1${filler:${#1}}"
    if [ ${#epochTime} -gt 20 ]; then echo "Error: Timestamp more granular than nanos apparently.  $epochTime"; return
    else echo $(date -d @`echo $epochTime | cut -c1-10`) and `echo $epochTime | cut -c 11- | xargs printf '%09d' | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'` nanos
    fi
}

function epoch_to_date() {
   echo $(date -d @`echo $1 | cut -c1-10` +'%Y-%m-%d %H:%M:%S')
}
