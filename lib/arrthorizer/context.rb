require 'ostruct'

module Arrthorizer
  # Make it possible to specify the context that Arrthorizer can evaluate from inside the controller:
  #
  # class MyController
  #   to_prepare_context do |c|
  #     c.defaults do
  #       { bookcase: Cms::Bookcase.find(params[:id]) }
  #     end
  #
  #     c.for_action(:some_action) do
  #       arrthorizer_defaults.merge({ bookcase: Cms::Book.find(params[:id]).bookcase })
  #     end
  #   end
  # end
  #
  # class MyController
  #   to_prepare_context do |c|
  #     c.defaults do
  #       params
  #     end
  #   end
  # end
  #
  # In non-Rails environments:
  #
  # class MySomething
  #   # probably include something like Arrthorizer::Config
  #   to_prepare_context do |c|
  #     c.defaults do
  #       { bookcase: Cms::Bookcase.find(params[:id]) }
  #     end
  #
  #     if params[:action] == :edit
  #       arrthorizer_defaults.merge { author: User.find(params[:author_id] }
  #     end
  #   end
  # end

  class Context < OpenStruct
    ConversionError = Class.new(Arrthorizer::ArrthorizerException)

    def self.build(attrs = {})
      if attrs.is_a? Context
        attrs
      else
        new(attrs)
      end
    end

    def initialize(attrs = {})
      super(attrs.to_hash || attrs.marshal_dump)
    end

    def merge(hash)
      self.class.new(to_hash.merge(hash))
    end

    def to_hash
      marshal_dump
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      to_hash == other.to_hash
    end
  end

module_function
  def Context(contents)
    Context.build(contents)
  rescue NoMethodError
    raise Arrthorizer::Context::ConversionError, "Can't convert #{contents} to an Arrthorizer::Context"
  end
end
