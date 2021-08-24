from logging import getLogger
from pathlib import Path
from typing import List

from jbhannah.infrastructure.asyncio.subprocess import run

logger = getLogger(__name__)


async def run_playbook(playbook: str, selector_list: List[str], *args,
                       **kwargs):
    """Run a playbook on the specified list of host selectors."""
    playbook_path = Path.cwd().joinpath(
        "ansible", "{playbook}.yml".format(playbook=playbook)).resolve()
    selectors = ",".join(selector_list)

    logger.debug("Running playbook {playbook}{selectors}".format(
        playbook=playbook,
        selectors=" on host selectors {selectors}".format(
            selectors=selectors) if selectors else ""))

    cmd = ["pipenv", "run", "ansible-playbook", str(playbook_path)]
    if selectors:
        cmd.extend(["-l", selectors])

    _, done = await run(*cmd, *args, **kwargs)
    await done
