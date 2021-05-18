if status is-interactive; and command -sq brew
    abbr -a -g bb brew bundle
    abbr -a -g bbg brew bundle --global
    abbr -a -g brewc brew cleanup
    abbr -a -g brewh brew home
    abbr -a -g brewi brew info
    abbr -a -g brewI brew install
    abbr -a -g brewL brew leaves
    abbr -a -g brewl brew list
    abbr -a -g brewo brew outdated
    abbr -a -g brews brew search
    abbr -a -g brewu brew upgrade
    abbr -a -g brewx brew uninstall

    abbr -a -g caskh brew home --cask
    abbr -a -g caski brew info --cask
    abbr -a -g caskI brew install --cask
    abbr -a -g caskl brew list --cask
    abbr -a -g casko brew outdated --cask
    abbr -a -g casks brew search --cask
    abbr -a -g casku brew upgrade --cask
    abbr -a -g caskx brew uninstall --cask

    abbr -a -g buc 'brew upgrade; brew cleanup'
end
