from asyncio import create_subprocess_exec, create_subprocess_shell
from asyncio.subprocess import Process
from os import environ
from shlex import join
from subprocess import CalledProcessError as _CalledProcessError

from jbhannah.infrastructure import InfException, logger


class CalledProcessError(_CalledProcessError, InfException):
    pass


async def run(*args, watch=False, callback=None, **kwargs):
    """Run a subprocess with asyncio.create_subprocess_exec."""
    _env = environ

    if watch:
        args = ["watch", "-t", *args]

    if "env" in kwargs:
        _env.update(kwargs["env"])

    logger.debug("Running command %s", join(args))

    kwargs["env"] = _env
    proc = await (create_subprocess_shell(join(args), **kwargs)
                  if "shell" in kwargs and kwargs["shell"] else
                  create_subprocess_exec(*args, **kwargs))

    return proc, _error_handler(proc, args, callback=callback)


def _error_handler(proc: Process, cmd, callback=None):
    async def error_handler():
        if callback is not None:
            await callback(proc)
        else:
            returncode = await proc.wait()

            if returncode != 0:
                raise CalledProcessError(returncode=returncode, cmd=cmd)

    return error_handler()
