if status is-interactive; and command -sq terraform
    abbr -a -g tf terraform
    abbr -a -g tfa terraform apply
    abbr -a -g tfp terraform plan
    abbr -a -g tfs terraform state
end
