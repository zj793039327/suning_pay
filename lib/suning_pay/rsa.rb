#encoding: utf-8
module SuningPay
  module RSA
    #SuningPay 提供的KEY长度为2048
    MAX_ENCRYPT_LENGTH = 245
    MAX_DECRYPT_LENGTH = 256
    #MAX_ENCRYPT_LENGTH = 117
    #MAX_DECRYPT_LENGTH = 128

    #分段加密:加密后结果转16进制
    def self.encrypt_msg(key, message)
      bytes_array = message.unpack("C*")
      input_length = bytes_array.length
      encryt_str, offset, i = "", 0, 0
      begin
        encryt_bytes = bytes_array[offset, MAX_ENCRYPT_LENGTH]
        encryt_str << key.public_encrypt(encryt_bytes.pack("C*")) #加密
        offset = (i += 1) * MAX_ENCRYPT_LENGTH
      end while input_length - offset > 0

      encryt_str.unpack("H*")[0].upcase
      #Base64::strict_encode64(encryt_str)
    end

    #分段解密:解密前转回2进制
    def self.decrypt_msg(key, message)
      #bytes_array = Base64::decode64 message
      message_arr = [message]
      bytes_array = message_arr.pack("H*")

      input_length = bytes_array.length
      decryt_str, offset, i = "", 0, 0
      begin
        decryt_bytes = bytes_array[offset, MAX_DECRYPT_LENGTH]
        decryt_str << key.private_decrypt(decryt_bytes) #解密
        offset = (i += 1) * MAX_DECRYPT_LENGTH
      end while input_length - offset > 0

      decryt_str
    end

    #分段加密:加密后Base64
    def self.encrypt_base64_msg(key, message)
      bytes_array = message.unpack("C*")
      input_length = bytes_array.length
      encryt_str, offset, i = "", 0, 0
      begin
        encryt_bytes = bytes_array[offset, MAX_ENCRYPT_LENGTH]
        encryt_str << key.public_encrypt(encryt_bytes.pack("C*")) #加密
        offset = (i += 1) * MAX_ENCRYPT_LENGTH
      end while input_length - offset > 0

      Base64::strict_encode64(encryt_str)
    end

    #分段解密:解密前Base64解码
    def self.decrypt_base64_msg(key, message)
      bytes_array = Base64::decode64 message

      input_length = bytes_array.length
      decryt_str, offset, i = "", 0, 0
      begin
        decryt_bytes = bytes_array[offset, MAX_DECRYPT_LENGTH]
        decryt_str << key.private_decrypt(decryt_bytes) #解密
        offset = (i += 1) * MAX_DECRYPT_LENGTH
      end while input_length - offset > 0

      decryt_str
    end

  end
end

