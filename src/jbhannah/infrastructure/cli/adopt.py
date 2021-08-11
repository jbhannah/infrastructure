from logging import getLogger
from typing import List

from click.core import Context
from click.decorators import argument
from jbhannah.infrastructure.click import verbose_option

ADOPT_ENV = {
    "ANSIBLE_HOST_KEY_CHECKING": "false",
    "ANSIBLE_TRANSPORT": "paramiko"
}

logger = getLogger(__name__)


@argument("hostnames", nargs=-1)
@verbose_option(logger)
def adopt(ctx: Context, hostnames: List[str]):
    logger.debug("Adopting hosts {hosts}".format(hosts=", ".join(hostnames)))
