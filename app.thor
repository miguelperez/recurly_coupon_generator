require "./environment.rb"

class Codes < Thor
  desc "generate", "Generates random codes."
  method_option :code_lengh,
    desc: "The length of the generated code",
    type: :numeric,
    aliases: "-L",
    default: "8"
  method_option :number_of_codes,
    desc: "The number of codes to generate",
    type: :numeric,
    aliases: "-N",
    default: "10"
  method_option :to_file,
    desc: "Prints the generated codes to a file",
    type: :boolean,
    aliases: "-f",
    default: true
  def generate
    number_of_codes = options.number_of_codes.to_i
    length = options.code_lengh.to_i

    puts "Generating #{number_of_codes} code(s) with a length of #{length} character(s)"
    codes = []
    (1..number_of_codes).to_a.each do |n|
      codes << Devise.friendly_token.first(length)
    end

    if options.to_file
      CSV.open("codes_#{Time.now.to_s}.csv", "w") do |csv|
        codes.each do |code|
          csv << [code]
        end
      end
    end
  end

  desc "test", "uniquenes of codes"
  def test
    a = invoke :generate, ["1000", "-L 8"]
    # a = %w(p7pXjoyJy uV6ykuE62 xmse1HnbB ZusMFWSYL AG2ai9ppg DTzFpnZUx dUeMDGLZu Xq1EUVEjd whbtGTpJF QkqExzso3 zWZYXEcj6 yy8kqihxs 9GdNaadqU yVVLyGMxe cpbnunuYw pxarQXgoy mwzBaH5Wi srwwYSDyV 3JoDxyshz W9QE82cLN yTAkDyx3X L9wuU9gjP gCdsfSxNu ExXYuuRwq F3UGgV6Wh 4AN8vGeXq bCqRFsX4N kyANifNvf RTxpvJXBV SYnrnH9ZM zsFSFwLrV qtH7cPTtw FVJZsuMnv 9Y3VH8J8U xZJ65AiqL nCRRUB3tC sRdqGfP9p KYUm1Znhq Hyxd57zqs qa2974exz AM8APUE5z pQgXP2xm3 KxdhUxqik bzu7zZmsp WxBJ6AJyy ZRq5MPoCy ZMyYTBUjZ wMP82rDEk Di4Rq14yj 5znuViFNs C53sXNWKq P9vEE3sXu g8LBibrHQ MSLczFX6q d5spKbQW6 JRPsmyERq KwrXQsV5p opaYjW4wX DJsuLU3iQ TobS8xetL PkpgmJVxd 7K1JVcxsn wjoo2AxT2 meGm7Rsy4 11xudrv2o KWP46YpuU sVYjTFszF j3x1Prsy9 itL5bvkLC Cq8HkZd92 Kqp97kzqp 1PZnMEUVb mQrjBzYZd xrzRU4Vv4 NADvS4UwJ MH3Xpaw22 hp39MsHAs 7zHvUVX1p 4byHHgxzm QQevaXsTy 6Fsn53qeW JYBWPBdsu yEq3vAgtK 2XXByhjyq FosHmScfH V16uNpuXp pEbx5JCxp qQWaqNjGH EpMx397An j3akwoWJB xn8b6gxp9 xE4TZkwFx KP8jzsdDP CP5NeW5qo JD9jVPXs3 HfHt1J75z HoLg8U6N9 UnHYtW2dX EyLQE7BqY c8sH53s1q)
    puts a.count
    puts a.uniq.count
  end
end

module Recurly
  class Coupons < Thor
    desc "coupons", "generate coupons in recurly"
    method_option :code_lengh,
      desc: "The length of the generated codes",
      type: :numeric,
      aliases: "-L",
      default: "8"
    method_option :number_of_codes,
      desc: "The number of codes to generate",
      type: :numeric,
      aliases: "-N",
      default: "10"
    def coupons
      number_of_codes = options.number_of_codes.to_i
      length = options.code_lengh.to_i
      _coupons = invoke :generate, [number_of_codes, length]
      _coupons.each do |coupon|
        # upload coupon to recurly
      end
    end

    desc "list API_KEY", "List the coupons you have in recurly"
    def list(api_key)
      ::Recurly.api_key        = api_key
      ::Recurly::Coupon.find_each do |coupon|
        puts "name: #{coupon.name} code: #{coupon.coupon_code} discount: #{coupon.discount_in_cents.to_s} single_use: #{coupon.single_use} Redeem-By: #{coupon.redeem_by_date}"
      end
    end
  end
end
