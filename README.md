# embox

A small tool to encase input in a box, with a handful of options.

## Installation

1. `$ shards build --release`
2. Move the resulting binary to your PATH

## Usage

With no options: embox will soak up STDIN until EOF, wrap it in box drawing characters, then print out the new result.

With the `--title` flag enabled, the first line of input will be considered the title. The title will be printed in its own box above the body box. These two boxes will share a side. To visualize it: if the title is shorter than the body's width, then it will look a bit like a left-aligned tab.

## Contributors

- [Will Lewis](https://github.com/your-github-user) - creator and maintainer
