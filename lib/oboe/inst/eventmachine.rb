# Copyright (c) 2014 AppNeta, Inc.
# All rights reserved.

module Oboe
  module Inst
    module EventMachine
      def self.included(klass)
        # We wrap two of the Redis methods to instrument
        # operations
        ::Oboe::Util.method_alias(klass, :defer, ::EventMachine)
      end

      def defer_with_oboe op = nil, callback = nil, &blk
        if Oboe.tracing?
          context = Oboe::Context.toString

          wrapped_op = op
          wrapped_blk = blk

          if op
            wrapped_op = Proc.new {
              Oboe::Context.fromString(context)
              # Oboe.flags[:deferred] = true or check reactor_thread?
              # Async flag?
              # handle op & callback?
              result = op.call
              Oboe::Context.clear

              result
            }
          elsif blk
            wrapped_blk = Proc.new {
              Oboe::Context.fromString(context)
              # Oboe.flags[:deferred] = true or check reactor_thread?
              # Async flag?
              # handle op & callback?
              result = blk.call
              Oboe::Context.clear

              result
            }
          end
          defer_without_oboe(wrapped_op, callback, &wrapped_blk)
        else
          defer_without_oboe(op, callback, &blk)
        end
      end

      module Deferrable
        def self.included(klass)
          # We wrap two of the Redis methods to instrument
          # operations
          ::Oboe::Util.method_alias(klass, :callback, ::EventMachine::Deferrable)
        end

        def callback_with_oboe &block
          if Oboe.tracing?
            context = Oboe::Context.toString

            wrapped_block = Proc.new {
              Oboe::Context.fromString(context)
              block.call
            }

            callback_without_oboe &wrapped_block
          else
            callback_without_oboe &block
          end
        end
      end
    end
  end
end

if Oboe::Config[:eventmachine][:enabled]
  Oboe.logger.info "[oboe/loading] Instrumenting eventmachine" if Oboe::Config[:verbose]
  ::Oboe::Util.send_include(::EventMachine, ::Oboe::Inst::EventMachine)
  ::Oboe::Util.send_include(::EventMachine::Deferrable, ::Oboe::Inst::EventMachine::Deferrable)
end