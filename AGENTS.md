## Conditional returns

In general, we prefer to use expanded conditionals over guard clauses.

```ruby
# Bad
def todos_for_new_group
  ids = params.require(:todolist)[:todo_ids]
  return [] unless ids
  @bucket.recordings.todos.find(ids.split(","))
end

# Good
def todos_for_new_group
  if ids = params.require(:todolist)[:todo_ids]
    @bucket.recordings.todos.find(ids.split(","))
  else
    []
  end
end
```

This is because guard clauses can be hard to read, especially when they are nested.

As an exception, we sometimes use guard clauses to return early from a method:

* When the return is right at the beginning of the method.
* When the main method body is not trivial and involves several lines of code.

```ruby
def after_recorded_as_commit(recording)
  return if recording.parent.was_created?

  if recording.was_created?
    broadcast_new_column(recording)
  else
    broadcast_column_change(recording)
  end
end
```

## Methods ordering

We order methods in classes in the following order:

1. `class` methods
2. `public` methods with `initialize` at the top.
3. `private` methods

## Invocation order

We order methods vertically based on their invocation order. This helps us to understand the flow of the code.

```ruby
class SomeClass
  def some_method
    method_1
    method_2
  end

  private
    def method_1
      method_1_1
      method_1_2
    end
  
    def method_1_1
      # ...
    end
  
    def method_1_2
      # ...
    end
  
    def method_2
      method_2_1
      method_2_2
    end
  
    def method_2_1
      # ...
    end
  
    def method_2_2
      # ...
    end
end
```

## To bang or not to bang

Should I call a method `do_something` or `do_something!`?

As a general rule, we only use `!` for methods that have a correspondent counterpart without `!`. In particular, we don’t use `!` to flag destructive actions. There are plenty of destructive methods in Ruby and Rails that do not end with `!`.

## Visibility modifiers

We don't add a newline under visibility modifiers, and we indent the content under them.

```ruby
class SomeClass
  def some_method
    # ...
  end

  private
    def some_private_method_1
      # ...
    end

    def some_private_method_2
      # ...
    end
end
```

If a module only has private methods, we mark it `private` at the top and add an extra new line after but don't indent.

```ruby
module SomeModule
  private
  
  def some_private_method
    # ...
  end
end
```

## CRUD controllers

We model web endpoints as CRUD operations on resources (REST). When an action doesn't map cleanly to a standard CRUD verb, we introduce a new resource rather than adding custom actions.

```ruby
# Bad
resources :cards do
  post :close
  post :reopen
end

# Good
resources :cards do
  resource :closure
end
```

## Controller and model interactions

In general, we favor a [vanilla Rails](https://dev.37signals.com/vanilla-rails-is-plenty/) approach with thin controllers directly invoking a rich domain model. We don't use services or other artifacts to connect the two.

Invoking plain Active Record operations is totally fine:

```ruby
class Cards::CommentsController < ApplicationController
  def create
    @comment = @card.comments.create!(comment_params)
  end
end
```

For more complex behavior, we prefer clear, intention-revealing model APIs that controllers call directly:

```ruby
class Cards::GoldnessesController < ApplicationController
  def create
    @card.gild
  end
end
```

When justified, it is fine to use services or form objects, but don't treat those as special artifacts:

```ruby
Signup.new(email_address: email_address).create_identity
```

## Run async operations in jobs

As a general rule, we write shallow job classes that delegate the logic itself to domain models:

* We typically use the suffix `_later` to flag methods that enqueue a job.
* A common scenario is having a model class that enqueues a job that, when executed, invokes some method in that same class. In this case, we use the suffix `_now` for the regular synchronous method.

```ruby
module Event::Relaying
  extend ActiveSupport::Concern

  included do
    after_create_commit :relay_later
  end

  def relay_later
    Event::RelayJob.perform_later(self)
  end

  def relay_now
    # ...
  end
end

class Event::RelayJob < ApplicationJob
  def perform(event)
    event.relay_now
  end
end

## Testing Philosophy

Tests should be business-oriented, not implementation-specific. Test *what* the code does, not *how* it does it.

### Good: Testing Business Behavior

```ruby
# Good - tests what users care about
test "assistant message can contain tool recommendations" do
  message = messages(:assistant_with_recommendations)

  assert message.from_assistant?
  assert message.has_recommendations?
  assert_equal 3, message.recommendations.count

  first_rec = message.recommendations.first
  assert_equal "Notion", first_rec[:name]
end

test "message knows if it is from a user" do
  user_message = messages(:user_message)
  assistant_message = messages(:assistant_message)

  assert user_message.from_user?
  assert_not assistant_message.from_user?
end
```

### Bad: Testing Implementation Details

```ruby
# Bad - tests internal structure, not behavior
test "includes all concerns" do
  message = Message.new
  assert_respond_to message, :user?
  assert_respond_to message, :recommendations
  assert_respond_to message, :has_recommendations?
end

test "validates role inclusion" do
  valid_roles = %w[user assistant system tool]
  valid_roles.each do |role|
    message = Message.new(role: role, chat: chats(:one))
    assert message.valid?
  end
end
```

### Key Principles

1. **Test behavior, not structure** - Don't test that a method exists or that a concern is included. Test what the object does.

2. **Use descriptive method names in tests** - `from_user?` is clearer in test assertions than `user?`

3. **Test real scenarios** - Create fixtures that represent actual use cases (e.g., "assistant_with_recommendations" not "message_three")

4. **Avoid testing validations directly** - Test that invalid data is rejected, but focus on the business rule ("user messages require content") not the mechanism ("validates presence")

5. **Skip "meta" tests** - Don't test that your code has certain modules, methods, or includes. Those break when you refactor even if behavior is identical.
```