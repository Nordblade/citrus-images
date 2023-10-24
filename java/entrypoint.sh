#!/bin/bash

cd /home/container

# Print current Java version
JAVA_VER=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///')
echo "Java version: ${JAVA_VER}"

# Make internal Docker IP address available to processes
export INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')

# Utility function to modify startup command
modify_startup() {
  MODIFIED_STARTUP=$(echo "$1" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")
  echo "$MODIFIED_STARTUP"
}

# Modify the startup command
MODIFIED_STARTUP=$(modify_startup "$STARTUP")

# Forge compatibility (if enabled)
if [ "${FORGE_COMPATIBILITY}" = 1 ] && [ -z "$JLINE_ARGS" ] && [ -z "${FORGE_VERSION}" ]; then
    MODIFIED_STARTUP=$(modify_startup "$MODIFIED_STARTUP -Dterminal.jline=false -Dterminal.ansi=true")
    echo -e "\033[1;33mNOTE: \033[0mForge compatibility mode is enabled."
fi

# Log4j2 vulnerability workaround (if enabled)
if [ "${LOG4J2_VULN_WORKAROUND}" = 1 ] && [ -z "${FORGE_VERSION}" ]; then
    MODIFIED_STARTUP=$(modify_startup "$MODIFIED_STARTUP -Dlog4j2.formatMsgNoLookups=true")
    echo -e "\033[1;33mNOTE: \033[0mThe Log4j2 vulnerability workaround has been enabled."
fi

# SIMD operations (if enabled)
if [ "${SIMD_OPERATIONS}" = 1 ] && [ -z "${FORGE_VERSION}" ]; then
    MODIFIED_STARTUP=$(modify_startup "$MODIFIED_STARTUP --add-modules=jdk.incubator.vector")
    echo -e "\033[1;33mNOTE: \033[0mSIMD operations are enabled."
fi

# Forge 1.17.1+ (if FORGE_VERSION is provided)
if [ -n "${FORGE_VERSION}" ]; then
    MODIFIED_STARTUP="java -Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true @libraries/net/minecraftforge/forge/${FORGE_VERSION}/unix_args.txt"
fi

# Aikar flags (if enabled)
if [ "${AIKAR_FLAGS}" = 1 ]; then
    MODIFIED_STARTUP=$(modify_startup "$MODIFIED_STARTUP -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Daikars.new.flags=true")
    echo -e "\033[1;33mNOTE: \033[0mEnabled Aikar's Flags"
fi

# Add garbage collection tuning flags to MODIFIED_STARTUP
if [ "${GARBAGE_COLLECTION_TUNING}" = 1 ]; then
    # Use G1 Garbage Collector (adjust the settings as needed)
    MODIFIED_STARTUP=$(modify_startup "$MODIFIED_STARTUP -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M")
    echo -e "\033[1;33mNOTE: \033[0mGarbage Collection tuning enabled with G1GC."
fi

# Print startup command to console
echo -e "\033[1;33mcustomer@citrusnode:~\$\033[0m ${MODIFIED_STARTUP}"

# Run the server
eval "$MODIFIED_STARTUP"
