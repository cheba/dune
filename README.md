# Dune

Embeddable highly concurent XMPP server.

## Introduction

There are many XMPP server implementations aout there. There even a few written
in Ruby. Among them thre are even a good ones. The problem is that the good ones
are built as a stand alone servers. They are very hard to integrate with
anything. Dune is meant to be easy to integrate iwth other software writtein in
Ruby.

## Getting started

Install Dune gem:

```bash
gem install dune
```

Start a server:

```bash
dune
```

Now you have local XMPP server. You can connecto to it by pointing your client
to `lvh.me`.

## Dependancies

Supported runtimes:

* MRI 1.9.3, 2.0
* Rubinius (1.9, 2.0 modes)

It probably works on JRuby too.

It depends on:

* Celluloid/IO
* Nokogiri

## Contributions

Please see [Contribution Document](https://github.com/cheba/dune/blob/prototype/CONTRIBUTING.md)

## License

Dune is released under the MIT license. Check the [LICENSE](https://github.com/cheba/dune/blob/prototype/LICENSE) file for details.
