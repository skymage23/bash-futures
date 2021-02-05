source bash-futures-constants.sh

#Initialization_errors:
__futures_err_tmp_nowrite=0
__futures_err_

__futures_err_table="\
0:__futures_err_tmp_nowrite:We cannot write to tmp directory./\
1:__/\
2:__/\
"

__futures_err_message=''
function __futures_errcode_to_string(){
   local __errcode=$1
   local __curr_ifs="$IFS"
   local __prev_ifs="$IFS"
   local __retval=''
   local __code=-1
   local __name=''
   local __message=''
   local __quit=0
   {
       local var
       IFS="$__futures_rec_divider"
       while read var; do
       {
	   {
	       __prev_ifs="$IFS"
	       IFS="$__futures_field_divider"
               read __code __name __message
	       if [ $__code -eq $__errcode ]; then
                   __retval="$__name: $__message"
		   quit=1
               fi
           } <<< $var
           if [ $__quit -eq 1 ]; then
               break;
           fi
       }
       done
   } <<< $__futures_err_table
   IFS="$__curr_ifs"
}
