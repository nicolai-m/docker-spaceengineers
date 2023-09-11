#!/bin/bash
# VARIABLES
GAME_DIR="/appdata/space-engineers/SpaceEngineersDedicated"
INSTANCES_DIR="/appdata/space-engineers/instances"
PLUGIN_DIR="/appdata/space-engineers/plugins"
CONFIG_PATH="${INSTANCES_DIR}/${INSTANCE_NAME}/SpaceEngineers-Dedicated.cfg"
INSTANCE_IP=$(hostname -I | sed "s= ==g")


echo "-------------------------------INSTALL & UPDATE------------------------------"
/usr/games/steamcmd +force_install_dir ${GAME_DIR} +login anonymous +@sSteamCmdForcePlatformType windows +app_update 298740 +quit

echo "---------------------------------UPDATE CONFIG-------------------------------"
# update IP to host external ip
CURRENT_IP=$(grep -oEi '<IP>(.*)</IP>' ${CONFIG_PATH} | sed -E "s=<IP>|</IP>==g")
sed -i "s=<IP>.*</IP>=<IP>${INSTANCE_IP}</IP>=g" ${CONFIG_PATH}

# update world save path
CURRENT_WORLDNAME=$(grep -oEi '<WorldName>(.*)</WorldName>' ${CONFIG_PATH} | sed -E "s=<WorldName>|</WorldName>==g")
SAVE_PATH="Z:\\\\appdata\\\\space-engineers\\\\instances\\\\${INSTANCE_NAME}\\\\Saves\\\\${CURRENT_WORLDNAME}";
sed -E -i "s=<LoadWorld />|<LoadWorld.*LoadWorld>=<LoadWorld>${SAVE_PATH}</LoadWorld>=g" ${CONFIG_PATH}

# update SteamPort
CURRENT_STEAM_PORT=$(grep -oEi '<SteamPort>(.*)</SteamPort>' ${CONFIG_PATH} | sed -E "s=<SteamPort>|</SteamPort>==g")
sed -E -i "s=<SteamPort />|<SteamPort.*SteamPort>=<SteamPort>$STEAM_PORT</SteamPort>=g" ${CONFIG_PATH}

# update ServerPort
CURRENT_SERVER_PORT=$(grep -oEi '<ServerPort>(.*)</ServerPort>' ${CONFIG_PATH} | sed -E "s=<ServerPort>|</ServerPort>==g")
sed -E -i "s=<ServerPort />|<ServerPort.*ServerPort>=<ServerPort>$SERVER_PORT</ServerPort>=g" ${CONFIG_PATH}

# update RemoteApiPort
CURRENT_REMOTE_API_PORT=$(grep -oEi '<RemoteApiPort>(.*)</RemoteApiPort>' ${CONFIG_PATH} | sed -E "s=<RemoteApiPort>|</RemoteApiPort>==g")
sed -E -i "s=<RemoteApiPort />|<RemoteApiPort.*RemoteApiPort>=<RemoteApiPort>$REMOTE_API_PORT</RemoteApiPort>=g" ${CONFIG_PATH}

echo "---------------------------------UPDATE PLUGINS------------------------------"
PLUGIN_COUNT=$(ls -1 ${PLUGIN_DIR}/*.dll | wc -l)
echo "Found ${PLUGIN_COUNT} plugins in ${PLUGIN_DIR}"

if [ "${PLUGIN_COUNT}" -gt "0" ]; then 
  PLUGINS_STRING="<Plugins>$(ls -1 /appdata/space-engineers/plugins/*.dll |\
  sed -E "s=(.+\.dll)=<string>\1</string>=g" |\
  tr -d "\n" )</Plugins>"
else
  PLUGINS_STRING="<Plugins />"
fi

sed -E -i "s=<Plugins />|<Plugins.*Plugins>=${PLUGINS_STRING}=g" ${CONFIG_PATH}

echo "-----------------------------CURRENT CONFIGURATION---------------------------"
echo "GAME_DIR=$GAME_DIR"
echo "CONFIG_PATH=$CONFIG_PATH"
echo "INSTANCE_IP=$INSTANCE_IP"
echo "CURRENT_IP=$CURRENT_IP"
echo "CURRENT_WORLDNAME=$CURRENT_WORLDNAME"
echo "STEAM_PORT=$CURRENT_STEAM_PORT"
echo "SERVER_PORT=$CURRENT_SERVER_PORT"
echo "REMOTE_API_PORT=$CURRENT_REMOTE_API_PORT"
echo "SAVE_PATH=$SAVE_PATH"
## END UPDATES ##
wine --version
echo "----------------------------------START GAME---------------------------------"
rm ${INSTANCES_DIR}/${INSTANCE_NAME}/*.log
cd ${GAME_DIR}/DedicatedServer64/
wine SpaceEngineersDedicated.exe -noconsole -ignorelastsession -path Z:\\appdata\\space-engineers\\instances\\${INSTANCE_NAME}
echo "-----------------------------------END GAME----------------------------------"
sleep 1
echo "-----------------------------------BYE !!!!----------------------------------"