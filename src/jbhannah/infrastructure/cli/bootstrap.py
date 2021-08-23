from logging import getLogger
from typing import List

from click import Context, argument
from jbhannah.infrastructure.click import proxy_command, verbose_option

BOOTSTRAP_ENV = {
    "ANSIBLE_HOST_KEY_CHECKING": "false",
    "ANSIBLE_TRANSPORT": "paramiko"
}

logger = getLogger(__name__)


@proxy_command()
@argument("hostnames", nargs=-1, required=True)
@verbose_option(logger)
def bootstrap(ctx: Context, hostnames: List[str]):
    """Bootstrap one or more remote hosts."""
    logger.debug(
        "Bootstrapping hosts {hosts}".format(hosts=", ".join(hostnames)))
