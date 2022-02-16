from pathlib import Path

from jbhannah.infrastructure import logger
from jbhannah.infrastructure.asyncio.subprocess import run


async def run_command(*args, **kwargs):
    terraform_path = Path.cwd().joinpath("terraform").resolve()

    cmd = ["terraform", "-chdir={path}".format(path=terraform_path)]
    logger.debug("Running Terraform with arguments %s", " ".join(args))

    _, done = await run(*cmd, *args, **kwargs)
    await done
