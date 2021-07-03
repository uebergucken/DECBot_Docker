# DECBot_Docker
This docker container provides all the requirements to run DECbot on your own server for use in your own Discord channels.
It is based around wquist/DECbot - _A Discord bot that uses DECtalk text-to-speech_ running on Alpine linux. 
It's a hefty container at ~640MB as python needs build tools for some dependecies. I will work on cleaning it up in future.

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
