if type -q fisher
    function __update_fisher
        fisher update >/dev/null 2>&1 &
    end
end
