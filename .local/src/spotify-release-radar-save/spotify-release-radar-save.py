#!/usr/bin/env python3
"""Spotify backup Release Radar playlist script"""

import os
import base64
from datetime import datetime

import requests
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from dotenv import load_dotenv


load_dotenv()

SPOTIFY_CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID')
SPOTIFY_CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET')
SPOTIFY_REDIRECT_URI = os.getenv('SPOTIFY_REDIRECT_URI')

SCOPE = ["playlist-read-private", "playlist-modify-private", "playlist-modify-public",  "ugc-image-upload"]

sp = spotipy.SpotifyImplicitGrant
# Authenticate with Spotify
sp = spotipy.Spotify(auth_manager=SpotifyOAuth(client_id=SPOTIFY_CLIENT_ID, client_secret=SPOTIFY_CLIENT_SECRET, redirect_uri=SPOTIFY_REDIRECT_URI, scope=SCOPE))

# Get the Release Radar playlist id
playlists = sp.current_user_playlists()
release_radar = next((p for p in playlists["items"] if p["name"] == "Release Radar"), None)

# Create new playlist
today_date = datetime.today().strftime("%d.%m.%Y")
new_playlist_name = f"Release Radar {today_date}"
user_id = sp.current_user()["id"]
new_playlist = sp.user_playlist_create(user_id, new_playlist_name, public=False, description=f"Release Radar backup from {today_date}")

# Copy tracks from Release Radar playlist
tracks = sp.playlist_items(release_radar["id"])["items"]
track_uris = [track["track"]["uri"] for track in tracks]
sp.playlist_add_items(new_playlist["id"], track_uris)

# Copy the album image from Release Radar playlist
response = requests.get(release_radar["images"][0]["url"])
image_base64 = base64.b64encode(response.content).decode("utf-8")
for _ in range(3):
    try:
        sp.playlist_upload_cover_image(new_playlist["id"], image_base64)
    except Exception:
        pass
