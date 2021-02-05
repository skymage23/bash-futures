#!/bin/bash
if [ "$BASH_FUTURES_DEF" == "" ]; then
    BASH_FUTURES_DEF='defined'

    source bash-multi-trap.sh
    source bash-futures-constants.sh
    #The locks here are all mutexes.
    __futures_lock_directory=''
    __futures_table=''
    __futures_rec_counter=0
    
    source bash-futures-errcode.sh
    function __futures_variable_set_lock(){
        while ! __futures_variable_check_lock ||  mkdir "$__futures_lock_directory/$__futures_var_lock_name"; do
            sleep $__futures_lock_check_granularity
	done
    }
    
    function __futures_variable_remove_lock(){
        ! __futures_variable_check_lock && return 0;
        rm -rfd "$__futures_lock_directory/$__futures_var_lock_name"
    }
    
    #returns true if lock exists
    #returns false otherwise.
    function __futures_variable_check_lock(){
         if [ -d "$__futures_lock_directory/$__futures_var_lock_name" ]; then
             return 0
         fi
         return 1
    }
    
    function __futures_reset_variable(){
        while __futures_variable_check_lock; do
            sleep 1000;
        done
        __futures_variable_set_lock
        __futures_table=''
        __futures_table_reccount=0;
        __futurs_variable_remove_lock
    }
    
    function __futures_add_record(){
        local __name = $1
        local __action = $2
	local __temp_filename_template=$__nameXXXXXXX
	local __temp_filename=''

	#This may not work and will DEFINITELY not work outside of Bash.
	! mktemp -q $__temp_filename_template >>> __temp_filename && >&2 echo "Cannot create temp file for $__name" && return 1;

        #Rec = name:action:temp_filename:status
	local rec="$__name$__futures_field_divider$__action$__futures_field_divider$__temp_filename$__futures_field_divider$__futures_incomplete"
        __futures_variable_set_lock

	if [ $__futures_rec_count -gt 0 ]; then
           __futures_table="$__futures_table$__futures_rec_divider$rec"
        else
           __futures_table="$__futures_table$rec"
        fi
        __futures_rec_counter=$((__futures_rec_counter + 1))
        __futures_variable_remove_lock
	return 0
    }

    function __futures_remove_record(){
        local __name=$1
	local __curr_ifs="$IFS"
	local __prev_ifs="$IFS"
	local __new_futures_table=''
	IFS="$__futures_rec_divider"
	__futures_variable_set_lock
	{ 
	    local rec
	    local field
	    local counter=$__futures_rec_counter
	     while [ counter -gt 0 ]; do
		read rec
		{
                     __prev_ifs=$IFS
	             IFS=$__futures_field_divider
		     read field
		     if [ "$field" != "$__name" ]; then
			  if [ $counter -gt 1]; then
                             __new_futures_table="$__new_futures_table$rec$__futures_rec_divider"
		         else
			     __new_futures_table="$__new_futures_table$rec"
                         fi
                     else
                         counter=$((counter - 1))
			 continue;
		     fi
		} <<< $var
	        counter=$((counter - 1))
	    done
	} <<< $__futures_table
	__futures_variable_remove_lock
    }
    
    
    function __futures_get_record(){
        local __name=$1

    
    }
    
    function __futures_get_field_value(){
        local __name=$1
        local __field=$2
    }
    #Note to self: How do I lock reads/writes of the futures_table
    function __futures_update_record(){
         local __name=$1
         local __field=$2
         local __new_value=$3
         __futures_remove_record
	 __futures_add_record
    }
    
    
    function __futures_launch(){
    
    }
    
    function __futures_parse_map(){
        
    }
    
    function __futures_check() {
    
    }
   
    # The "bash_futures" library is intended to be deinitialized after use.
    # However, in an interactive environment, this function and 
    # '__futures_deinitialize' remain defined after the first definition so
    # that the "bash_futures" library can be reloaded and reinitialized 
    # programmatically should it be needed again.

    function __futures_initialize(){
        if [ "$BASH_FUTURES_DEF" = '' ]; then
            . bash_futures.sh
	fi

	touch /tmp/hello.txt
	if [ $? -eq 1 ]; then
            return  1;
	fi
	__futures_lock_directory=''  #Set this value here.
        __multi_trap_add "bash_futures" "__futures_destroy"
    }
    
    function __futures_destroy(){
        #Remove all lock files
        #Reset __futures_variables
    }
    
    function __futures_deinit(){
	 if [ "$BASH_FUTURES_DEF" == '' ]; then
             return 0
	 fi
         #__futures_destroy
         #undefine all references to bash_futures save for this function.
         #and __futures_init
	 #BASH_FUTURES_DEF=''
    }
    
fi
