#!/usr/bin/env bash

get_machine_id() {
    if [ "$(uname)" = "Darwin" ]; then
        # Mac: IOPlatformUUIDを取得
       ioreg -rd1 -c IOPlatformExpertDevice \
        | awk -F'"' '/IOPlatformUUID/{print $4}'
       return
    fi
    # Linux: machine-id があればそれ、なければMACアドレス等にフォールバック
    if [ -f /etc/machine-id ]; then
        cat /etc/machine-id
        return
    fi
    ip link | awk '/ether/ {print $2; exit}'
}