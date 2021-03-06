module Enumerable
  # see: http://stackoverflow.com/a/7139631/83386
  def value_at_keypath(keypath)
    keypath = keypath.to_s if keypath.is_a?(KeyPath::Path)

    key, remaining = keypath.split '.', 2

    # if it's an array, call the index
    if self.is_a?(Array)
      match = self[key.to_i]
    else
      match = self[key] || self[key.to_sym]
    end

    if !remaining || match.nil?
      return match
    else
      return match.value_at_keypath(remaining)
    end
  end

  def set_keypath(keypath, value)
    # handle both string and KeyPath::Path forms
    keypath = keypath.to_keypath if keypath.is_a?(String)

    keypath_parts = keypath.to_a
    # Return self if path empty
    return self if keypath_parts.empty?

    key = keypath_parts.shift
    # Just assign value to self when it's a direct path
    # Remember, this is after calling keypath_parts#shift

    if self.is_a?(Array)
      key = key.to_i
    elsif self.has_key?(key.to_sym)
      key = key.to_sym
    end

    if keypath_parts.length == 0
      self[key] = value
      return self
    end

    # keypath_parts.length > 0
    # Remember, this is after calling keypath_parts#shift
    collection = self.value_at_keypath(key)
    collection ||= keypath_parts[0] =~ /^\d{1,10}$/ ? Array.new : Hash.new

    # Remember, this is after calling keypath_parts#shift
    collection.set_keypath(keypath_parts.join('.'), value)

    self[key] = collection

    self
  end
end
