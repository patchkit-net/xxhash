require 'xxhash/version'
require 'xxhash/xxhash'
require 'digest'

module XXhash
  def self.xxh32(input, seed = 0)
    XXhashInternal.xxh32(input, seed)
  end

  def self.xxh64(input, seed = 0)
    XXhashInternal.xxh64(input, seed)
  end

  def self.xxh32_stream(io, seed = 0, chunk_size = 32)
    raise ArgumentError, 'first argument should be IO' if !io.is_a?(IO) && !io.is_a?(StringIO)

    hash = XXhashInternal::StreamingHash32.new(seed)

    while chunk = io.read(chunk_size)
      hash.update(chunk)
    end

    hash.digest
  end

  def self.xxh64_stream(io, seed = 0, chunk_size = 32)
    raise ArgumentError, 'first argument should be IO' if !io.is_a?(IO) && !io.is_a?(StringIO)

    hash = XXhashInternal::StreamingHash64.new(seed)

    while chunk = io.read(chunk_size)
      hash.update(chunk)
    end

    hash.digest
  end

end

module Digest
  class XXHash < Digest::Class
    attr_reader :digest_length

    def initialize(bitlen, seed = 0)
      @hash = case bitlen
      when 32
        XXhash::XXhashInternal::StreamingHash32.new(seed)
      when 64
        @hash = XXhash::XXhashInternal::StreamingHash64.new(seed)
      else
        raise ArgumentError, "Unsupported bit length: %s" % bitlen.inspect
      end

      @digest_length = bitlen
    end

    def update(chunk)
      @hash.update(chunk)
    end

    def digest(val = nil)
      @hash.update(val) if val

      @hash.digest
    end

    def digest!(val = nil)
      result = digest(val)
      @hash.reset

      result
    end

    def reset
      @hash.reset
    end
  end

  class XXHash32 < Digest::XXHash
    def initialize(seed = 0)
      super(32, seed)
    end
  end

  class XXHash64 < Digest::XXHash
    def initialize(seed = 0)
      super(64, seed)
    end
  end
end
