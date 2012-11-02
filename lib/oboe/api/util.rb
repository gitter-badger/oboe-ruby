# Copyright (c) 2012 by Tracelytics, Inc.
# All rights reserved.

module Oboe
  module API
    module Util
      BACKTRACE_CUTOFF = 100

      # Internal: Check whether the provided key is reserved or not. Reserved
      # keys are either keys that are handled by liboboe calls or the oboe gem.
      #
      # key - the key to check.
      #
      # Return a boolean indicating whether or not key is reserved.
      def valid_key?(key)
        !%w[ Label Layer Edge Timestamp Timestamp_u ].include? key.to_s
      end

      # Internal: Get the current backtrace.
      #
      # ignore - Number of frames to ignore at the end of the backtrace. Use
      #          when you know how many layers deep in oboe the call is being
      #          made.
      #
      # Returns a string with each frame of the backtrace separated by '\r\n'.
      def backtrace(ignore=1)
        frames = Kernel.caller
        frames_len = frames.size
        if frames_len - ignore > BACKTRACE_CUTOFF
          frames[ignore, BACKTRACE_CUTOFF + ignore].unshift("...")
        else
          frames.drop(ignore)
        end.join("\r\n")
      end
    end
  end
end