Automux is a highly configurable Tmux automator inspired from similar projects like [Teamocil](https://github.com/remiprev/teamocil) & [Tmuxinator](https://github.com/aziz/tmuxinator).
It provides more advanced configuration options like **getopts integration**, **custom indexes**  and **recipes** while keeping a strong focus on well designed, easily extendable code base.

## Setup

> Run these commands to get Automux started. Its easier to look at the different options later.

```sh
$ gem install automux
$ automux setup
$ automux
```
This should open 3 windows with 3 panes in the first window.

## Session, Windows and Panes

> Automux stays true to tmux conventions for session, windows and panes. The first blueprint indentation level is for the `session`. Session can have many Windows all listed under the key `windows`.

> `windows` is an array of hashes. Just as in Tmux convention, a window has atleast one pane, each hash should atleast have a blank `panes` key defined.

```yaml
name: test
windows:
  - name: blank
  - panes:
```
For e.g., the above blueprint will ask *automux* to create two shell windows with the first one named as blank.

## Session Options

__name__: helps to identify your session when `tmux ls` is run. Its the only field thats compulsory.

__root__: automux will `cd` into this path before starting tmux.

__windows__: an array of windows. A tmux session can be started with no windows defined.

__flags__: session specific flags as given in the tmux man page.

__options__: translates each key-value pair into `set-option`. See `man tmux` for the list of available options.

__hooks__: is an hash with `pre` and `post` keys. The specified commands are run before starting tmux and after tmux is attached respectively.

## Window Options

__name__: optional name field.

__layout__: layout can be one of the preset layouts(even-horizontal, even-vertical, main-horizontal, main-vertical, or tiled) or a custom defined value.

__root__: automux will `cd` into this path before running the adding the pane.

__panes__: is an array of commands for each pane in this window.

__options__: translates each key-value pair into `set-window-option`. See `man tmux` for the list of available options.

__hooks__: is an hash with `pre` and `post` keys. The specified commands are run before and after adding the panes respectively.

__index__: index for the window.

__opt__: makes the window optional. The window will not be created if the flag is not passed.

## Default blueprint

> By default, `automux` uses the blueprint located at `$HOME/.automux/blueprints/default.yml`, which was copied during `automux setup`.

```yaml
name: test
root: ~/
flags: -u2
options:
  status-left: '#S>'
hooks:
  pre: echo 'Starting session'
windows:
  - name: panes
    layout: tiled
    panes:
      - irb
      - top
      - ls
  - name: vim
    hooks:
      pre: 
        - echo 'Starting vim'
    panes: vim
  - name: custom-indexed-window
    index: 1
    hooks:
      post:
        - echo 'Running <%= name %>'
  - name: optional-window
    opt: '-r'
    panes:
      - echo 'Created optional window'
    options:
      automatic-rename: off
      window-status-bg: black
```

When an argument is passed, Automux will look for a blueprint with the specified name. For e.g., the following command will look for `custom.yml` under `$HOME/.automux/blueprints`
```sh
$ automux custom
```
The default blueprint can be changed to suit your needs. To get the original default blueprint back, run `automux setup` again.

## Manage Blueprints

> If __$EDITOR__ is undefined, `vi` will be used to open the blueprint.

##### Create
```sh
$ automux blueprint create custom
```
This will clone the `default.yml` as `custom.yml` and open it in an editor.

##### Edit
```sh
$ automux blueprint edit custom
```

##### Delete
```sh
$ automux blueprint delete custom
```
*aliased to __rm__*

##### Copy
```sh
$ automux blueprint copy default custom
```
*aliased to __cp__*

### Lot more stuff to document...
