require 'maybe/version'

# Wrap a value into a Maybe monad (or Optional type). Since monads are chainable
# and every value is wrapped in one, things don't blow up with +NoMethodError+
# on +nil+s.
#
# Useful for retrieving something in deeply nested structures where +nil+s
# could be produced along the way.
#
# @example Simple usage.
#   maybe = Maybe.new('Hello world').upcase.reverse
#   maybe.class  # => Maybe
#   maybe.unwrap # => 'Hello world'
#
#   maybe = Maybe.new(nil).upcase.reverse
#   maybe.class  # => Maybe
#   maybe.unwrap # => nil
#
#   maybe = Maybe.new('Hello world').make_nil.upcase.reverse
#   maybe.class  # => Maybe
#   maybe.unwrap # => nil
#
# @example JSON example evaluation to a string.
#   response = {
#     data: {
#       item: {
#         name: 'Hello!'
#       }
#     }
#   }
#
#   Maybe.new(good_response)[:data][:item][:name].upcase.unwrap # => 'HELLO!'
#
# @example JSON example evaluating to nil.
#   response = {
#     data: {}
#   }
#
#   Maybe.new(good_response)[:data][:item][:name].upcase.unwrap # => nil
class Maybe
  # Wrap a value into a new +Maybe+.
  #
  # @param value [Object] Anything.
  def initialize(value)
    @value = value
  end

  # Return the wrapped value.
  #
  # @example
  #   Maybe.new('Hello').unwrap        # => 'Hello'
  #   Maybe.new('Hello').upcase.unwrap # => 'HELLO'
  #   Maybe.new(nil).upcase.unwrap     # => nil
  #
  # @return [Object]
  def unwrap
    @value
  end

  # Chain another action and return a new value wrapped in a new +Maybe+ or
  # the same +Maybe+ if the old value is a +nil+. Calls +chain+ under the hood.
  #
  # @see #chain
  #
  # @example
  #   Maybe.new('Hello world').upcase.reverse
  #
  # @return [Maybe]
  def method_missing(*args, &block)
    chain do |value|
      value.public_send(*args, &block)
    end
  end

  # Also support +respond_to?+.
  #
  # @example
  #   Maybe.new('Hello world').upcase.reverse.respond_to?(:size) # => true
  #   Maybe.new(nil).upcase.reverse.respond_to?(:size)           # => false
  #
  # @return [Bool]
  def respond_to_missing?(method_name, include_private = false)
    super || @value.respond_to?(method_name, include_private)
  end

  # Chain another action and return a new value wrapped in a new +Maybe+ or
  # the same +Maybe+ if the old value is a +nil+.
  #
  # @example
  #   value = Maybe.new('Hello world')
  #           .chain(&:upcase)
  #           .chain(&:reverse)
  #           .unwrap # => 'DLROW OLLEH'
  #
  #   value = Maybe.new('Hello world')
  #           .chain { |_string| nil }
  #           .chain(&:reverse)
  #           .unwrap # => nil
  #
  # @yieldparam value [Object] Old value goes in the block.
  # @yieldreturn      [Object] New value comes out of the block.
  #
  # @return [Maybe]
  def chain
    # Don't call the block if we are wrapping a nil (hint: that would cause
    # a +NoMethodError+).
    return self if @value.nil?

    # Call the passed block to get the new value and wrap it again.
    new_value = yield @value
    self.class.new(new_value)
  end
end
