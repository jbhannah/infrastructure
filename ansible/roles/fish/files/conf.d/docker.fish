if status is-interactive; and command -sq docker
    abbr -a -g dps docker ps
end

if status is-interactive; and command -sq docker-compose
    abbr -a -g dco docker-compose
    abbr -a -g dcb docker-compose build
    abbr -a -g dcD docker-compose down
    abbr -a -g dcx docker-compose exec
    abbr -a -g dcps docker-compose ps
    abbr -a -g dcf docker-compose pull
    abbr -a -g dcr docker-compose run --rm
    abbr -a -g dcR docker-compose run
    abbr -a -g dcs docker-compose start
    abbr -a -g dcd docker-compose stop
    abbr -a -g dct docker-compose top
    abbr -a -g dcu docker-compose up
end
