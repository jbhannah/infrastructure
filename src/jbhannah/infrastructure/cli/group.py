from asyncio import run
from functools import wraps
from logging import getLogger
from subprocess import CalledProcessError
from typing import Coroutine, Optional

import click
from click import ClickException

logger = getLogger(__name__)


class ClickCalledProcessError(ClickException):
    """Raised when a subprocess exits with a nonzero return code and causes the
    command to exit with the same code."""
    def __init__(self, err: CalledProcessError):
        super().__init__(err)
        ClickException.exit_code = err.returncode

    def show(self):
        """Mute superfluous return code messages."""


class Group(click.Group):
    """Add asynchronous command support to Click command groups."""
    def command(self, *args, **kwargs):
        """Wraps a function as a Click command, belonging to a group with
        asynchronous command support and exception handling."""
        return _command(super(), *args, **kwargs)


def group(name: Optional[str] = None, **attrs):
    """Shortcut to add a subgroup to a group."""
    return _command(click, name=name, cls=Group, **attrs)


def _command(base: click.Group, **attrs):
    def decorator(func):
        @base.command(**attrs)
        @wraps(func)
        def wrapper(*func_args, **func_kwargs):
            return run(_wrap_function(func, *func_args, **func_kwargs))

        return wrapper

    return decorator


async def _wrap_function(func, *args, **kwargs):
    try:
        result = func(*args, **kwargs)

        if isinstance(result, Coroutine):
            return await result

        return result
    except CalledProcessError as err:
        logger.error(err)
        raise ClickCalledProcessError(err)
