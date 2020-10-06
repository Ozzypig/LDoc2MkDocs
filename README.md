# LDoc2MkDocs

A Python package which converts LDoc output into Markdown ready for [MkDocs](https://www.mkdocs.org)

## Requirements

You will need:

  * Python 3 with dependencies listed in [requirements.txt](requirements.txt) installed using pip
  * Lua environment with [LDoc](https://github.com/lunarmodules/LDoc) and [luajson](https://github.com/harningt/luajson) ([Lua for Windows](https://github.com/rjpcomputing/luaforwindows) provides these)
     * The Python [hererocks](https://github.com/mpeterv/hererocks) package can be used to set up a suitable environment. See also: [Makefile.lenv](https://github.com/Ozzypig/Makefile.lenv), a Makefile which can help automate this process with GNU make.

## What's in the Box?

LDoc2MkDocs has two parts: Lua and Python. You'll need to use both in order to turn LDoc comments into Markdown.

### Lua Module

The main Lua module is found in [init.lua](init.lua). It requires [luajson](https://github.com/harningt/luajson) and exposes the `filter` function which is to be provided to LDoc's `--filter` command line argument (you may have to configure your LUA_PATH environment variable for Lua to be able to find this). The purpose of this Lua module is fairly straightforward: it is provided LuaDoc's raw data as a table, strips unnecessary recursive table references and makes a few additions. Finally, it prints the result raw data as JSON. This "doc json" is then provided to the Python package.

This module is linted using [selene](https://github.com/Kampfkarren/selene) ([selene.toml](selene.toml)).

### Python Package

The other part of LDoc2MkDocs is the Python package. It uses [Jinja 2](https://jinja.palletsprojects.com/en/2.11.x/) to render the [Markdown template](doc-templates/template.md) for each API member. The command line interface uses [click](https://click.palletsprojects.com/en/7.x/).

#### Usage

Using `--help` will output the following:

```bash
$ python -m LDoc2MkDocs --help
Usage: __main__.py [OPTIONS] DOC_JSON_PATH OUT_PATH

  Convert a JSON file containing a dump of LDoc data into mkdocs-ready
  markdown files

Options:
  -p, --pretty  Should a prettified copy of the json file be output as well?
  --help        Show this message and exit.
```

#### Output

Once run, the resulting Markdown is placed in `OUT_PATH` (you might want to add some hand-written Markdown files to this directory). Then, invoke [MkDocs](https://mkdocs.org) on this directory to build your documentation!
