AsakusaSatellite Treasure Data Logger
-----------------------------------------

## Installation

    $ heroku create
    $ heroku addons:add redistogo:nano
    $ heroku addons:add treasure-data:nano
    $ heroku addons:add scheduler:standard
    $ heroku config:add ASAKUSA_SATELLITE_ENTRY_POINT=http://asakusa-satellite.herokuapp.com/api/v1
    $ heroku config:add ASAKUSA_SATELLITE_API_KEY=YOUR_API_KEY
    $ heroku config:add ASAKUSA_SATELLITE_ROOM_ID=YOUR_ROOM_ID
    $ redis-cli -h hostname -p port -a password put since_id YOUR_OLDEST_MESSAGE_ID_IN_YOUR_ROOM
    $ git push heroku master
    $ heroku addons:open scheduler
    Add job to hourly "bundle exec foreman start"

