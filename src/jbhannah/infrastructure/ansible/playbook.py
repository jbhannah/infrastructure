from logging import getLogger
from pathlib import Path
from typing import List

from jbhannah.infrastructure.asyncio.subprocess import run

logger = getLogger(__name__)


async def run_playbook(playbook: str, selectors: List[str], *args, **kwargs):
    """Run a playbook on the specified list of host selectors."""
    playbook_path = Path.cwd().joinpath(
        "ansible", "{playbook}.yml".format(playbook=playbook)).resolve()

    logger.debug(
        "Running playbook {playbook} on host selectors {selectors}".format(
            playbook=playbook, selectors=",".join(selectors)))

    _, done = await run("pipenv", "run", "ansible-playbook",
                        str(playbook_path), "-l", ",".join(selectors), *args,
                        **kwargs)
    await done
