# dummy-antlr4-compiler
University work to build a basic compiler using ANTLR4

Students:
- [José Eduardo ](https://github.com/jeduardo824)
- [João Pedro](https://github.com/sosolidkk)
- [Lucas Rodrigues](https://github.com/marmitoTH)

## Install
```sh
$ sudo apt-get install antlr4 # Debian like
$ sudo pacman -S antlr4 # Arch like
```

## Setting up the enviroment
```sh
$ pip install antlr4-python3-runtime
$ pip install setuptools wheel # Optional
```

## Running
```sh
antlr4 -Dlanguage=Python3 Hello.g4
python main.py input.vis
```