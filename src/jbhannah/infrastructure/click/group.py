from asyncio import run
from functools import wraps
from typing import Coroutine, Optional, Type

from jbhannah.infrastructure import Exception

import click
from click import ClickException, Context, pass_context

PROXY_COMMAND_CONTEXT_SETTINGS = {
    "allow_extra_args": True,
    "ignore_unknown_options": True
}


class ClickError(ClickException):
    """Handles cleanly exiting from internal exceptions, while retaining any
    nonzero return codes from called subprocesses."""
    def __init__(self, err: Exception):
        super().__init__(err)
        ClickException.exit_code = err.returncode


class Group(click.Group):
    """Add asynchronous command support to Click command groups."""
    def command(self, *args, **kwargs):
        """Wraps a function as a Click command, belonging to a group with
        asynchronous command support and exception handling."""
        return _command(super(), *args, **kwargs)

    def proxy_command(self, *args, **kwargs):
        """Wraps a function as a Click command that acts as a proxy for an
        underling executable, passing it any unknown arguments received."""
        kwargs.setdefault("context_settings",
                          {}).update(PROXY_COMMAND_CONTEXT_SETTINGS)
        return _ctx_command(super(), *args, **kwargs)


def command(name: Optional[str] = None,
            cls: Optional[Type[click.Command]] = None,
            **attrs):
    """Wraps an async function as a Click command."""
    return _command(click, name=name, cls=cls, **attrs)


def group(name: Optional[str] = None, **attrs):
    """Shortcut to add a subgroup to a group."""
    return _command(click, name=name, cls=Group, **attrs)


def proxy_command(name: Optional[str] = None,
                  cls: Optional[Type[click.Command]] = None,
                  **attrs):
    """Wraps an async function as a Click command that forwards unknown
    arguments to an underlying executable."""
    attrs.setdefault("context_settings",
                     {}).update(PROXY_COMMAND_CONTEXT_SETTINGS)
    return _ctx_command(click, name=name, cls=cls, **attrs)


def _command(base: click.Group, **attrs):
    def decorator(func):
        @base.command(**attrs)
        @wraps(func)
        def wrapper(*func_args, **func_kwargs):
            return run(_wrap_function(func, *func_args, **func_kwargs))

        return wrapper

    return decorator


def _ctx_command(base: click.Group, **attrs):
    def decorator(func):
        @base.command(**attrs)
        @pass_context
        @wraps(func)
        def wrapper(ctx: Context, *func_args, **func_kwargs):
            return run(_wrap_function(func, ctx=ctx, *func_args,
                                      **func_kwargs))

        return wrapper

    return decorator


async def _wrap_function(func, *args, **kwargs):
    try:
        result = func(*args, **kwargs)

        if isinstance(result, Coroutine):
            return await result

        return result
    except Exception as err:
        raise ClickError(err)
