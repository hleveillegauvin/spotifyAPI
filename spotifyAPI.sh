#!/bin/sh

# Script to use the Spotify API
# Required dependency: spotifyAccess.php
# Written by: Hubert Léveillé Gauvin
# Date: 7 August 2017, last revised 9 August 2017

# Notes: To use the Spotify API, you first need to register on https://developer.spotify.com/
# 	 Use your regular Spotify username and password to create your developper app. The app can be called anything.
#	 Alternatively, you can use the Spotify Web API Console at https://developer.spotify.com/web-api/console/

#	 The results of your last querry are automatically save in a file called lastOutput.json.
#	 To retrieve specific info from your last querry, you can use cat lastOutput.json | jq '.<key>' 
#	 Example: cat lastOutput.json | jq '.tempo'

# For more info, readme.txt

# debug option
# set -x

echo
echo "This is a simple interface to interact with the Spotify API."
echo
echo "For more info about endpoint references, visit: "
echo "https://developer.spotify.com/web-api/endpoint-reference/"
echo

token=$(./spotifyToken.php | jq '.access_token' | sed 's/\"//g')

read -p "Please enter a method of authentification (e.g. GET, PUT, POST) " method
read -p "Please enter an endpoint (e.g. /v1/audio-features/{id}) " endpoint
read -p "Please enter a Spotify ID (e.g. spotify:track:0mt02gJ425Xjm7c3jYkOBn) " id
echo

id=$(echo $id | sed 's/.*://g') # This allows users to use either spotify:track:0mt02gJ425Xjm7c3jYkOBn or 0mt02gJ425Xjm7c3jYkOBn

#echo "My Spotify ID is: $id"

url=$"https://api.spotify.com$endpoint"

url=$(echo $url | sed "s/{id[s]*}/$id/g")

#echo "My URl is: $url"

curl -X $method $url -H "Authorization: Bearer $token" > lastOutput.json

cat lastOutput.json | jq .