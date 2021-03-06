# DECBot_Docker
This docker container provides all the requirements to run DECbot on your own server for use in your own Discord channels.

It's based around [wquist/DECbot](https://github.com/wquist/DECbot) - _A Discord bot that uses DECtalk text-to-speech_ running on Alpine linux.

DECbot uses a win32 say.exe binary based on a DECTalk 4.1 build, which arguably has 'better' voicing than later versions.

It's a hefty container at ~420MB as it requires xvfb, wine, opus, ffmpeg, python dependencies etc.


NOTE: We are trying to get the original DECTalk code to build on modern linux distros, which will allow us to do-away with wine and open up many possibilities with voice manipulation. If you are experienced in getting C code that spans from 1985-2001 to successfully build, please join us at https://github.com/dectalk

# Installation/config
1. First, a new Discord bot must be set up before the application can be run. Create a new Discord application in the [developer portal](http://discordapp.com/developers/applications/me).
2. Fill in the general information, and note the **Client ID** on this page.
3. Set up your bot in the "Bot" tab. Note the **Token** on this page.
4. Edit docker-compose.yml and provide the **Client ID** and **Token**
5. Run docker-compose build. On the second-to-last step an invite URL will be provided.
6. Paste the invite URL in to your browser and choose which channel to invite the bot in to.
7. Start the docker container with docker-compose up -d
8. Verify your bot is online. Join a voice channel on the server you invited it to.
9. Test using the bot commands outlined in the original [README.md](https://github.com/wquist/DECbot/blob/master/README.md) (ie. !dec talk this is a test)

# Limitations
Per the original code, the bot will respond to commands on the first server it is invited to. If you attempt to invite it in to another server it will not respond on any subsequent servers. 

For now if you want DECbot on multiple servers, then seperate docker containers and seperate applications/bots are required. Make sure to give the container name in docker-compose.yml a unique name for each.

I have forked wquist/DECbot with the hope to get a single bot working across multiple servers. If I manage to get that working then this readme will be updated accordingly.
