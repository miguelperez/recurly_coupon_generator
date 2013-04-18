recurly_coupon_generator
========================

A small client app that generates random coupon codes and sends them to recurly.

Setup
-----

    bundle install

codes
-----
    thor codes:generate  # Generates random codes.
    thor codes:test      # uniquenes of codes

recurly
-------

Please note that for security reasons, this methods receive a debug option which is set to true.
If you want this methods to work properly pass the debug option as false.

    thor recurly:coupons:generate API_KEY  # generate coupons in recurly
    thor recurly:coupons:list API_KEY      # List the coupons you have in recurly


use it at your own risk ;)
