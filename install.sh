#!/bin/sh

info=$(cat << EOF
install.sh install-data|install-script|uninstall-data|uninstall-script
EOF
)

local_home="${XDG_LOCAL_HOME:-$HOME/.local}"
data_home="${XDG_DATA_HOME:-$local_home/share}"
bin_home="${XDG_BIN_HOME:-$local_home/bin}"

clnv_install_data() {
    project_home="$(dirname "$0")"

    if [ ! -d "$data_home" ]; then
        mkdir -p "$data_home"
    fi

    clnv_home="$data_home/clnv"
    if [ ! -d "$clnv_home" ]; then
        mkdir -p "$clnv_home"
    fi
    clnv_script_home="$clnv_home/scripts"
    if [ -d "$clnv_script_home" ]; then
        rm -rf "$clnv_script_home"
    fi
    if [ ! -d "$clnv_script_home" ]; then
        mkdir -p "$clnv_script_home"
    fi
    if ! cp -f "$project_home/clnv" "$clnv_home"; then
        echo "error: installing clnv script" >&2
        exit 1
    fi
    if
        ! find "$project_home/scripts" \
            -type f \
            -exec cp -f "{}" "$clnv_script_home" \; >/dev/null
    then
        echo "error: installing scripts" >&2
        exit 1
    fi

    echo "clnv data successfully installed"
}

clnv_install_script() {
    if [ -z "$CLN_BIN" ]; then
        echo "error: set CLN_BIN" >&2
        exit 1
    fi
    # shellcheck disable=SC2086
    if ! command -v $CLN_BIN >/dev/null 2>&1; then
        echo "error: $CLN_BIN is not a command" >&2
        exit 1
    fi

    if [ -z "$CLNV_NAME" ]; then
        echo "error: set CLNV_NAME" >&2
        exit 1
    fi
    if printf "%s\n" "$CLNV_NAME" | grep "[[:space:]]" >/dev/null 2>&1; then
        echo "error: $CLNV_NAME should not contain spaces" >&2
        exit 1
    fi

    if [ ! -d "$bin_home" ]; then
        mkdir -p "$bin_home"
    fi

    clnv_install_file="$bin_home/$CLNV_NAME"
    if ! touch "$clnv_install_file"; then
        echo "error: creating $clnv_install_file" >&2
        exit 1
    fi
    if ! chmod u+x "$clnv_install_file"; then
        echo "error: setting permission on $clnv_install_file" >&2
        exit 1
    fi
    clnv_install_file_content=$(cat << EOF
#!/bin/sh

export CLN_BIN="$CLN_BIN"

"\${XDG_DATA_HOME:-\${XDG_LOCAL_HOME:-\$HOME/.local}/share}/clnv/clnv" "\$@"
EOF
    )
    printf "%s\n" "$clnv_install_file_content" > "$clnv_install_file"

    echo "clnv script $CLNV_NAME successfully installed"
}

clnv_uninstall_data() {
    clnv_home="$data_home/clnv"
    if [ -e "$clnv_home" ]; then
        if ! rm -rf "$clnv_home"; then
            echo "error: removing $clnv_home" >&2
            exit 1
        fi
        echo "clnv data successfully uninstalled"
    else
        echo "clnv data was not installed"
    fi
}

clnv_uninstall_script() {
    if [ -z "$CLNV_NAME" ]; then
        echo "error: set CLNV_NAME" >&2
        exit 1
    fi
    if printf "%s\n" "$CLNV_NAME" | grep "[[:space:]]" >/dev/null 2>&1; then
        echo "error: $CLNV_NAME should not contain spaces" >&2
        exit 1
    fi

    clnv_install_file="$bin_home/$CLNV_NAME"
    if [ -f "$clnv_install_file" ]; then
        if ! rm -f "$clnv_install_file"; then
            echo "error: removing $clnv_install_file" >&2
            exit 1
        fi
        echo "$CLNV_NAME successfully uninstalled"
    else
        echo "$CLNV_NAME was not installed"
    fi
}

if [ "$#" -lt 1 ]; then
    echo "error: insert action" >&2
    exit 1
fi
action="$1"
shift 1

case "$action" in
    -h|--help)
        echo "$info"
        exit 0
    ;;
    install-data)
        clnv_install_data "$@"
    ;;
    install-script)
        clnv_install_script "$@"
    ;;
    uninstall-data)
        clnv_uninstall_data "$@"
    ;;
    uninstall-script)
        clnv_uninstall_script "$@"
    ;;
    *)
        echo "error: action $action not recognized" >&2
        exit 1
    ;;
esac
