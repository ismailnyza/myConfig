#!/bin/bash

# Default city if none provided or use first argument
CITY="Galle"


WEATHER_INFO=$(curl -s "wttr.in/${CITY}?format=j1")

if [ -z "$WEATHER_INFO" ] || ! echo "$WEATHER_INFO" | jq -e . > /dev/null 2>&1; then
    echo "{\"text\":\" ?\", \"tooltip\":\"Weather unavailable\"}" # Question mark icon
    exit 1
fi

CURRENT_CONDITION=$(echo "$WEATHER_INFO" | jq -r '.current_condition[0]')
AREA=$(echo "$WEATHER_INFO" | jq -r '.nearest_area[0].areaName[0].value')
COUNTRY=$(echo "$WEATHER_INFO" | jq -r '.nearest_area[0].country[0].value')
FEELS_LIKE_C=$(echo "$CURRENT_CONDITION" | jq -r '.FeelsLikeC')
TEMP_C=$(echo "$CURRENT_CONDITION" | jq -r '.temp_C')
WEATHER_DESC=$(echo "$CURRENT_CONDITION" | jq -r '.weatherDesc[0].value')
HUMIDITY=$(echo "$CURRENT_CONDITION" | jq -r '.humidity')
WINDSPEED_KMPH=$(echo "$CURRENT_CONDITION" | jq -r '.windspeedKmph')
WEATHER_CODE=$(echo "$CURRENT_CONDITION" | jq -r '.weatherCode')

ICON="" # Default: Cloud icon
case $WEATHER_CODE in
    113) ICON="☀️";; # Sunny
    116) ICON="⛅";; # Partly cloudy
    119|122) ICON="☁️";; # Cloudy / Overcast
    143|248|260) ICON="🌫️";; # Fog
    176|263|266|293|296|353) ICON="🌦️";; # Patchy rain
    179|182|281|284|299|302|305|308|311|350|356|359) ICON="🌧️";; # Rain
    200|386|389) ICON="⛈️";; # Thundery outbreaks
    227|320|323|326|329|332|335|338|368|371|392|395) ICON="❄️";; # Snow / Sleet / Ice
    *) ICON="";;
esac

TEXT="${ICON} ${TEMP_C}°C"
TOOLTIP="<b>${WEATHER_DESC} in ${AREA}, ${COUNTRY}</b>\nFeels like: ${FEELS_LIKE_C}°C\nWind: ${WINDSPEED_KMPH} km/h\nHumidity: ${HUMIDITY}%"

echo "{\"text\":\"${TEXT}\", \"tooltip\":\"${TOOLTIP}\", \"class\":\"weather-${WEATHER_CODE}\"}"
