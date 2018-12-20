
main () {
    echo $(mpc volume | grep -oP "[0-9]+")
}

loop () {
    while read -r event; do
        main
    done
}

main
mpc idleloop mixer | loop
