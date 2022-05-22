# embox

A small tool to encase input in a box, with a handful of options.

## Installation

1. `$ shards build --release`
2. Move the resulting binary to your PATH

## Usage

With no options: embox will soak up STDIN until EOF, wrap it in box drawing characters, then print out the new result.

With the `--title` flag enabled, the first line of input will be considered the title. The title will be printed in its own box above the body box. These two boxes will share a side. To visualize it: if the title is shorter than the body's width, then it will look a bit like a left-aligned tab.

The `--margin N` option will change the default horizontal margin (1) to whatever N you enter.
The `--left-margin N` option will change the default left margin (1) to whatever N you enter. This will take precedent over the `--margin` option for the left margin.
The `--right-margin N` option will change the default right margin (1) to whatever N you enter. This will take precedent over the `--margin` option for the right margin.

## Examples

```
% for f in sample/*; do; <$f bin/embox; done
┌────────────────┐
│ a medium title │
│ with a very    │
│ specific width │
│ of a body      │
└────────────────┘
┌────────────────────────┐
│ short title            │
│ with a much wider body │
│ to test this situation │
└────────────────────────┘
┌────────────────────┐
│ quite a long title │
│ with a             │
│ narrow             │
│ body               │
└────────────────────┘
```

```
% for f in sample/*; do; <$f bin/embox --title; done
┌────────────────┐
│ a medium title │
├────────────────┤
│ with a very    │
│ specific width │
│ of a body      │
└────────────────┘
┌─────────────┐
│ short title │
├─────────────┴──────────┐
│ with a much wider body │
│ to test this situation │
└────────────────────────┘
┌────────────────────┐
│ quite a long title │
├────────┬───────────┘
│ with a │
│ narrow │
│ body   │
└────────┘
```

```
% for f in sample/*; do; <$f bin/embox --title --margin 5; done
┌────────────────────────┐
│     a medium title     │
├────────────────────────┤
│     with a very        │
│     specific width     │
│     of a body          │
└────────────────────────┘
┌─────────────────────┐
│     short title     │
├─────────────────────┴──────────┐
│     with a much wider body     │
│     to test this situation     │
└────────────────────────────────┘
┌────────────────────────────┐
│     quite a long title     │
├────────────────┬───────────┘
│     with a     │
│     narrow     │
│     body       │
└────────────────┘
```

## Contributors

- [Will Lewis](https://github.com/your-github-user) - creator and maintainer
