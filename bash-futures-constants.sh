if [ "$BASH_FUTURES_CONSTANTS_DEF" == '' ]; then
    BASH_FUTURES_CONSTANTS_DEF='defined'

    #Locking constants:
    __futures_lock_dir_template='bash_futuresXXXXXX'
    __futures_var_lock_name="__futures_variable_lock"
    __futures_lock_format="<futures_name>,<pid>"
    __futures_lock_check_granularity=1000

    #Table parsing constants
    __futures_rec_divider='/'
    __futures_field_divider=":"
    __futures_incomplete="not-finished"
fi
