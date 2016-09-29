Heavn
======

_Where the camls come from_

This library implements
the [edn](https://github.com/edn-format/edn#discard) data model, and a
parser for the concrete syntax in Ocaml.

Status
------

This library is very much work in progress.

- [X] Data model
- [ ] Scalar types
    - [X] booleans
    - [X] integers
    - [X] strings
    - [ ] characters
    - [X] symbols
    - [X] keywords
    - [ ] floating point numbers
- [X] Structured types
- [ ] Tags
    - [ ] Basic tagging model
    - [ ] Builtin tags
        - [ ] inst
        - [ ] uuid
    - [ ] Tag handlers
    - [ ] Error-reporting and error-free mode when parsing unhandled
          tags
- [ ] Parser
    - [X] Simple rules
    - [ ] Parse complete specification
- [ ] Lexer
- [ ] Package for Opam
    
    
Why do I want this?
-------------------

I don't know. However I know why I do: edn strikes a reasonable
balance between the simplicity of S-expressions — a very good message
format — and human readable configuration languages such as Yaml.

As a consequence, I expect that writing configurations (or in general input
documents) in edn is pretty much as easy and readable as doing so in
the more popular configuration languages, on the other hand I have
good hopes that it is possible to write a correct and complete driver
for edn, which is unlikely to be the case of Yaml, for instance.

Comparison with other Ocaml libraries
-------------------------------------

I know of one other Ocaml library which parses Edn:

- [ocaml-edn](https://github.com/prepor/ocaml-edn/): a complete parser
  of the edn format, but the data model is incorrect:
    - The output type of the parser is not extensible
    - There are no handlers for tags
    - It doesn't define edn element equality
        - Sets and maps allow duplicate keys
    - An alternative implementation for _heavn_ would have been to
      reuse the parser from ocaml-edn, and implement the data model
      and tag handlers as a second pass on the syntax tree it
      produces.

Technical highlights
--------------------

Another reason for this library to exist is that it is rather fun to
write. The data model from edn is extensible: edn has a notion
of
[tagged elements](https://github.com/edn-format/edn#tagged-elements)
which are handled by user-provided functions and can produce a
different data type than the same element, but untagged, would have
produce (their is no direct notion of data type in edn, but different
data types are witnessed by having a different notion of equality). It
does not have to be a data type reachable without tags.

This poses a challenge to typed language where extending a data type
is not a native notion. Ocaml
has
[open variants](http://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec251) though,
which can be used to that effect. It is not quite sufficient though,
because we also need a notion of equality, and open variants do not
have an equality function.

Instead I use a dynamic universal type. This is a well-known trick
which is essentially equivalent to open variants (an element of the
universal type is a pair of a key (which carries the type) and a
value, sealed together with an existential type). There are a number
of folklore implementation, _heavn_ uses one based, fittingly, on an
open variant (in fact an open gadt: it helps with type safety).

The reason to use a universal type is that with a small modification
of the standard implementation, I can make keys carry an equality
function as well (in effect the type `Dyn.t` is only universal among
the types which are equipped with an equality). In fact it requires a
total ordering function for efficiency reasons.
