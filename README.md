# spotifyAPI
Script to use the Spotify API  
Required dependency: spotifyToken.php  
Written by: Hubert Léveillé Gauvin  
Date: 7 August 2017, last revised 10 August 2017  
##	Getting Started:
	To use the Spotify API, you first need to register on https://developer.spotify.com/
       	Use your regular Spotify username and password to create your developper app. The app can be called anything.
	Alternatively, you can use the Spotify Web API Console at https://developer.spotify.com/web-api/console/

	Open ./spotifyToken.php and modify the file by entering your Spotify developper client ID and client secret. Once this is done, save the file.

	Make spotifyAPI.sh executable

	chmod +x ./spotifyAPI.sh

	Make spotifyToken.PHP executable 

	chmod +x ./spotifyToken.php

===============================================
Using the API for the first time:
===============================================
	Every time you use this script, your client ID and client secret are used to generate a new authentification token. 
	This is done silently but can sometimes take a few seconds.

	The script will prompt you to enter three things: 1) a method of identification, 2) an endpoint, and 3) a Spotify ID.

	1) Method of authentification:

	The method of authentification is indicated on the Spotify website (https://developer.spotify.com/web-api/endpoint-reference/). 
	For researchers, we will almost exclusively use "GET."
	Make sure that the method is written in all caps, as shown in the example.

	2) Endpoints:

	Endpoints are used to indicate what type of information you want to retrieve. 
	Endpoints information is available on the Spotify website (https://developer.spotify.com/web-api/endpoint-reference/)
	Simply copy the endpoint from the website and paste it when prompted. For example: /v1/artists/{id}/top-tracks

	NOTE: All endpoints should beginning with a forward slash (/). 
	On the Spotify website, the forward slash for the "Audio Analysis for a Track" endpoint is missing. 
	You need to manually add the forward slash at the beginning of this endpoint to access this information.

	3) Spotify ID

	IDs can be found in the Spotify app. Simply select the track, album, or artist, click share, and select URI to copy the ID.
	This script accepts IDs in two formats: spotify:track:2Kerz9H9IejzeIpjhDJoYG OR 2Kerz9H9IejzeIpjhDJoYG

	NOTE: Some endpoints require two types of IDs. For example, to get a access to a user's specific playlist, one would need {user_id} and {playlist_id}.
	At the moment, this script does not allow such queries. You can, however, do those manually in the terminal:

	curl -X <METHOD> https://api.spotify.com<ENDPOINT> -H "Authorization: Bearer <TOKEN>"

	NOTE: Some endpoints require a list of IDs. This is currently supported by this script, but the list needs to be comma-separated. For example: 

	2Kerz9H9IejzeIpjhDJoYG,0mt02gJ425Xjm7c3jYkOBn,3ZKRAzNAsiJrBGUM2BX9av,1Ym6aMuT5bliaZMC67AmPp,6eygbzyL6hY8jFQTARDuo9,5QqyRUZeBE04yJxsD1OC0I,03hqMhmCZiNKMSPmVabPLP,269xqcgGTN9PlivhUkOLhX,5UPHeuDP0AnG830Yf3bJJD,7nns9KjsadA1Cx7as2eGNG,0dssTLrqY79Klk6jx2RXCj,3O7p9Itz8PXUoAjD2vmuM6,6VZwnDUMkAZs36g6v9MVQX,7lSdUlVf8k6kxklKkskb1m,3fx5ozORvvTGnSnOhUqrgj,761QvVHTibYjEi2r6A4g4Q

	However, the following format, while accepted for single IDs, is not supported for list of IDs:

	spotify:track:2Kerz9H9IejzeIpjhDJoYG,spotify:track:0mt02gJ425Xjm7c3jYkOBn,spotify:track:3ZKRAzNAsiJrBGUM2BX9av,spotify:track:1Ym6aMuT5bliaZMC67AmPp,spotify:track:6eygbzyL6hY8jFQTARDuo9,spotify:track:5QqyRUZeBE04yJxsD1OC0I,spotify:track:03hqMhmCZiNKMSPmVabPLP,spotify:track:269xqcgGTN9PlivhUkOLhX,spotify:track:5UPHeuDP0AnG830Yf3bJJD,spotify:track:7nns9KjsadA1Cx7as2eGNG,spotify:track:0dssTLrqY79Klk6jx2RXCj,spotify:track:3O7p9Itz8PXUoAjD2vmuM6,spotify:track:6VZwnDUMkAZs36g6v9MVQX,spotify:track:7lSdUlVf8k6kxklKkskb1m,spotify:track:3fx5ozORvvTGnSnOhUqrgj,spotify:track:761QvVHTibYjEi2r6A4g4Q

	See example 4 below for ways to generate a properly formatted list of IDs. 


===============================================
Accessing your results
===============================================
	The results of your last query are automatically saved in a file called lastOutput.json.
	To retrieve specific info from your last query, you can use cat lastOutput.json | jq '<YOURCOMMAND>' 

	Example: cat lastOutput.json | jq '.tempo'

	For more info about jq, visit: https://stedolan.github.io/jq/


===============================================
Examples
===============================================
1) Calculate the number of measures in a song:

	method=GET
	endpoint=/v1/audio-analysis/{id} 
	ID=2vEQ9zBiwbAVXzS2SOxodY

	cat lastOutput.json | jq '.bars[] | "\(.start)"' | wc -l

2) Get the Spotify ID for every songs on an album

	method=GET
	endpoint=/v1/albums/{id}/tracks
	ID=cat

	cat lastOutput.json | jq '.items[] | "\(.uri)"'

3) Get the name and duration (in ms) of every songs on an album

	method=GET
	endpoint=/v1/albums/{id}/tracks
	ID=7xYiTrbTL57QO0bb4hXIKo

	cat lastOutput.json | jq '.items[] | "\(.name), \(.duration_ms)"' 

4) Sort album tracks by ascending tempo

	method=GET
	endpoint=/v1/albums/{id}/tracks
	ID=spotify:album:7xYiTrbTL57QO0bb4hXIKo

	cat lastOutput.json | jq '.items[] | "\(.uri)"' | sed 's/\"//g' | sed 's/.*://g' | tr "\n" ","  # this will give you a comma-separated list of IDs. Like this:

2Kerz9H9IejzeIpjhDJoYG,0mt02gJ425Xjm7c3jYkOBn,3ZKRAzNAsiJrBGUM2BX9av,1Ym6aMuT5bliaZMC67AmPp,6eygbzyL6hY8jFQTARDuo9,5QqyRUZeBE04yJxsD1OC0I,03hqMhmCZiNKMSPmVabPLP,269xqcgGTN9PlivhUkOLhX,5UPHeuDP0AnG830Yf3bJJD,7nns9KjsadA1Cx7as2eGNG,0dssTLrqY79Klk6jx2RXCj,3O7p9Itz8PXUoAjD2vmuM6,6VZwnDUMkAZs36g6v9MVQX,7lSdUlVf8k6kxklKkskb1m,3fx5ozORvvTGnSnOhUqrgj,761QvVHTibYjEi2r6A4g4Q


	method=GET
	endpoint=/v1/audio-features?ids={ids}
	ID=2Kerz9H9IejzeIpjhDJoYG,0mt02gJ425Xjm7c3jYkOBn,3ZKRAzNAsiJrBGUM2BX9av,1Ym6aMuT5bliaZMC67AmPp,6eygbzyL6hY8jFQTARDuo9,5QqyRUZeBE04yJxsD1OC0I,03hqMhmCZiNKMSPmVabPLP,269xqcgGTN9PlivhUkOLhX,5UPHeuDP0AnG830Yf3bJJD,7nns9KjsadA1Cx7as2eGNG,0dssTLrqY79Klk6jx2RXCj,3O7p9Itz8PXUoAjD2vmuM6,6VZwnDUMkAZs36g6v9MVQX,7lSdUlVf8k6kxklKkskb1m,3fx5ozORvvTGnSnOhUqrgj,761QvVHTibYjEi2r6A4g4Q

	cat lastOutput.json | jq '.audio_features[] | "\(.track_href), \(.tempo)"' | sort -rk2 
