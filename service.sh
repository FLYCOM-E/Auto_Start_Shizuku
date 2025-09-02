#!/system/bin/sh
MODDIR=${0%/*}
cd "$MODDIR"
exec 2>>"$MODDIR/LOG.log"

# Start Time
echo "<$(date)> ReStart" > "$MODDIR/LOG.log"

# Print log
RunError="AutoShizuku Server Error: Service Run error. Please Cat the Log"
PackageError="AutoShizuku Server Error: Shizuku not find. Please Cat the Log"
RunOk="AutoShizuku Server: Shizuku is Run"

# Wait boot=1
while true; do
    if [ -d "/storage/emulated/0/Android/data" ]; then
        break
    fi
sleep 5
done

# Off SELinux
if [ "$(getenforce)" = "Enforcing" ]; then
    setenforce 0
    OffSelinux=1
fi

# Server
if $(pm list package -3 | grep moe.shizuku.privileged.api >>/dev/null); then
    
    # Get Shizuku path
    path=$(pm path moe.shizuku.privileged.api | sed 's|package:||; s|/base.apk||')
    abi=$(getprop ro.system.product.cpu.abilist | cut -f1 -d '-')
    
    # Run Shizuku
    if [ -d "$path" ]; then
        if $("$path/lib/$abi/libshizuku.so" >>/dev/null); then
            echo "$RunOk" > "$MODDIR/LOG.log"
            log -p I "$RunOk"
        fi
    else
        echo "$RunError" > "$MODDIR/LOG.log"
        log -p E "$RunError"
    fi
else
    # No Install Shizuku
    echo "$PackageError" > "$MODDIR/LOG.log"
    log -p E "$PackageError"
fi

# Reset SELinux
if [ "$OffSelinux" = 1 ]; then
    setenforce 1
fi

