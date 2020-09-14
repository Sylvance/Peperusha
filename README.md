# Peperusha

Mpesa Client with better error handling and edge case protection.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peperusha'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install peperusha

## Usage
### Intro
    NOTE: All the result below will reponsd to these;
    - ```
        result.success? # either true or false
        result.errors # an array of strings describing the errors
    ```

    To use `peperusha` first set the client credentials with:
    - ```
        result = Peperusha::SetCredentials.call(
            token: token,
            secret: secret
        )
        result.token # returns the token to be used henceforth
    ```

### Setting callback urls
    For customer to business send money do:
    - ```
    Peperusha::SetCallbackUrls.call(
        token: token,
        callback1: callback1,
        callback2: callback2,
        callback3: callback3,
        callback4: callback4
    )
    ```

### Sending
    For customer to business send money do:
    - ```
    Peperusha::CustomerToBusiness.call(
        token: token,
        amount: amount,
        customer_phone_number: customer_phone_number,
        business_till_number: business_till_number
    )
    ```

    For business to customer send money do:
    - ```
    Peperusha::BusinessToCustomer.call(
        token: token,
        amount: amount,
        customer_phone_number: customer_phone_number,
        business_till_number: business_till_number
    )
    ```

### Receiving
    For business to make customer phone get request to send money do:
    - ```
    Peperusha::LipaNaMpesa.call(
        token: token,
        amount: amount,
        customer_phone_number: customer_phone_number,
        business_till_number: business_till_number
    )
    ```

### Inquiry
    For customer to business send money do:
    - ```
    Peperusha::TransactionInquiry.call(
        token: token,
        transaction_code: transaction_code
    )
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sylvance/peperusha. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/sylvance/peperusha/blob/master/CODE_OF_CONDUCT.md). Other issues contact `peperusha.kakitu@gmail.com`.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Peperusha project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sylvance/peperusha/blob/master/CODE_OF_CONDUCT.md).
