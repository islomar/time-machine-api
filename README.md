# Time Machine API
The API has the next functionality:
* It accepts GET request to /time, returning the current time in ISO8601 format.
* It accepts POST requet to /time, freezing the time to the one sent. From that moment on, all the GET requests will return that frozen time.
    * Returns HTTP status 400 (Bad Request) if the time frozen does not have ISO8601 format


## How to run the tests
Run `rake`


## How to start the web server
* Run `bundle exec rackup`
* You can check everything works through curl:
    * GET: `curl -X GET -i -H "Accept: application/json" "http://localhost:9292/time"`
    * POST:
        * `curl -X POST -i -H "Accept: application/json" -H "Content-Type: application/json" "http://localhost:9292/time/<iso8601-fake-time>" -d ""`,
        * e.g. `curl -X POST -i -H "Accept: application/json" -H "Content-Type: application/json" "http://localhost:9292/time/2018-05-02T12:07:04+02:00" -d ""`



## Future improvements
* In case the app grew, I would start using a DDD approach (splitting application services, etc.) Being so simple for the moment, I don't think it's worthy.
* Probably the time validator should be somewhere else...