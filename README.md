# Adventures in Immutability

This assignment studies how immutable data structures play out across Elm, Ruby, and Swift.

You will start with an Elm app, doing a modification exercise that will help you understand its structure.

You will then work with Ruby and Swift ports of the core logic from that app. Both use a _mutable_ model, but are otherwise roughly identical to the Elm version. You will study what it takes to make the model _immutable_ in both languages.

As always, start by forking and cloning this repository.


## Part 0: Elm

Goal: Practice reading and working with Elm. Understand the structure of an Elm application.

### Setup

Review [The Elm Architecture](https://guide.elm-lang.org/architecture/). Make sure you have an understanding of Elm’s particular notion of immutable models, messages, and views.

One-time setup:

```bash
cd elm-todo
npm install
```

This will install [elm-live](https://github.com/architectcodes/elm-live#installation). It serves up an elm app in your web browser, and reloads your changes as you make them.

To launch elm-live:

```bash
# Mac, Linux, Windows Powershell maybe?
$(npm bin)/elm-live Todo.elm --output=elm.js --open

# This might work on Windows; please let me know:
.\node_modules\.bin\elm-live Todo.elm --output=elm.js --open
```

Now you can make changes in the code and watch the browser update. Yay!

### Your task

This is a stripped-down version of the [elm-todomvc](https://github.com/evancz/elm-todomvc) demo project.

A programming saying I love:

> Structure your code so it’s easy to delete.

The current version of the app lets you edit a todo item after it’s added by double-clicking on it. **Remove that feature.** After you are done, double-clicking a todo item will do nothing, and it will not be possible to edit an item after it’s added to the list.

This will require careful reading of the code. Make sure you understand where this feature lives in the code, and that you understand what you’re removing. Be careful **not to leave any dead code** that serves no purpose once the feature is gone.

Hints:

- The changes you need to make are in `Todo.elm`. Everything else in that folder is just infrastructure.
- First figure out which parts of the model and which messages relate to this feature. Remove them first.
- Then use Elm’s type checking to see what parts of the update and view code depend on what you just remove. Reason carefully about what also needs to go.
- Pay careful attention when removing view code! What pieces of the surrounding context need to stay? What pieces no longer serve a purpose? (Contact me if you need help understanding the HTML structure.)

## Part 1: Ruby

Goal: Gain insight into how Ruby does and does not facilite immutable data structures. See the relationship between the common style of Elm vs Ruby code and the different features of those two languages.

### Setup

```bash
cd ruby-todo
bundle       # shortcut for `bundle install`
```

Now test:

```bash
bundle exec rake test
```

The tests should all run with one skip:

```
......S..

Finished in 0.002792s, 3223.4958 runs/s, 5014.3267 assertions/s.

9 runs, 14 assertions, 0 failures, 0 errors, 1 skips
```

### Your task

This a Ruby port of the model, message, and update portions of the Elm app. It also includes a super-simple simulation of Elm’s internal engine, located in `lib/engine.rb`. This is a not a fully working app; there is no view code. It is just the guts of the todo app, plus some tests.

This code hews closely to the structure of the Elm version, with one big difference: the model is mutable.

Note the “supports time travel” test at the bottom of `test/todo_test.rb`. If you comment out the “skip” line and let the test run, it will fail. Why? Because the model is mutable, so you can’t keep snapshots of how it used to be along the way.

Your task: **alter the code to use an immutable model** so that the time travel test passes.

Hints:

- You do not need to add or modify any tests.
- It will be easiest if you leave the time travel test alone at first (still skipped), and get the other tests to pass with an immutable model.
- Start by making the model itself immutable by replacing `attr_accessor` with `attr_reader` in `lib/model.rb`.
- You’ll need to modify the `Engine.run_with_history` method to assume that `apply_to` returns a _new_ model instead of changing it in place.
- Now update `lib/messages.rb` to make all the tests pass again.
- Once you have the existing non-skipped tests passing, the time travel test should pass too.

## Part 2: Swift

Goal: Understand how Swift `structs` handle immutability. See the difference between their _syntactic_ similarity to other OO languages like Ruby, and their _semantic_ similarity to Elm.

### Setup

On a Mac, make sure you have Xcode version 9.2 or greater.

On Linux, make sure you have Swift 4.0 or greater. This assignment theoretically works on Linux, although I have not been able to test that. Let me know how it goes!

Reminder: **Swift does not work on Windows.** The lab machines in 254 and 256 should have a working version of Swift installed.

```bash
cd swift-todo
swift test
```

You should see 8 tests passing:

```
Test Suite 'All tests' passed at 2018-04-06 17:23:31.887.
     Executed 8 tests, with 0 failures (0 unexpected) in 0.093 (0.093) seconds
```

If you are on a Mac and you want to use Xcode for editing Swift so you get nice things like autocompletion, run:

```bash
swift package generate-xcodeproj
open Todo.xcodeproj
```

You can run the tests in Xcode with cmd-U.

### Your task

This is a _Swift_ port of exactly the same things as the Ruby project above, and your task is the same: **alter the code to use an immutable model** so that the time travel test passes.

(You will see the time travel test commented out in `Tests/TodoTests/TodoTests.swift`.)

The first step is a little different from Ruby: in `Sources/Todo/Model.swift`, change each `class` to a `struct`.

From there, the process is the same: 

- Modify `runWithHistory` to assume that `apply(to:)` returns a _new_ model instead of changing it in place.
- Update the model and message code so the tests pass again.
- Once you have the existing tests passing, uncomment the time travel test. It should pass too.

You will find that _most_ of the above requires very few code changes. You will, however, run into some vexing problems in `Message.swift`. Contact me for hints!

## Things to Think About

These aren’t to write up, just for you to reflect on:

- Beyond the obvious (static type annotations), are there deep structural differences between the original mutable model code in Ruby and Swift?
- Why was the problem of changing to an immutable model so different in Swift than it was in Ruby?
- What language-level support could Ruby give to be more similar to Swift? Would it be a good idea? What parts of the underlying language model would make that easy or hard? Sensible or not?
- What language-level gymnastics does Swift have to do to make structs be truly value-typed? Where does it depart from familiar OO languages because of this?
- Why didn’t I give you a fully working Ruby web app and Swift web app to correspond to the original one in Elm?
