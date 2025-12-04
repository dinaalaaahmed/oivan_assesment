class Base62
  CHARSET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars

  def self.encode(num)
    return CHARSET[0] if num == 0
    str = ""
    while num > 0
      str.prepend(CHARSET[num % 62])
      num /= 62
    end
    str
  end
end
