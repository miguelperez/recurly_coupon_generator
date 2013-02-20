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
  method_option :debug,
    desc: "If set to true, the codes will be printed to the console",
    type: :boolean,
    aliases: "-D",
    default: true
  def generate
    number_of_codes = options.number_of_codes.to_i
    length = options.code_lengh.to_i

    bar = ProgressBar.new(number_of_codes)

    puts "Generating #{number_of_codes} code(s) with a length of #{length} character(s)"
    codes = []
    (1..number_of_codes).to_a.each do |n|
      new_code = Devise.friendly_token.first(length)
      while codes.include?(new_code) == true
        new_code = Devise.friendly_token.first(length)
      end
      p new_code if options.debug
      codes << new_code
      bar.increment!
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
  def test
    number_of_codes = options.number_of_codes.to_i
    length = options.code_lengh.to_i

    a = invoke :generate, ["-N=#{number_of_codes}", "-L=#{length}"]
    puts a.count
    puts a.uniq.count
  end
end

module Recurly
  class Coupons < Thor
    desc "generate", "generate coupons in recurly"
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
    method_option :debug,
      desc: "If set to true, the generated coupon will not be saved",
      type: :boolean,
      aliases: "-D",
      default: true
    def generate(api_key)
      # Setting the api key for recurly
      ::Recurly.api_key        = api_key

      # Getting the values from the options attributes
      number_of_codes = options.number_of_codes.to_i
      length = options.code_lengh.to_i

      bar = ProgressBar.new(number_of_codes)

      # Setting default coupon attributes
      new_coupon_attributes = {
        name: "SXSW 2013",
        discount_in_cents: 50_00,
        redeem_by_date: Date.new(2013, 7, 1),
        max_redemptions: 1,
        single_use: true
      }

      # Generating random coupon codes
      _codes = invoke "codes:generate", ["-N=#{number_of_codes}", "-L=#{length}"]
      _codes.each do |code|
        # upload coupon to recurly
        new_coupon_attributes[:coupon_code] = code
        recurly_coupon = ::Recurly::Coupon.new(new_coupon_attributes)
        if options.debug == false
          # p "uploading coupon #{recurly_coupon.coupon_code} to recurly"
          recurly_coupon.save
        else
          # p "coupon code #{recurly_coupon.coupon_code} not saved in recurly."
        end
        bar.increment!
      end

    end

    desc "list API_KEY", "List the coupons you have in recurly"
    def list(api_key)
      # Setting the api key for recurly
      ::Recurly.api_key        = api_key

      ::Recurly::Coupon.find_each do |coupon|
        if coupon.state == "redeemable"
          puts "name: #{coupon.name} code: #{coupon.coupon_code} discount: #{coupon.discount_in_cents.to_s} single_use: #{coupon.single_use} Redeem-By: #{coupon.redeem_by_date.strftime('%a %d %b %Y')}"
        end
      end
    end
  end
end
