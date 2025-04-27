# A fork of kickstart.nvim tailored for data-scientist and NixOs afficionados

Hi ! This is my fork of the amazing kickstart.nvim project.
If you don't have a neovim config yet, you should definitely make your own fork and play with it.
This repo is mainly for me and the people who use Python and R daily ?( May be
Nixos too ) that I managed to convince to try nvim.

You may find interesting stuff regardless in my config files. Happy hacking !


# Known bugs and workaround
## NixOs specific
### Marksman doesn't work ?

If you're using Nix,you're used to things not working. Marksman doesn't work out of the gate and if you read the logs you may see something related to icu-lib ...

Assuming you have Marksman installed, adding this to your nix config should fix it.
```nix
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    icu
  ];

```
[source](https://github.com/artempyanykh/marksman/issues/381)

# Vim-Slime and Blink 

Vim-Slime is an amazing plugin that allows you to send text from a vim buffer to an other window / shell / ...
I use it mainly with R and Python, writing the code in the Vim buffer and sending it to an interactive console like ipython(python) or Radian(R).

