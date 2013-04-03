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

## Blueprints & Recipes

> The yaml configuration files are called **blueprints** while a logic to translate it into a shell script is called a **recipe**. Automux can be used with different combinations of blueprints and recipes.

## Session, Windows and Panes

> Automux stays true to tmux conventions for session, windows and panes. The first blueprint indentation level is for the `session`. Session can have many Windows all listed under the key `windows`.

`windows` is an array of hashes. Just as in Tmux convention a window has atleast one pane, each hash should atleast have a blank `panes` key defined.

```yaml
name: test
windows:
  - name: blank
  - panes:
```
The above blueprint will ask *automux* to create two shell windows with the first one named as blank.

## Session Options

__name__: helps to identify your session when `tmux ls` is run. Its the only field thats compulsory.

__root__: automux will `cd` to this path before starting tmux.

__windows__: an array of windows. A tmux session can be started with no windows defined.

__flags__: session specific flags as given in the tmux man page.

__options__: translates each key-value pair into `set-option`. See `man tmux` for the list of available options.

__hooks__: is an hash with `pre` and `post` keys. The specified commands are run before starting and attaching session respectively.

## Window Options

__name__: optional name field.

__layout__: layout can be one of the preset layouts(even-horizontal, even-vertical, main-horizontal, main-vertical, or tiled) or a custom defined value.

__root__: automux will `cd` to this path before running the adding the pane.

__panes__: is an array of commands for each pane in this window.

__options__: translates each key-value pair into `set-window-option`. See `man tmux` for the list of available options.

__hooks__: is an hash with `pre` and `post` keys. The specified commands are run before and after adding the panes respectively.

__index__: index for the window.

__opt__: makes the window optional. The window will not be created if the flag is not passed.

## Default Blueprint

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

## Managing Blueprints

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

##### List
```sh
$ automux blueprint list
```
*aliased to __index__*

## Command-line options

> Automux can understand command-line options to make windows optional or provide input at runtime. Lets look at some examples.

```yaml
name: test
root: '-r:'
windows:
  - name: top
    opt: "-t"
    panes: top
```

`automux test` will start Tmux with a window containing *shell*.

`automux test -t` will start Tmux with a window containing *top*.

`automux test -tr projects` will `cd` into the *projects* folder and then launch *top*.

> The option can also be specified inside another command. This can be useful in cases like providing a branch name for a `git pull` at runtime:

```yaml
name: test
windows:
  - name: git
    panes: git pull origin '-r:'
```

* Note: The option needs to be surounded by quotes. It makes Automux's job easier.

## Custom defined window indexes

> Windows can have custom indexes which will be assigned to them at runtime. Lets look at an example.

```yaml
name: test
windows:
  - name: third
    panes: ls
  - name: fourth
    panes: htop
  - name: second
    index: 1
    panes: pwd
  - name: first
    index: 0
    panes: [pwd, echo Hello]
```

Here the windows will be arranged in the order indicated by their names.

#### Base Index

As Automux tries to assign window indexes beforehand, it will overwrite any global **base-index** setting. To use a **base-index**, one would need to let Automux know about it like so:

```yaml
name: test
options:
  base-index: 2
windows:
  - panes: pwd
  - panes: ls
    index: 9
```
Here the indexing will start from 2 onwards.

## The Automux Way

> What would Tmux do?

Automux is built on top of an ruby API for Tmux. Instead of providing a custom key for every possible Tmux option, its approach is to provide direct access to the session/window objects. This gives way for higher levels of customizations like allowing end users to add their own session/window methods and using them in the blueprints or letting them define their own recipes for logic. The following sections will look at some these approaches.

### Hooks with ERB

> Automux provides context specific ERB support for hooks.

```yaml
name: projects
hooks:
  pre: cd ~/<%= name %>
windows:
  - name: automux
    hooks:
      pre:
       - cd <%= name %>
       - pwd
    panes: vim
  - panes: pwd
```

This will execute the following steps

* cd ~/projects
* ... tmux startup stuff
* ... create first window
* cd automux
* pwd   => ~/projects/automux
* vim
* ... create second window
* pwd    => ~/projects

The session/window hooks have access to session and window objects respectively.

### Select/Focus Window

To select a specific window when session is attached, Tmux provides the method `select-window`. Staying true to Tmux conventions, Automux's session object provides `select_window`.
```yaml
name: hooked
hooks:
  post:
    - <%= select_window 'one' %>
windows:
  - name: one
  - name: two
```
This selects the window named 'one' after all windows have been setup. Index number is also an acceptable parameter.

### Link Window

Tmux exposes the `link-window` method to link an existing window with current session.

```yaml
name: test
hooks:
  post:
    - <%= link_window('primary', 'irb', 3)%>
windows:
  - panes: vim
```

This will link a window named *irb* from an existing session named *primary* as 3rd window in current session. The third parameter is optional just like Tmux would do.

## Writing your own Recipe

* `automux setup` copies a sample of the default recipe to `$HOME/recipes/default.sh.erb`. It looks like the following script:

```
cd <%= root %>

= start_server
= new_session

- windows.each do |window|
  = new_window(window)
  = rename_window(window) if window.name

  - if window.has_panes?
    - window.panes.each do |pane|
      = create_pane if pane.index > 0
      = send_keys(window, pane.command)
    - end
  - end
- end

= attach_session
```

Its a simpler form of ERB much like [HAML](https://github.com/haml/haml) without indentation. The ERB is evaluated with session's context. Hence all methods defined for session are available here. Custom recipes can be run like so:

```sh
$ automux default custom_recipe
```
_Here default is the default blueprint name._

* Note: The default recipe comes from the Gem and cannot be overwritten. Running `automux default default` will invoke the recipe defined in the Gem instead of any user defined default. The primary reason for this approach is not the burden end users with the necessity to update their default recipe in future releases.

## Bash Autocompletion

Currently blueprint names can be autocompleted. A dedicated autocompletion shell script is in the pipeline. For now add the following to your `~/.bashrc` to get autocompletion for blueprint names.

```sh
complete -W "$(automux blueprint list)" automux
```

## Coming Up

* Bash Autocompletion for blueprint commands and recipe names.
* Make Session and Window extendable on the client end.
* Blueprint inheritance.

## License

MIT License. See LICENSE.txt for more details.
