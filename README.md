vim-zsh-path-completion
=======================

Provides Zsh-style pathname completion in the Vim command line.

Specifically, it will complete each component of pathname independently
up to the first ambiguous match.

Here's an example:

    :edit s/m/a/c/s<C-s>

Will expand to:

    :edit src/myproject/app/controllers/something_controller.rb

So long as there are no ambiguous matches along the way.  You can
provide as much of each component as you want.  This also works:

    :edit sr/my/app/c/so<C-s>

If there are any ambiguous matches, it will complete as much as it can.

You can freely intermingle `<Tab>` and `<C-s>` completion until you get
the path you want.  `<C-s>` doesn't invoke any completion menus; it just
completes what it can.

Installation
------------

Via [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/fweep/vim-zsh-path-completion.git

Mappings
--------

To suppress the key mapping:

    let g:zsh_path_completion_suppress_mappings = 1

To provide your own mapping, bind to `<Plug>ZshPathComplete`.  The default
is:

    cmap <C-s> <Plug>ZshPathComplete

Limitations/Bugs
----------------

It doesn't understand context.  Whereas Vim builtins like `:edit` know
that they need a filename argument, and only do `<Tab>` completion when
appropriate, this will try to expand whatever token is there when you
hit `<C-s>`.

It doesn't handle quotes/spaces/special characters.  That should be fixable.

If a component in the middle of the path is ambiguous, it will discard
everything after the unambiguous prefix (zsh will expand the common
portion and position the cursor at the first differing character,
leaving the rest of the path string intact).

`<C-s>` only works on the end of the command line; if you move the
cursor to the middle and invoke it, you won't get good results.

I hope to address some of these issues.  Soliciting feedback for now.

Please file a [GitHub
issue](https://github.com/fweep/vim-zsh-path-completion/issues) if you find bugs.

A note on clutter
-----------------

I'm not happy about all the Ruby stuff in the top-level directory.  It's
there because [Bundler](http://gembundler.com/) will not allow you to
monitor paths above its root, so I can't use a relative path to
`watch()` for changes in the `plugin` directory.  Bundler also won't
follow symlinks.  If you install the plugin with
[pathogen](https://github.com/tpope/vim-pathogen) (or another Vim package
handler), it doesn't really matter that the directory is cluttered up.
If you don't use pathogen, well...you should.  I'll move everything to a
single `test` directory once I figure out how to make Bundler happy.

Acknowledgements
----------------

This was motivation by a [question on Stack
Overflow](http://stackoverflow.com/questions/15581845/how-to-autocomplete-file-paths-in-vim-just-like-in-zsh)
by Mykle Hansen.  Thanks for the idea, Mykle!

License
-------

Copyright (C) 2013 Jim Stewart

MIT License.  See LICENSE file.
