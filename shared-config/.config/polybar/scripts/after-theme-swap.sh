#!/bin/bash

function restart_applications {
    config_name=$1

    # ------ kill applications ------
    killall -9 polybar
    killall dunst
    killall -9 compton
    killall -9 picom
     
    # ------ restart applications ------
    nitrogen --restore
    bspwm_running=`ps -e | grep bspwm | wc -l` 

    if [ $bspwm_running -gt 0 ]; 
    then
        killall bspc 
        killall bspwmrc 
        killall bspswallow

        # Some default bspwm config (can be overriden by ~/.config/bspwm/autostart)
        bspc config window_gap          20
        bspc config split_ratio          0.6
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
        bspc config single_monocle       false

        $HOME/.config/bspwm/autostart &
        xsetroot -cursor_name left_ptr &
        picom --experimental-backends &
        nitrogen --restore &
        dunst &
        #nohup pidof $HOME/.scripts/bspswallow || $HOME/.scripts/bspswallow &
        
        pgrep bspswallow || nohup ~/.scripts/bspswallow &
        $HOME/.config/bspwm/autostart &

        cp $HOME/.config/polybar/config.bspwm $HOME/.config/polybar/config
    fi

    /bin/neofetch --clean &
    
    killall kitty
    nohup $HOME/.config/polybar/scripts/restart-polybar.sh &

    sleep 0.3
    rm $HOME/.config/sxhkd/sxhkdrc.*
    rm $HOME/.config/polybar/config.*
    nohup floating-term-bspwm.sh &
}

restart_applications $1
