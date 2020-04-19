class Enigma
attr_reader :characters

  def initialize(characters = ("a".."z").to_a << " ")
    @characters = characters
  end

  def get_encoded_character(character, shift)
    if @characters.include?(character)
      encoded_characters = @characters.rotate(shift)
      encoded_characters[@characters.index(character)]
    else
      character
    end
  end

  def shift_message(message, shifts, encryption = [])
    message.downcase.each_char do |character|
      encryption << get_encoded_character(character, shifts.first)
      shifts = shifts.rotate(1)
    end
    encryption.join
  end

  def encrypt(message, key = generate_key, date = current_date)
    shifts = Shift.new(key, date).total_shifts.values
    encryption = {}
    encryption[:encryption] = shift_message(message, shifts)
    encryption[:key] = key
    encryption[:date] = date
    encryption
  end

  def decrypt(message, key, date = current_date)
    shifts = Shift.new(key, date).total_shifts.values
    unshifts = shifts.map{|shift_value| shift_value * -1}
    decryption = {}
    decryption[:decryption] = shift_message(message, unshifts)
    decryption[:key] = key
    decryption[:date] = date
    decryption
  end

  def current_date
    now = Time.now
    now.strftime("%m%d%y")
  end

  def generate_number
    rand(100000).to_i
  end

  def generate_key
    key_number = generate_number.to_s
    until key_number.length == 5
      key_number.prepend("0")
    end
    key_number
  end
end
