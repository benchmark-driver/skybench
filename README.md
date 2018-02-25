# skybench

A benchmark runner, which generates a static result to host on GitHub Pages.

This is designed to be used on a server that can't be accessible from the Internet
and thus can't host [ruby-bench-web](https://github.com/ruby-bench/ruby-bench-web).

## Setup

```
$ git submodule init && git submodule update
```

## Development

```
$ bundle exec middleman server
```

Open localhost:4567.

## Update results

```
rake mjit_releases
```

## License

MIT License
