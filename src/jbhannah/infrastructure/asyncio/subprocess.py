from asyncio import create_subprocess_exec, create_subprocess_shell
from asyncio.subprocess import Process
from os import environ
from shlex import join
from subprocess import CalledProcessError as _CalledProcessError

from jbhannah.infrastructure import Exception, logger


class CalledProcessError(_CalledProcessError, Exception):
    pass


async def run(*args, watch=False, **kwargs):
    """Run a subprocess with asyncio.create_subprocess_exec."""
    _env = environ

    if watch:
        args = ["watch", "-t", *args]

    if "env" in kwargs:
        _env.update(kwargs["env"])

    logger.debug("Running command {cmd}".format(cmd=join(args)))

    kwargs["env"] = _env
    proc = await (create_subprocess_shell(join(args), **kwargs)
                  if "shell" in kwargs and kwargs["shell"] else
                  create_subprocess_exec(*args, **kwargs))

    return proc, _error_handler(proc, args)


def _error_handler(proc: Process, cmd):
    async def error_handler():
        returncode = await proc.wait()
        if returncode != 0:
            raise CalledProcessError(returncode=returncode, cmd=cmd)

    return error_handler()
