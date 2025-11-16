;#!/system/bin/sh
MODDIR=${0%/*}
cd "$MODDIR"
exec 2>>"$MODDIR/LOG.log"

# Start Time
echo "<$(date)> ReStart" > "$MODDIR/LOG.log"

# Wait boot=1
while [ ! -d "/storage/emulated/0/Android/data" ]; do
    sleep 5
done

# Off SELinux
[ "$(getenforce)" = "Enforcing" ] && setenforce 0 && OffSelinux=1

# Server
if pm list package -3 | grep moe.shizuku.privileged.api >/dev/null 2>&1; then
    # Get Shizuku path
    path=$(pm path moe.shizuku.privileged.api | sed 's|package:||; s|/base.apk||')
    abi=$(getprop ro.system.product.cpu.abilist | cut -f1 -d '-')
    # Run Shizuku
    if [ -d "$path" ]; then
        if "$path/lib/$abi/libshizuku.so" >/dev/null 2>&1; then
            echo "AutoShizuku Server: Shizuku is Run." > "$MODDIR/LOG.log"
        else
            echo "AutoShizuku Server: Start Shizuku Error." > "$MODDIR/LOG.log"
        fi
    else
        echo "AutoShizuku Server: Shizuku PATH not find. Version Not Ok? " > "$MODDIR/LOG.log"
    fi
else
    # No Install Shizuku
    echo "AutoShizuku Server: Shizuku not Install. Please Install the Shizuku." > "$MODDIR/LOG.log"
fi

# Reset SELinux
[ "$OffSelinux" = 1 ] && setenforce 1
