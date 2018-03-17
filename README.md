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

## Build

```
$ bundle exec middleman build
```

## How is this used?

On ruby-sky2 server, systemd-timer runs `git clone`/`git pull` for this repository and
the following script periodically.

```
bin/run
```

You can assume rbenv(1) is available in $PATH. See https://github.com/benchmark-driver/sky2-infra for details.

## License

MIT License
